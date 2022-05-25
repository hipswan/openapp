// To parse this JSON data, do
//
//     final service = serviceFromJson(jsonString);

import 'dart:convert';

class Service {
  Service({
    this.id,
    this.bId,
    this.serviceName,
    this.time,
    this.cost,
    this.desc,
    this.picture,
    this.extraData,
  });

  int? id;
  int? bId;
  String? serviceName;
  int? time;
  int? cost;
  String? desc;
  String? picture;
  String? extraData;

  Service copyWith({
    int? id,
    int? bId,
    String? serviceName,
    int? time,
    int? cost,
    String? desc,
    String? picture,
    String? extraData,
  }) =>
      Service(
        id: id ?? this.id,
        bId: bId ?? this.bId,
        serviceName: serviceName ?? this.serviceName,
        time: time ?? this.time,
        cost: cost ?? this.cost,
        desc: desc ?? this.desc,
        picture: picture ?? this.picture,
        extraData: extraData ?? this.extraData,
      );

  factory Service.fromRawJson(String str) => Service.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        bId: json["bId"],
        serviceName: json["serviceName"],
        time: json["time"],
        cost: json["cost"],
        desc: json["desc"],
        picture: json["picture"],
        extraData: json["extraData"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bId": bId,
        "serviceName": serviceName,
        "time": time,
        "cost": cost,
        "desc": desc,
        "picture": picture,
        "extraData": extraData,
      };
}
