// To parse this JSON data, do
//
//     final shop = shopFromJson(jsonString);

import 'dart:convert';

class Shop {
  Shop({
    this.location,
    this.numberOfRatings,
    this.staff,
    this.id,
    this.name,
    this.description,
    this.images,
    this.phone,
    this.services,
    this.city,
    this.state,
    this.country,
    this.rating,
    this.license,
    this.isVerified,
    this.category,
    this.categoryId,
    this.reviews,
    this.v,
  });

  final Location? location;
  final int? numberOfRatings;
  final List<dynamic>? staff;
  final String? id;
  final String? name;
  final String? description;
  final List<String>? images;
  final String? phone;
  final List<dynamic>? services;
  final String? city;
  final String? state;
  final String? country;
  final int? rating;
  final String? license;
  final bool? isVerified;
  final String? category;
  final String? categoryId;
  final List<dynamic>? reviews;
  final int? v;

  Shop copyWith({
    Location? location,
    int? numberOfRatings,
    List<dynamic>? staff,
    String? id,
    String? name,
    String? description,
    List<String>? images,
    String? phone,
    List<dynamic>? services,
    String? city,
    String? state,
    String? country,
    int? rating,
    String? license,
    bool? isVerified,
    String? category,
    String? categoryId,
    List<dynamic>? reviews,
    int? v,
  }) =>
      Shop(
        location: location ?? this.location,
        numberOfRatings: numberOfRatings ?? this.numberOfRatings,
        staff: staff ?? this.staff,
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        images: images ?? this.images,
        phone: phone ?? this.phone,
        services: services ?? this.services,
        city: city ?? this.city,
        state: state ?? this.state,
        country: country ?? this.country,
        rating: rating ?? this.rating,
        license: license ?? this.license,
        isVerified: isVerified ?? this.isVerified,
        category: category ?? this.category,
        categoryId: categoryId ?? this.categoryId,
        reviews: reviews ?? this.reviews,
        v: v ?? this.v,
      );

  factory Shop.fromRawJson(String str) => Shop.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        location: Location.fromJson(json["location"]),
        numberOfRatings: json["numberOfRatings"],
        staff: json["staff"],
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        images: json["images"].map<String>((x) => x["url"].toString()).toList(),
        phone: json["phone"],
        services: json["services"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        rating: json["rating"],
        license: json["license"],
        isVerified: json["isVerified"],
        category: json["category"]["title"],
        categoryId: json["category"]["_id"],
        reviews: json["reviews"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "location": location!.toJson(),
        "numberOfRatings": numberOfRatings,
        "staff": List<dynamic>.from(staff!.map((x) => x)),
        "_id": id,
        "name": name,
        "description": description,
        "images": List<dynamic>.from(images!.map((x) => x)),
        "phone": phone,
        "services": List<dynamic>.from(services!.map((x) => x)),
        "city": city,
        "state": state,
        "country": country,
        "rating": rating,
        "license": license,
        "isVerified": isVerified,
        "category": category,
        "categoryID": categoryId,
        "reviews": List<dynamic>.from(reviews!.map((x) => x)),
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
