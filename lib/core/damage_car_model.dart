// To parse this JSON data, do
//
//     final damageCarModel = damageCarModelFromJson(jsonString);

import 'dart:convert';

class DamageCarModel {
  DamageCarModel({this.partsDetails, this.damageDetails, this.damageParts, this.state, this.severity, this.isSuccess, this.msg});

  Details partsDetails;
  Details damageDetails;
  List<dynamic> damageParts;
  String state;
  Severity severity;
  bool isSuccess;
  String msg;

  factory DamageCarModel.fromJson(Map<String, dynamic> json, bool isSuccess, String msg) => DamageCarModel(
      partsDetails: Details.fromJson(json["parts_details"]),
      damageDetails: Details.fromJson(json["damage_details"]),
      damageParts: List<dynamic>.from(json["damage_parts"].map((x) => x)),
      state: json["state"],
      severity: Severity.fromJson(json["severity"]),
      isSuccess: isSuccess,
      msg: msg);

  Map<String, dynamic> toJson() => {
        "parts_details": partsDetails.toJson(),
        "damage_details": damageDetails.toJson(),
        "damage_parts": List<dynamic>.from(damageParts.map((x) => x)),
        "state": state,
        "severity": severity.toJson(),
      };
}

class Details {
  Details({
    this.parts,
    this.image,
  });

  List<Part> parts;
  String image;

  factory Details.fromRawJson(String str) => Details.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        parts: List<Part>.from(json["parts"].map((x) => Part.fromJson(x))),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "parts": List<dynamic>.from(parts.map((x) => x.toJson())),
        "image": image,
      };
}

class Part {
  Part({
    this.box,
    this.score,
    this.partClass,
  });

  List<String> box;
  double score;
  String partClass;

  factory Part.fromRawJson(String str) => Part.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Part.fromJson(Map<String, dynamic> json) => Part(
        box: List<String>.from(json["box"].map((x) => x.toString())),
        score: json["score"].toDouble(),
        partClass: json["class"],
      );

  Map<String, dynamic> toJson() => {
        "box": List<dynamic>.from(box.map((x) => x)),
        "score": score,
        "class": partClass,
      };
}

class Severity {
  Severity({
    this.type,
    this.score,
  });

  String type;
  String score;

  factory Severity.fromRawJson(String str) => Severity.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Severity.fromJson(Map<String, dynamic> json) => Severity(
        type: json["type"],
        score: json["score"] == null ? null : json["score"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "score": score,
      };
}
