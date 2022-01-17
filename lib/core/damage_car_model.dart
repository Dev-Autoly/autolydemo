import 'package:flutter/foundation.dart';

class DamageCarModel {
  PartsDetails partsDetails;
  Severity severity;
  String state;
  bool isSuccess;

  DamageCarModel({this.partsDetails, this.severity, this.state,this.isSuccess});

  DamageCarModel.fromJson(Map<String, dynamic> json) {
    try {
      partsDetails = json['parts_details'] != null ? PartsDetails.fromJson(json['parts_details']) : null;
      severity = json['severity'] != null ? Severity.fromJson(json['severity']) : null;
      state = json['state'];
      isSuccess = true;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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

class PartsDetails {
  String image;
  List<Parts> parts;

  PartsDetails({this.image, this.parts});

  PartsDetails.fromJson(Map<String, dynamic> json) {
    try {
      image = json['image'];
      if (json['parts'] != null) {
        parts = <Parts>[];
        json['parts'].forEach((v) {
          parts.add(Parts.fromJson(v));
        });
      }
    } catch (e) {
      debugPrint(e.toString());
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
  List<num> box;
  String partClass;
  num score;

  Parts({this.box, this.partClass, this.score});

  Parts.fromJson(Map<String, dynamic> json) {
    try {
      box = json['box'].cast<double>();
      partClass = json['class'];
      score = json['score'];
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['box'] = box;
    data['class'] = partClass;
    data['score'] = score;
    return data;
  }
}

class Severity {
  num score;

  Severity({this.score});

  Severity.fromJson(Map<String, dynamic> json) {
    try {
      score = json['score']??0.0;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['score'] = score;
    return data;
  }
}
