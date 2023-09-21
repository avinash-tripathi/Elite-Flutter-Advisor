import 'package:advisorapp/constants.dart';
import 'package:advisorapp/models/account.dart';
import 'package:advisorapp/models/company.dart';
import 'package:advisorapp/models/companycategory.dart';
import 'package:advisorapp/models/companytype.dart';
import 'package:advisorapp/providers/master_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CustomProfileViewer extends StatelessWidget {
  final Account account;

  const CustomProfileViewer({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    final mProvider = Provider.of<MasterProvider>(context, listen: false);
    Company objCompany = mProvider.companies.firstWhere(
        (e) => e.companydomain == account.companydomainname,
        orElse: () => Company(
            companyaddress: '',
            companycategory: 'select',
            companydomain: '',
            companyphoneno: '',
            companyname: '',
            companytype: 'select',
            naicscode: ''));
    CompanyCategory objCategory = mProvider.companycategories.firstWhere(
        (e) => e.categorycode == objCompany.companycategory,
        orElse: () => CompanyCategory(
            categorycode: 'select', categoryname: '', basecategorycode: ''));
    CompanyType objType = mProvider.companytypes.firstWhere(
        (e) => e.typecode == objCompany.companytype,
        orElse: () => CompanyType(typecode: 'select', typename: ''));

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(width: 4, color: Colors.white),
        boxShadow: [
          BoxShadow(
            spreadRadius: 2,
            blurRadius: 10,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
        shape: BoxShape.circle,
      ),
      child: Tooltip(
          textStyle: const TextStyle(color: AppColors.black),
          message:
              '${account.accountname} ${account.lastname}\n${account.workemail} \n${account.phonenumber}',
          decoration: tooltipdecoration,
          preferBelow: true,
          child: GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(
                    text:
                        '${account.accountname} ${account.lastname}\n${account.worktitle}\n${account.phonenumber}\n${account.workemail} \n${objCompany.naicscode}\n${objCategory.categoryname}\n${objType.typename}'));
                const snackBar = SnackBar(
                  content: Text('Copied to clipboard'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Tooltip(
                textStyle: const TextStyle(color: AppColors.black),
                decoration: tooltipdecoration,
                message: 'click to copy to clipboard',
                preferBelow: false,
                waitDuration: const Duration(seconds: 2),
                child: ClipOval(
                  child: Image.network(
                    "$basePathOfLogo${account.accountcode}.png",
                    width: 35,
                    height: 35,
                    fit: BoxFit.fill,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Center(
                        child: Text(
                          account.accountname.substring(0, 1) +
                              account.lastname.substring(0, 1),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ))),
    );
  }
}
