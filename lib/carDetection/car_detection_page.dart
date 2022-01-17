import 'dart:io';

import 'package:autolydemo/core/car_detection_model.dart';
import 'package:autolydemo/core/common_functions.dart';
import 'package:autolydemo/core/scan_animation.dart';
import 'package:flutter/material.dart';

class CarDetectionPage extends StatefulWidget {
  const CarDetectionPage({Key key}) : super(key: key);

  @override
  State<CarDetectionPage> createState() => _CarDetectionPageState();
}

class _CarDetectionPageState extends State<CarDetectionPage> {
  String _selectedImagePath;
  bool isProcessing = false;
  CarDetectionResponse _model;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(_model);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Detection'),
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
          DetectionImage(response: _model,),
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
                      _model = null;
                      setState(() {});
                      _model = await detectCarApi(imagePath: _selectedImagePath);

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

class DetectionImage extends StatelessWidget {
  final CarDetectionResponse response;

  const DetectionImage({Key key, this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(response==null){
      return Expanded(child: Container());
    }
    if (response.state) {
      return Expanded(
        child: Stack(
          children: [
            Image.network(
              replaceImageCloud(response.image),
              fit: BoxFit.cover,
            ),
            Positioned(
              right: 10,bottom: 10,
              child: IconButton(
                icon: const Icon(Icons.download),
                onPressed: ()async{
                  downloadUrlImage(response.image, context);
                },
              ),
            )
          ],
        ),

      );
    }

    return Expanded(
        child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(response.message),
      ),
    ));
  }
}
