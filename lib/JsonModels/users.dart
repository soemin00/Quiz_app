
import 'dart:convert';

User userFromMap(String str) => User.fromMap(json.decode(str));

String userToMap(User data) => json.encode(data.toMap());

class User {
  final int? usrId;
  final String usremail;
  final String userPassword;

  User({
    this.usrId,
    required this.usremail,
    required this.userPassword,
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
    usrId: json["usrId"],
    usremail: json["usremail"],
    userPassword: json["userPassword"],
  );

  Map<String, dynamic> toMap() => {
    "usrId": usrId,
    "usremail": usremail,
    "userPassword": userPassword,
  };
}
