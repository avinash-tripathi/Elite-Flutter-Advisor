import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:advisorapp/custom/customidea_profileviewer.dart';
import 'package:advisorapp/models/idea.dart';
import 'package:advisorapp/models/vote.dart';
import 'package:advisorapp/providers/idea_provider.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NewIdea extends StatelessWidget {
  final Idea idea;
  final bool isReadOnly;
  const NewIdea({Key? key, required this.idea, required this.isReadOnly})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final iProvider = Provider.of<IdeaProvider>(context, listen: false);
    final lProv = Provider.of<LoginProvider>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIdeaTextField(iProvider, lProv),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: isReadOnly
                  ? _buildReactions(iProvider, lProv)
                  : const Text(''),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildIdeaTextField(IdeaProvider iProvider, LoginProvider lProv) {
    double screenWidth = SizeConfig.screenWidth / 3;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: screenWidth,
            height:
                screenWidth / 3, // Specify a specific width for the message box
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 4,
              child: ListTile(
                leading: isReadOnly
                    ? CustomIdeaProfileViewer(account: idea.createdbydata!)
                    : CustomIdeaProfileViewer(account: lProv.logedinUser),
                title: isReadOnly
                    ? ListTile(
                        title: Text(idea.topic),
                        subtitle: Text(idea.topicdescription),
                        trailing: Text.rich(TextSpan(
                          text:
                              idea.ideafilename == '' ? '' : idea.ideafilename,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.underline,
                            color: AppColors.blue,
                            fontSize: 12,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              Uri uri = Uri.parse(
                                  "$defaultIdeaPath${idea.ideacode}/${idea.ideacode}${idea.fileextension}");
                              if (idea.fileextension.isNotEmpty) {
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                }
                              } else {
                                // Handle error when unable to launch the URL
                              }
                            },
                        )),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: iProvider.ideaController,
                            decoration: const InputDecoration(
                              hintText: 'Title',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Title.';
                              }

                              return null;
                            },
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: iProvider.descController,
                                  decoration: const InputDecoration(
                                    hintText: 'Describe Your Idea.',
                                  ),
                                  validator: (value) {
                                    return null;
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(FontAwesomeIcons.paperclip),
                                onPressed: () async {
                                  await iProvider.pickFile(idea);
                                },
                              ),
                            ],
                          ),
                          Consumer<IdeaProvider>(
                              builder: (context, prvNewFile, child) {
                            return Text.rich(TextSpan(
                              text: (prvNewFile.newIdea == null)
                                  ? ''
                                  : prvNewFile.newIdea?.ideafilename,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.underline,
                                fontSize: 12,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  if (prvNewFile.newIdea != null) {
                                    Uri uri = Uri.parse(
                                        "$defaultIdeaPath${prvNewFile.newIdea!.ideacode}/${prvNewFile.newIdea!.ideacode}${prvNewFile.newIdea!.fileextension}");
                                    if (prvNewFile
                                        .newIdea!.fileextension.isNotEmpty) {
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri);
                                      }
                                    } else {
                                      // Handle error when unable to launch the URL
                                    }
                                  }
                                },
                            ));
                          }),
                        ],
                      ),
                trailing: isReadOnly
                    ? SizedBox(
                        width: screenWidth / 15,
                        child: Consumer<IdeaProvider>(
                            builder: (context, prvRead, child) {
                          var totalVotes = Vote()
                              .getTotalVotesForIdea(
                                  prvRead.votes, idea.ideacode)
                              .toString();
                          var totalNegativeVotes = Vote()
                              .getTotalNegativeVotesForIdea(
                                  prvRead.votes, idea.ideacode)
                              .toString();

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.thumb_up,
                                    color: AppColors.blue,
                                  ),
                                  Text(totalVotes),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.thumb_down,
                                    color: AppColors.red,
                                  ),
                                  Text(totalNegativeVotes),
                                ],
                              ),
                            ],
                          );
                        }),
                      )
                    : const Text(''),
              ),
            ),
          ),
          isReadOnly
              ? const Text("")
              : SizedBox(
                  width: SizeConfig.screenWidth / 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: buttonStyleBlue,
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                Idea obj = idea;
                                obj.topic = iProvider.ideaController.text;
                                obj.topicdescription =
                                    iProvider.descController.text;
                                obj.createdby = lProv.logedinUser.accountcode;
                                obj.createdbydata = lProv.logedinUser;
                                await iProvider.addIdea(obj);
                                //iProvider.addNewIdea = false;
                              }
                            },
                            child: const Text('Post'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: buttonStyleRed,
                            onPressed: () {
                              iProvider.addNewIdea = false;
                            },
                            child: const Text('Close'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildReactions(IdeaProvider iProvider, LoginProvider lProv) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: IconButton(
            icon: const Icon(
              Icons.thumb_up,
              color: AppColors.blue,
            ),
            onPressed: () {
              // Implement thumb up functionality here
              Vote obj = Vote();
              obj.ideacode = idea.ideacode;
              obj.voted = true;
              obj.votedby = lProv.logedinUser.accountcode;
              obj.votedbydata = lProv.logedinUser;
              iProvider.voteOnIdea(obj);
            },
          ),
        ),
        ClipOval(
          child: IconButton(
            icon: const Icon(
              Icons.thumb_down,
              color: AppColors.red,
            ),
            onPressed: () {
              Vote obj = Vote();
              obj.ideacode = idea.ideacode;
              obj.voted = false;
              obj.votedby = lProv.logedinUser.accountcode;
              obj.votedbydata = lProv.logedinUser;
              iProvider.voteOnIdea(obj);
            },
          ),
        ),
      ],
    );
  }
}
