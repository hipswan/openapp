// To parse this JSON data, do
//
//     final service = serviceFromJson(jsonString);

import 'dart:convert';

class Service {
  Service({
    this.location,
    this.id,
    this.name,
    this.description,
    this.phone,
    this.price,
    this.state,
    this.city,
    this.zipcode,
    this.duration,
    this.images,
    this.business,
    this.v,
  });

  final Location? location;
  final String? id;
  final String? name;
  final String? description;
  final String? phone;
  final int? price;
  final String? state;
  final String? city;
  final String? zipcode;
  final int? duration;
  final List<dynamic>? images;
  final String? business;
  final int? v;

  Service copyWith({
    Location? location,
    String? id,
    String? name,
    String? description,
    String? phone,
    int? price,
    String? state,
    String? city,
    String? zipcode,
    int? duration,
    List<dynamic>? images,
    String? business,
    int? v,
  }) =>
      Service(
        location: location ?? this.location,
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        phone: phone ?? this.phone,
        price: price ?? this.price,
        state: state ?? this.state,
        city: city ?? this.city,
        zipcode: zipcode ?? this.zipcode,
        duration: duration ?? this.duration,
        images: images ?? this.images,
        business: business ?? this.business,
        v: v ?? this.v,
      );

  factory Service.fromRawJson(String str) => Service.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        location: Location.fromJson(json["location"]),
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        phone: json["phone"],
        price: json["price"],
        state: json["state"],
        city: json["city"],
        zipcode: json["zipcode"],
        duration: json["duration"],
        images: List<dynamic>.from(json["images"].map((x) => x["url"])),
        business: json["business"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "location": location!.toJson(),
        "_id": id,
        "name": name,
        "description": description,
        "phone": phone,
        "price": price,
        "state": state,
        "city": city,
        "zipcode": zipcode,
        "duration": duration,
        "images": List<dynamic>.from(images!.map((x) => x["url"])),
        "business": business,
        "__v": v,
      };
}

class Location {
  Location({
    this.type,
    this.coordinates,
    this.formattedAddress,
  });

  final String? type;
  final List<double>? coordinates;
  final String? formattedAddress;

  Location copyWith({
    String? type,
    List<double>? coordinates,
    String? formattedAddress,
  }) =>
      Location(
        type: type ?? this.type,
        coordinates: coordinates ?? this.coordinates,
        formattedAddress: formattedAddress ?? this.formattedAddress,
      );

  factory Location.fromRawJson(String str) =>
      Location.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x.toDouble())),
        formattedAddress: json["formattedAddress"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates!.map((x) => x)),
        "formattedAddress": formattedAddress,
      };
}
