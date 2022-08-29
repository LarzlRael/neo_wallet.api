// To parse this JSON data, do
//
//     final sendAmoutResponse = sendAmoutResponseFromJson(jsonString);

import 'dart:convert';

SendAmoutResponse sendAmoutResponseFromJson(String str) =>
    SendAmoutResponse.fromJson(json.decode(str));

String sendAmoutResponseToJson(SendAmoutResponse data) =>
    json.encode(data.toJson());

class SendAmoutResponse {
  SendAmoutResponse({
    required this.ok,
    required this.msg,
    this.newTransactionRaw,
  });

  bool ok;
  String msg;
  NewTransactionRaw? newTransactionRaw;

  factory SendAmoutResponse.fromJson(Map<String, dynamic> json) =>
      SendAmoutResponse(
        ok: json["ok"],
        msg: json["msg"],
        newTransactionRaw:
            NewTransactionRaw.fromJson(json["newTransactionRaw"]),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "newTransactionRaw": newTransactionRaw?.toJson(),
      };
}

class NewTransactionRaw {
  NewTransactionRaw({
    this.amount,
    this.originUser,
    this.userOriginWallet,
    this.userTargetWallet,
    this.destinyUser,
    this.createdAt,
    this.updatedAt,
  });

  int? amount;
  String? originUser;
  String? userOriginWallet;
  String? userTargetWallet;
  String? destinyUser;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory NewTransactionRaw.fromJson(Map<String, dynamic> json) =>
      NewTransactionRaw(
        amount: json["amount"],
        originUser: json["originUser"],
        userOriginWallet: json["userOriginWallet"],
        userTargetWallet: json["userTargetWallet"],
        destinyUser: json["destinyUser"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "originUser": originUser,
        "userOriginWallet": userOriginWallet,
        "userTargetWallet": userTargetWallet,
        "destinyUser": destinyUser,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
