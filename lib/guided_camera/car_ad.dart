import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'imageHolderClass.dart';


class CarAd {
  List<ImagesHolderClass> exteriorImages;

  CarAd({
    this.exteriorImages,
  });

  CarAd.fromJson(Map<String, dynamic> json, {@required String docId}) {
    if (json["exteriorImages"][0].runtimeType == String) {
      exteriorImages = List<ImagesHolderClass>.from(json["exteriorImages"].map((x) => ImagesHolderClass(imagePath: x)));
    } else {
      exteriorImages = List<ImagesHolderClass>.from(json["exteriorImages"].map((x) => ImagesHolderClass.fromJson(x)));
    }
  }

  void addExtImageUrl(String url) {
    exteriorImages ??= [];
    exteriorImages.add(ImagesHolderClass(guideImagePath: url));
  }

  void deleteExteriorImage(String url) {
    if (exteriorImages == null || exteriorImages.isEmpty) return;
    exteriorImages.removeWhere((imageUrl) => imageUrl.imagePath == url);
  }
}
