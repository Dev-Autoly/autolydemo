import 'dart:io';

import 'package:autolydemo/core/common_functions.dart';
import 'package:autolydemo/core/scan_animation.dart';
import 'package:autolydemo/core/text_display_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class DamageCarPage extends StatefulWidget {
  const DamageCarPage({Key key}) : super(key: key);

  @override
  State<DamageCarPage> createState() => _DamageCarPageState();
}

class _DamageCarPageState extends State<DamageCarPage> {
  String _selectedImagePath;
  bool isProcessing = false;
  TorchImageResponse _response;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('DamageCarPage Api'),
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
                  ? Container(
                child: Image.memory(_response.image),
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
                      print('checkDamage');
                      _response = await checkDamageApi(imagePath: _selectedImagePath);
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