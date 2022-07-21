// To parse this JSON data, do
//
//     final slot = slotFromJson(jsonString);

import 'dart:convert';

class Slot {
  Slot({
    this.start,
    this.cap,
  });

  final DateTime? start;
  final int? cap;

  Slot copyWith({
    DateTime? start,
    int? cap,
  }) =>
      Slot(
        start: start ?? this.start,
        cap: cap ?? this.cap,
      );

  factory Slot.fromRawJson(String str) => Slot.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        start: DateTime.parse(json["start"]),
        cap: json["cap"],
      );

  Map<String, dynamic> toJson() => {
        "start": start?.toIso8601String() ?? "",
        "cap": cap,
      };
}
