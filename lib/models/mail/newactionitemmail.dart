class NewActionItemMail {
  String toRecipientEmailId;
  String mailTemplateType;
  String fromUserName;
  String employerCompanyName;
  NewActionItemMail({
    this.toRecipientEmailId = '0',
    this.mailTemplateType = '0',
    this.fromUserName = '0',
    this.employerCompanyName = '0',
  });

  Map toMap() {
    var map = <String, dynamic>{};
    map['ToRecipientEmailId'] = toRecipientEmailId;
    map['MailTemplateType'] = mailTemplateType;
    map['FromUserName'] = fromUserName;
    map['EmployerCompanyName'] = employerCompanyName;

    return map;
  }
}
