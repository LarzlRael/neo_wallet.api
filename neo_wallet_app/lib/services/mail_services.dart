import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:neo_wallet/enviroments/variables_enviroments.dart'
    as Enviroments;

import 'auth_services.dart';

class MailServices {
  Future<bool> sendEmailVerification(String email) async {
    final data = {'email': email};

    final resp = await http.post(
      Uri.parse('${Enviroments.serverHttpUrl}/sendmail'),
      body: jsonEncode(data),
      headers: {
        'Content-type': 'application/json',
        'x-token': await AuthService.getToken()
      },
    );

    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    final data = {'email': email};

    final resp = await http.post(
      Uri.parse('${Enviroments.serverHttpUrl}/sendmail/recoverypassword'),
      body: jsonEncode(data),
      headers: {
        'Content-type': 'application/json',
      },
    );

    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
