// To parse this JSON data, do
//
//     final transactionsResponse = transactionsResponseFromJson(jsonString);

import 'dart:convert';

TransactionsResponse transactionsResponseFromJson(String str) =>
    TransactionsResponse.fromJson(json.decode(str));

String transactionsResponseToJson(TransactionsResponse data) =>
    json.encode(data.toJson());

class TransactionsResponse {
  TransactionsResponse({
    required this.ok,
    required this.userTransactions,
  });

  bool ok;
  List<UserTransaction> userTransactions;

  factory TransactionsResponse.fromJson(Map<String, dynamic> json) =>
      TransactionsResponse(
        ok: json["ok"],
        userTransactions: List<UserTransaction>.from(
            json["userTransactions"].map((x) => UserTransaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "userTransactions":
            List<dynamic>.from(userTransactions.map((x) => x.toJson())),
      };
}

class UserTransaction {
  UserTransaction({
    required this.amount,
    required this.originUser,
    required this.userOriginWallet,
    required this.userTargetWallet,
    required this.destinyUser,
    required this.createdAt,
    required this.updatedAt,
  });

  int amount;
  String originUser;
  String userOriginWallet;
  String userTargetWallet;
  String destinyUser;
  DateTime createdAt;
  DateTime updatedAt;

  factory UserTransaction.fromJson(Map<String, dynamic> json) =>
      UserTransaction(
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
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
