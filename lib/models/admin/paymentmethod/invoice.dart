import 'package:advisorapp/models/account.dart';

class Invoice {
  String total;
  String createdby = '';
  Account? createdbydata;
  String peruserlicensefee;
  String totalfees;
  String paidon;
  Invoice({
    this.total = '',
    this.createdby = '',
    this.createdbydata,
    this.peruserlicensefee = '',
    this.totalfees = '',
    this.paidon = '',
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
        total: json['total'],
        createdby: json['createdby'],
        createdbydata: (json['createdbydata'] != null)
            ? Account.fromJson(json['createdbydata'][0])
            : null,
        peruserlicensefee: json['peruserlicensefee'],
        totalfees: json['totalfees'],
        paidon: json['paidon']);
  }
  dynamic getIndex(int index) {
    switch (index) {
      case 0:
        return total;
      case 1:
        return '$peruserlicensefee\$';
      case 2:
        return '$totalfees\$';
      case 3:
        return createdbydata!.accountname;
    }
    return '';
  }
}
