

import 'dart:io';

import 'package:autolydemo/core/common_functions.dart';
import 'package:autolydemo/core/scan_animation.dart';
import 'package:autolydemo/core/text_display_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class EnhanceImgTFM1Page extends StatefulWidget {
  const EnhanceImgTFM1Page({Key key}) : super(key: key);

  @override
  State<EnhanceImgTFM1Page> createState() => _EnhanceImgTFM1PageState();
}

class _EnhanceImgTFM1PageState extends State<EnhanceImgTFM1Page> {
  String _selectedImagePath;
  bool isProcessing = false;
  TorchImageResponse _response;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('EnhanceImgTFM1'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.4,
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: _selectedImagePath != null ? Image.file(File(_selectedImagePath)) : const Text('Select Image'),
                ),
                isProcessing ? const ScanAnimationWidget() : const SizedBox(),
              ],
            ),
          ),
          Container(
            height: 1,
            width: size.width,
            color: Colors.grey,
          ),
          Expanded(
              child: _response == null
                  ? const DisplayCenterText(msg: 'Select and upload image')
                  : _response.isSuccess
                  ? Stack(
                    children: [
                      Image.memory(_response.image),
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: IconButton(
                          onPressed: (){
                            downloadBytesImage(_response.image, context);
                          },
                          icon: const Icon(Icons.download),
                        ),
                      )
                    ],
                  )
                  : DisplayCenterText(msg: _response.msg)),

          ///tool box
          SizedBox(
            height: 50,
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () async {
                    if (_selectedImagePath != null) {
                      isProcessing = true;
                      _response = null;
                      setState(() {});
                      _response = await enhanceImgTFM1(imagePath: _selectedImagePath);
                      isProcessing = false;
                      setState(() {});
                    }
                  },
                  icon: const Icon(Icons.cloud_upload),
                ),
                IconButton(
                  onPressed: () async {
                    _selectedImagePath = await pickImage(option: imagePickerOption.gallery);
                    setState(() {});
                  },
                  icon: const Icon(Icons.image_rounded),
                ),
                IconButton(
                  onPressed: () async {
                    _selectedImagePath = await pickImage(option: imagePickerOption.camera);
                    setState(() {});
                  },
                  icon: const Icon(Icons.camera),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}