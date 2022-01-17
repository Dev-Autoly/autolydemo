import 'package:flutter/foundation.dart';

class DamageCarModel {
  DamageDetails damageDetails;
  List<String> damageParts;
  DamageDetails partsDetails;
  Severity severity;
  bool state;
  bool isSuccess;
  String msg;

  DamageCarModel({this.damageDetails, this.damageParts, this.partsDetails, this.severity, this.state,this.isSuccess,this.msg});

  DamageCarModel.fromJson(Map<String, dynamic> json, bool isSuccess, String msg) {
    damageDetails = json['damage_details'] != null ? DamageDetails.fromJson(json['damage_details']) : null;
    damageParts = json['damage_parts'].cast<String>();
    partsDetails = json['parts_details'] != null ? DamageDetails.fromJson(json['parts_details']) : null;
    severity = json['severity'] != null ? Severity.fromJson(json['severity']) : null;
    state = json['state'];
    isSuccess = isSuccess;
    msg = msg;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (damageDetails != null) {
      data['damage_details'] = damageDetails.toJson();
    }
    data['damage_parts'] = damageParts;
    if (partsDetails != null) {
      data['parts_details'] = partsDetails.toJson();
    }
    if (severity != null) {
      data['severity'] = severity.toJson();
    }
    data['state'] = state;
    return data;
  }
}

class DamageDetails {
  String image;
  List<Parts> parts;

  DamageDetails({this.image, this.parts});

  DamageDetails.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    if (json['parts'] != null) {
      parts = <Parts>[];
      json['parts'].forEach((v) { parts.add(Parts.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    if (parts != null) {
      data['parts'] = parts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Parts {
  List<double> box;
  String partType;
  double score;

  Parts({this.box, this.partType, this.score});

  Parts.fromJson(Map<String, dynamic> json) {
  box = json['box'].cast<double>();
  partType = json['class'];
  score = json['score'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['box'] = box;
  data['class'] = partType;
  data['score'] = score;
  return data;
  }
}

class Severity {
  double score;
  String type;

  Severity({this.score, this.type});

  Severity.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['score'] = score;
    data['type'] = type;
    return data;
  }
}



