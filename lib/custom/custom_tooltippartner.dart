import 'package:advisorapp/constants.dart';
import 'package:advisorapp/models/company.dart';
import 'package:advisorapp/models/companycategory.dart';
import 'package:advisorapp/models/companytype.dart';
import 'package:advisorapp/models/partner.dart';
import 'package:advisorapp/providers/master_provider.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TooltipWithCopy extends StatelessWidget {
  final Partner partner;

  const TooltipWithCopy({Key? key, required this.partner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mProvider = Provider.of<MasterProvider>(context, listen: false);
    Company objCompany = mProvider.companies.firstWhere(
        (e) => e.companydomain == partner.partnerdomainname,
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

    return GestureDetector(
        onTap: () {
          Clipboard.setData(ClipboardData(
              text:
                  'Company Name: ${objCompany.companyname}\nCompany Address: ${objCompany.companyaddress}\nCompany ContactNo: ${objCompany.companyphoneno}\nNaics Code: ${objCompany.naicscode}\nCategory Name: ${objCategory.categoryname}\nCompany Type: ${objType.typename}'));
          const snackBar = SnackBar(
            content: Text('Copied to clipboard'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: Tooltip(
          textStyle: const TextStyle(color: AppColors.black),
          decoration: tooltipdecoration,
          message: 'click to copy to clipboard',
          child: Text(partner.companyname),
        ));
  }
}
