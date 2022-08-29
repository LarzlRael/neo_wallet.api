// To parse this JSON data, do
//
//     final userWalletsResponse = userWalletsResponseFromJson(jsonString);

import 'dart:convert';

UserWalletsResponse userWalletsResponseFromJson(String str) =>
    UserWalletsResponse.fromJson(json.decode(str));

String userWalletsResponseToJson(UserWalletsResponse data) =>
    json.encode(data.toJson());

class UserWalletsResponse {
  UserWalletsResponse({
    required this.ok,
    required this.userWallets,
  });

  bool ok;
  List<UserWallet> userWallets;

  factory UserWalletsResponse.fromJson(Map<String, dynamic> json) =>
      UserWalletsResponse(
        ok: json["ok"],
        userWallets: List<UserWallet>.from(
            json["userWallets"].map((x) => UserWallet.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "userWallets": List<dynamic>.from(userWallets.map((x) => x.toJson())),
      };
}

class UserWallet {
  UserWallet({
    required this.balance,
    required this.block,
    required this.id,
    required this.idUser,
    required this.createdAt,
    required this.updatedAt,
    required this.walletName,
  });

  int balance;
  bool block;
  String id;
  String idUser;
  DateTime createdAt;
  DateTime updatedAt;
  String walletName;

  factory UserWallet.fromJson(Map<String, dynamic> json) => UserWallet(
        balance: json["balance"],
        block: json["block"],
        id: json["_id"],
        idUser: json["idUser"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        walletName: json["walletName"],
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "block": block,
        "_id": id,
        "idUser": idUser,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "walletName": walletName,
      };
}
