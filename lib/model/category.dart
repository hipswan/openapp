// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

class Category {
  Category({
    this.id,
    this.title,
    this.image,
  });

  final String? id;
  final String? title;
  final String? image;

  Category copyWith({
    String? id,
    String? title,
    String? image,
  }) =>
      Category(
        id: id ?? this.id,
        title: title ?? this.title,
        image: image ?? this.image,
      );

  factory Category.fromRawJson(String str) =>
      Category.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        title: json["title"],
        image: json["image"]["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
      };
}
