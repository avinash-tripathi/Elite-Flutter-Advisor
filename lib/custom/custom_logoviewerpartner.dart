import 'package:advisorapp/constants.dart';

import 'package:advisorapp/models/partner.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';

class CustomLogoViewerPartner extends StatelessWidget {
  final Partner partner;
  const CustomLogoViewerPartner({Key? key, required this.partner})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            '${partner.companyname}\n${partner.companyaddress} \n${partner.companyphonenumber}',
        decoration: tooltipdecoration,
        child: ClipOval(
          child: Image.network(
            "$basePathOfLogo${partner.partnerdomainname}.png",
            width: 30,
            height: 30,
            fit: BoxFit.fill,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return Center(
                child: Text(
                  partner.companyname.substring(0, 2),
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
      ),
    );
  }
}
