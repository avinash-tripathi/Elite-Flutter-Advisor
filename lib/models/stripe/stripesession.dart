class StripeSession {
  String sessionid;
  String sessionUrl;
  StripeSession({required this.sessionid, required this.sessionUrl});
  factory StripeSession.fromJson(Map<String, dynamic> json) {
    return StripeSession(
        sessionid: json['sessionid'], sessionUrl: json['sessionUrl']);
  }
}
