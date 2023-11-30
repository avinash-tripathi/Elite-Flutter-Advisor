import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/custom/custom_logoviewer.dart';
import 'package:advisorapp/custom/custom_tooltip.dart';
import 'package:advisorapp/providers/login_provider.dart';
import 'package:advisorapp/providers/room_provider.dart';
import 'package:advisorapp/providers/sidebar_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployerInRoom extends StatelessWidget {
  const EmployerInRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roomprovider = Provider.of<RoomsProvider>(context, listen: false);
    final lProvider = Provider.of<LoginProvider>(context, listen: false);
    bool validLicense = lProvider.logedinUser.validlicense;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: SizeConfig.blockSizeVertical * 5,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment:
                Alignment.topLeft, // Align the icon to the top right corner
            child: IconButton(
              icon: const Icon(
                Icons.menu,
                color: AppColors.black,
              ),
              onPressed: () {
                lProvider.isPanelShrinked = !lProvider.isPanelShrinked;
              },
            ),
          ),
          const Text(
            'Employer Workspace',
            style: TextStyle(color: AppColors.card, fontSize: 16),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child:
                  Consumer<RoomsProvider>(builder: (context, prvView, child) {
                return prvView.readingRooms
                    ? displaySpin()
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: prvView.employers.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: SizeConfig.blockSizeHorizontal * 5,
                              height: SizeConfig.blockSizeHorizontal * 3,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: !validLicense
                                          ? null
                                          : () async {
                                              final menuProvider =
                                                  Provider.of<SidebarProvider>(
                                                      context,
                                                      listen: false);
                                              menuProvider.selectedMenu =
                                                  'Home';
                                              await roomprovider
                                                  .readAccountsAssociatedtoEmployer(
                                                      roomprovider
                                                          .employers[index]
                                                          .accountcode,
                                                      roomprovider
                                                          .employers[index]
                                                          .employercode);
                                              await roomprovider
                                                  .getInitialLaunchPack(
                                                      '',
                                                      roomprovider
                                                          .employers[index]
                                                          .employercode,
                                                      'Employer')
                                                  .then((value) => {
                                                        Navigator.of(context)
                                                            .popAndPushNamed(
                                                                "/Home")
                                                      });
                                            },
                                      child: CustomLogoViewer(
                                          employer: prvView.employers[index]),
                                    ),
                                    Consumer<LoginProvider>(
                                        builder: (context, prvRole, child) {
                                      return !prvRole.isPanelShrinked
                                          ? Expanded(
                                              child: TooltipWithCopy(
                                                  employer:
                                                      prvView.employers[index]),
                                            )
                                          : const Text('');
                                    })
                                  ]),
                            ),
                          );
                        });
              }))
        ],
      ),
    ]);
  }
}
