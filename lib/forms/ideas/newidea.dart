import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/custom/custom_profileviewer.dart';
import 'package:advisorapp/models/idea.dart';
import 'package:advisorapp/models/vote.dart';
import 'package:advisorapp/providers/idea_provider.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: screenWidth,
          height:
              screenWidth / 4, // Specify a specific width for the message box
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 4,
            child: ListTile(
              leading: isReadOnly
                  ? CustomProfileViewer(account: idea.createdbydata!)
                  : CustomProfileViewer(account: lProv.logedinUser),
              title: isReadOnly
                  ? Text(idea.topic)
                  : TextFormField(
                      controller: iProvider.ideaController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Describe your idea.',
                      ),
                      validator: (value) {
                        return null;
                      },
                    ),
              trailing: isReadOnly
                  ? SizedBox(
                      width: screenWidth / 15,
                      child: Consumer<IdeaProvider>(
                          builder: (context, prvRead, child) {
                        var totalVotes = Vote()
                            .getTotalVotesForIdea(prvRead.votes, idea.ideacode)
                            .toString();
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.thumb_up,
                              color: AppColors.blue,
                            ),
                            Text(totalVotes),
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
                width: 200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        style: buttonStyleBlue,
                        onPressed: () async {
                          Idea obj = Idea();
                          obj.topic = iProvider.ideaController.text;
                          obj.createdby = lProv.logedinUser.accountcode;
                          obj.createdbydata = lProv.logedinUser;
                          await iProvider.addIdea(obj);
                        },
                        child: const Text('Post'),
                      ),
                      ElevatedButton(
                        style: buttonStyleRed,
                        onPressed: () {
                          iProvider.addNewIdea = false;
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ),
      ],
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
              // Implement thumb up functionality here
            },
          ),
        ),
      ],
    );
  }
}
