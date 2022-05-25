// To parse this JSON data, do
//
//     final staff = staffFromJson(jsonString);

import 'dart:convert';

class Staff {
  Staff({
    this.bId,
    this.firstName,
    this.igProfile,
    this.fbProfile,
    this.tiktokProfile,
    this.desc,
    this.profilePicture,
  });

  int? bId;
  String? firstName;
  String? igProfile;
  String? fbProfile;
  String? tiktokProfile;
  String? desc;
  String? profilePicture;

  Staff copyWith({
    int? bId,
    String? firstName,
    String? igProfile,
    String? fbProfile,
    String? tiktokProfile,
    String? desc,
    String? profilePicture,
  }) =>
      Staff(
        bId: bId ?? this.bId,
        firstName: firstName ?? this.firstName,
        igProfile: igProfile ?? this.igProfile,
        fbProfile: fbProfile ?? this.fbProfile,
        tiktokProfile: tiktokProfile ?? this.tiktokProfile,
        desc: desc ?? this.desc,
        profilePicture: profilePicture ?? this.profilePicture,
      );

  factory Staff.fromRawJson(String str) => Staff.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Staff.fromJson(Map<String, dynamic> json) => Staff(
        bId: json["bId"],
        firstName: json["firstName"],
        igProfile: json["igProfile"],
        fbProfile: json["fbProfile"],
        tiktokProfile: json["tiktokProfile"],
        desc: json["desc"],
        profilePicture: json["profilePicture"],
      );

  Map<String, dynamic> toJson() => {
        "bId": bId,
        "firstName": firstName,
        "igProfile": igProfile,
        "fbProfile": fbProfile,
        "tiktokProfile": tiktokProfile,
        "desc": desc,
        "profilePicture": profilePicture,
      };
}
