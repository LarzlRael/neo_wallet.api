// To parse this JSON data, do
//
//     final errorResponse = errorResponseFromJson(jsonString);

import 'dart:convert';

ErrorResponse errorResponseFromJson(String str) =>
    ErrorResponse.fromJson(json.decode(str));

String errorResponseToJson(ErrorResponse data) => json.encode(data.toJson());

class ErrorResponse {
  ErrorResponse({
    this.ok,
    this.errors,
  });

  bool? ok;
  Errors? errors;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        ok: json["ok"] == null ? null : json["ok"],
        errors: json["errors"] == null ? null : Errors.fromJson(json["errors"]),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok == null ? null : ok,
        "errors": errors == null ? null : errors?.toJson(),
      };
}

class Errors {
  Errors({
    this.name,
    this.password,
    this.email,
  });

  Email? name;
  Email? password;
  Email? email;

  factory Errors.fromJson(Map<String, dynamic> json) => Errors(
        name: json["name"] == null ? null : Email.fromJson(json["name"]),
        password:
            json["password"] == null ? null : Email.fromJson(json["password"]),
        email: json["email"] == null ? null : Email.fromJson(json["email"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name?.toJson(),
        "password": password == null ? null : password?.toJson(),
        "email": email == null ? null : email?.toJson(),
      };
}

class Email {
  Email({
    this.msg,
    this.param,
    this.location,
  });

  String? msg;
  String? param;
  String? location;

  factory Email.fromJson(Map<String, dynamic> json) => Email(
        msg: json["msg"] == null ? null : json["msg"],
        param: json["param"] == null ? null : json["param"],
        location: json["location"] == null ? null : json["location"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg == null ? null : msg,
        "param": param == null ? null : param,
        "location": location == null ? null : location,
      };
}
