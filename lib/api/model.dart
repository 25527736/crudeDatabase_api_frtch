// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<Welcome> welcomeFromJson(String str) => List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

String welcomeToJson(List<Welcome> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Welcome {
  Welcome({
    required this.name,
    required this.city,
    required this.avatar,
    required this.id,
  });

  String name;
  String city;
  String avatar;
  int id;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    name: json["name"],
    city: json["city"],
    avatar: json["avatar"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "city": city,
    "avatar": avatar,
    "id": id,
  };
}
