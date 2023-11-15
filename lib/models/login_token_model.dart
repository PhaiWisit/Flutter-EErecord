import 'dart:convert';

LoginTokenModel loginTokenMedelFromJson(String str) =>
    LoginTokenModel.fromJson(json.decode(str));

String loginTokenMedelToJson(LoginTokenModel data) =>
    json.encode(data.toJson());

class LoginTokenModel {
  String accessToken;
  String username;

  factory LoginTokenModel.fromRawJson(String str) =>
      LoginTokenModel.fromJson(json.decode(str));

  LoginTokenModel({
    required this.accessToken,
    required this.username,
  });

  factory LoginTokenModel.fromJson(Map<String, dynamic> json) =>
      LoginTokenModel(
        accessToken: json["accessToken"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "username": username,
      };
}
