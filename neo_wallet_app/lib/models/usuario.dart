// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

import 'package:neo_wallet/models/wallets_users_response.dart';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  Usuario({
    required this.online,
    required this.name,
    required this.wallets,
    required this.email,
    required this.uid,
    required this.devices,
    required this.activated,
  });

  bool online;
  bool activated;
  String name;
  String email;
  List<UserWallet> wallets;
  List<String> devices;
  String uid;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        online: json["online"],
        wallets: List<UserWallet>.from(
            json["wallets"].map((x) => UserWallet.fromJson(x))),
        devices: List<String>.from(json["devices"].map((x) => x)),
        name: json["name"],
        email: json["email"],
        uid: json["uid"],
        activated: json["activated"],
      );

  Map<String, dynamic> toJson() => {
        "online": online,
        "name": name,
        "email": email,
        "uid": uid,
        "activated": activated,
      };
}
