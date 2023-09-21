/* class EmployerAssist {
  String code;
  String name;

  EmployerAssist({required this.code, required this.name});
  factory EmployerAssist.fromJson(Map<String, dynamic> json) {
    return EmployerAssist(code: json['accountcode'], name: json['accountname']);
  }
}
 */
import 'package:advisorapp/models/account.dart';

class EmployerAssist {
  Account account;
  EmployerAssist({required this.account});
  factory EmployerAssist.fromJson(Map<String, dynamic> json) {
    return EmployerAssist(account: Account.fromJson(json));
  }
}
