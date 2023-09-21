import 'package:advisorapp/component/background.dart';
import 'package:advisorapp/component/sidemenu.dart';
import 'package:advisorapp/config/responsive.dart';
import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/constants.dart';
import 'package:advisorapp/forms/accountform/sl_yourprofile.dart';
import 'package:advisorapp/forms/room/employerinroom.dart';
import 'package:advisorapp/providers/login_provider.dart';

import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class YourProfile extends StatelessWidget {
  YourProfile({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
/*   final List<Role> objEmpRoles = [];
  final Role? objAccRole;

  final Account currentAccount = Account(rolewithemployer: []);
 final  List<CompanyCategory> companycategories = [];
 final  List<CompanyType> companytypes = [];
 final CompanyType? selectedCompanyType;
 final CompanyCategory? selectedCompanyCategory;
 final String? _rolewithemployer = '', _roleforaccount = '';
final  CompanyCategory? companyCate; */

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        key: _scaffoldKey,
        body: Background(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isDesktop(context))
                const Expanded(
                  flex: 2,
                  child: SideMenu(
                    key: null,
                    // currentGoogleAccount: loginProvider.currentGoogleUser!,
                  ),
                ),
              Expanded(
                flex: 9,
                child: Consumer<LoginProvider>(
                    builder: (context, loginProvider, child) {
                  return Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              loginProvider.addingProfile = true;
                            },
                            child: const Text(
                              '+Add your information',
                              style: appstyle,
                            ),
                          ),
                          (loginProvider.addingProfile &&
                                  loginProvider.logedinUser.accountname.isEmpty)
                              ? const YourProfileForm()
                              : const Text(''),
                          (loginProvider.logedinUser.accountname.isNotEmpty)
                              ? const YourProfileForm()
                              : const Text(''),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              if (Responsive.isDesktop(context))
                Consumer<LoginProvider>(
                  builder: (context, prvRead, child) {
                    int flexValue = prvRead.isPanelShrinked ? 1 : 2;
                    return Expanded(
                      flex: flexValue,
                      child: SafeArea(
                        child: Container(
                          width: double.infinity,
                          height: SizeConfig.screenHeight,
                          decoration: const BoxDecoration(
                            color: AppColors.conversation,
                            border: Border(
                              left: BorderSide(
                                color: AppColors.conversation,
                                width: 1,
                              ),
                            ),
                          ),
                          child: const SingleChildScrollView(
                            child: Column(
                              children: [EmployerInRoom()],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
            ],
          ),
        ));
  }
}
