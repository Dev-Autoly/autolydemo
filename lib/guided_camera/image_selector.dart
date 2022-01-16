import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_pickers/image_pickers.dart';

class ImageSelector {
  Future<File> selectImageWithOutCamera({int count = 1}) async {
    List<Media> _listImagePaths = await ImagePickers.pickerPaths(
        galleryMode: GalleryMode.image,
        selectCount: count,
        showGif: false,
        showCamera: false,
        compressSize: 200,
        // uiConfig: UIConfig(uiThemeColor: const Color(0xff000000)),
        // cropConfig: CropConfig(enableCrop: true, width: 2, height: 1),

    );

    if (_listImagePaths != null) {
      File result = File(_listImagePaths[0].path);
      return result;
    }
    return null;
  }
}
