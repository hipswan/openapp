// To parse this JSON data, do
//
//     final staff = staffFromJson(jsonString);

import 'dart:convert';

class Staff {
  Staff({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.phone,
    this.v,
  });

  final String? id;
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? phone;
  final int? v;

  Staff copyWith({
    String? id,
    String? firstname,
    String? lastname,
    String? email,
    String? phone,
    int? v,
  }) =>
      Staff(
        id: id ?? this.id,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        v: v ?? this.v,
      );

  factory Staff.fromRawJson(String str) => Staff.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Staff.fromJson(Map<String, dynamic> json) => Staff(
        id: json["_id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        phone: json["phone"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "phone": phone,
        "__v": v,
      };
}
