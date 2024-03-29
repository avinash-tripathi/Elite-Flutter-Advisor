import 'dart:convert';

import 'package:advisorapp/models/idea.dart';
import 'package:advisorapp/models/vote.dart';
import 'package:advisorapp/service/httpservice.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

class IdeaProvider extends ChangeNotifier {
  bool addingIdea = false;
  bool reading = false;
  List<Idea> _ideas = [];
  List<Idea> get ideas => _ideas;
  TextEditingController ideaController = TextEditingController();
  TextEditingController descController = TextEditingController();

  Idea? _newIdea;
  Idea? get newIdea => _newIdea;
  set newIdea(Idea? obj) {
    _newIdea = obj;
    notifyListeners();
  }

  Future<Idea> pickFile(Idea obj) async {
    final input = html.InputElement(type: 'file');
    // MyFile objdummy = MyFile(name: '', base64: '', fileextension: '');
    input.click();
    await input.onChange.first;
    if (input.files!.isNotEmpty) {
      final file = input.files?.first;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file!);
      await reader.onLoad.first;
      final encoded = base64Encode(reader.result as List<int>);
      final fileext = ".${file.name.toString().split('.')[1]}";

      obj.ideafilename = file.name;
      obj.fileextension = fileext;
      obj.filebase64 = encoded;
      _newIdea = obj;
      notifyListeners();
    }
    return obj;
  }

  Future<void> getIdeas() async {
    try {
      _ideas.clear();
      reading = true;
      _ideas = await HttpService().readIdeas();
      reading = false;
      notifyListeners();
    } catch (e) {
      reading = false;
    }
  }

  Future<void> addIdea(Idea obj) async {
    try {
      addingIdea = true;
      await HttpService()
          .addIdea(obj)
          .then((value) => {_ideas.insert(0, value)});
      addingIdea = false;
      notifyListeners();
    } catch (e) {
      addingIdea = false;
    }
  }

  bool _addNewIdea = false;
  bool get addNewIdea => _addNewIdea;
  set addNewIdea(bool obj) {
    _addNewIdea = obj;
    notifyListeners();
  }

  List<Vote> _votes = [];
  List<Vote> get votes => _votes;
  bool voting = false;

  Future<void> voteOnIdea(Vote obj) async {
    try {
      voting = true;
      await HttpService().voteOnIdea(obj).then((value) => {
            if (value.votecode != '') {_votes.add(value)}
          });
      voting = false;
      notifyListeners();
    } catch (e) {
      voting = false;
    }
  }

  bool readingVotes = false;
  Future<void> getVotes() async {
    try {
      _votes.clear();
      readingVotes = true;
      _votes = await HttpService().readVotes();
      readingVotes = false;
      notifyListeners();
    } catch (e) {
      readingVotes = false;
    }
  }
}
