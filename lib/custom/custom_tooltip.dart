import 'package:advisorapp/constants.dart';
import 'package:advisorapp/models/company.dart';
import 'package:advisorapp/models/companycategory.dart';
import 'package:advisorapp/models/companytype.dart';
import 'package:advisorapp/models/employer.dart';
import 'package:advisorapp/providers/master_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TooltipWithCopy extends StatelessWidget {
  final Employer employer;
  const TooltipWithCopy({Key? key, required this.employer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mProvider = Provider.of<MasterProvider>(context, listen: false);
    Company objCompany = mProvider.companies.firstWhere(
        (e) => e.companydomain == employer.companydomainname,
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
        (e) => e.typecode == employer.companytype,
        orElse: () => CompanyType(typecode: 'select', typename: ''));

    return GestureDetector(
        onTap: () {
          Clipboard.setData(ClipboardData(
              text:
                  'Company Name: ${employer.companyname}\nCompany Address: ${employer.companyaddress}\nCompany ContactNo: ${employer.companyphonenumber}\nNaics Code: ${objCompany.naicscode}\nCategory Name: ${objCategory.categoryname}\nType Name: ${objType.typename}'));
          const snackBar = SnackBar(
            content: Text('Copied to clipboard'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: Tooltip(
          textStyle: const TextStyle(color: AppColors.black),
          decoration: tooltipdecoration,
          message: 'click to copy to clipboard',
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              employer.companyname,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ));
  }
}
