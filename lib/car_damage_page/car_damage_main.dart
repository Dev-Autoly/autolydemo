import 'dart:io';

import 'package:autolydemo/core/common_functions.dart';
import 'package:autolydemo/core/damage_car_model.dart';
import 'package:autolydemo/core/scan_animation.dart';
import 'package:autolydemo/core/text_display_image.dart';
import 'package:flutter/material.dart';

class CarDamageApiPage extends StatefulWidget {
  const CarDamageApiPage({Key key}) : super(key: key);

  @override
  State<CarDamageApiPage> createState() => _CarDamageApiPageState();
}

class _CarDamageApiPageState extends State<CarDamageApiPage> {
  String _selectedImagePath;
  bool isProcessing = false;
  DamageCarModel _response;

  @override
  Widget build(BuildContext context) {
    // print(_response.partsDetails.image);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Damage Prediction'),
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
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Image.network(
                                replaceImageCloud(_response.partsDetails.image),
                                fit: BoxFit.contain,
                              ),
                              Positioned(
                                left: 30,
                                bottom: 5,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Damage Severity',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red),
                                    ),
                                    Text(
                                      _response.severity.score.toString(),
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 10,
                                bottom: 10,
                                child: IconButton(
                                  onPressed: (){
                                    downloadUrlImage(_response.partsDetails.image, context);
                                  },
                                  icon: const Icon(Icons.download),
                                ),
                              )
                            ],
                          ),
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
                      _response = await damagesDetectionApi(imagePath: _selectedImagePath);
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
