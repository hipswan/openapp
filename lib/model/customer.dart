// To parse this JSON data, do
//
//     final client = clientFromJson(jsonString);

import 'dart:convert';

class Customer {
  Customer({
    this.token,
    this.id,
    this.emailId,
    this.firstName,
    this.lastName,
  });

  String? token;
  int? id;
  String? emailId;
  String? firstName;
  String? lastName;

  Customer copyWith({
    String? token,
    int? id,
    String? emailId,
    String? firstName,
    String? lastName,
  }) =>
      Customer(
        token: token ?? this.token,
        id: id ?? this.id,
        emailId: emailId ?? this.emailId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
      );

  factory Customer.fromRawJson(String str) =>
      Customer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        token: json["token"],
        id: json["id"],
        emailId: json["emailId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "id": id,
        "emailId": emailId,
        "firstName": firstName,
        "lastName": lastName,
      };
}
