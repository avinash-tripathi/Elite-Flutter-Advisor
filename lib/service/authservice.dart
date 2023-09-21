import 'dart:convert';
import 'package:advisorapp/models/auth.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const graphApiEndpoint = 'https://graph.microsoft.com/v1.0/me';

  Future<Auth> getUserInfo(accessToken) async {
    Auth objAuth = Auth(email: '', mypassword: '', firebaseverified: true);

    final response = await http.get(
      Uri.parse(graphApiEndpoint),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      objAuth =
          Auth(email: data['mail'], mypassword: '', firebaseverified: true);
      return objAuth;
      /*  final name = data['displayName'];
    final email = data['mail'];
    final profilePicUrl = data['userPrincipalName']; */

      /*   print('Name: $name');
    print('Email: $email');
    print('Profile Picture URL: $profilePicUrl'); */
    } else {
      return objAuth;
      //print('Failed to fetch user information');
    }
  }
}
