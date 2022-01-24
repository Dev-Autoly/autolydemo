import 'dart:io';
import 'dart:typed_data';

import 'package:autolydemo/core/common_functions.dart';
import 'package:autolydemo/core/scan_animation.dart';
import 'package:autolydemo/demo_main_widgets/demo_result_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class CarAngleDetectionPage extends StatefulWidget {
  const CarAngleDetectionPage({Key key}) : super(key: key);

  @override
  State<CarAngleDetectionPage> createState() => _CarAngleDetectionPageState();
}

class _CarAngleDetectionPageState extends State<CarAngleDetectionPage> {
  String _selectedValue = "front";
  String _selectedImagePath;
  bool isProcessing = false;
  AngelApiResponse _model;

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("Front"), value: "front"),
      const DropdownMenuItem(child: Text("Front Right"), value: "front right"),
      const DropdownMenuItem(child: Text("Front Left"), value: "front left"),
      const DropdownMenuItem(child: Text("Rear"), value: "rear"),
      const DropdownMenuItem(child: Text("Rear Right"), value: "rear right"),
      const DropdownMenuItem(child: Text("Rear Left"), value: "rear left"),
      const DropdownMenuItem(child: Text("Left"), value: "left"),
      const DropdownMenuItem(child: Text("Right"), value: "right"),
    ];
    return menuItems;
  }

  Widget getAngleBoxImage() {
    if (_model != null) {
      if(_model.image==null){
        return Center(
          child: Text(_model.msg),
        );
      }
      return Stack(
        children: [
          Center(child: Image.network(replaceImageCloud(_model.image))),
          Positioned(
            left: 20,
            bottom: 10,
            child: Column(
              children: [
                Text(
                  _model.predictedPosition,
                  style: const TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_model.fillingPercentage}',
                  style: const TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            bottom: 0,
            child: Container(
              color: Colors.white30,
              child: IconButton(
                icon: const Icon(Icons.download),
                onPressed: () async {
                  await requestPermission();
                  final response =
                      await Dio().get(replaceImageCloud(replaceImageCloud(_model.image)), options: Options(responseType: ResponseType.bytes));

                  final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data), name: "car_angle");
                  if (result['isSuccess']) {
                    final snackBar = SnackBar(
                      content: const Text('Saved successfully'),
                      action: SnackBarAction(label: 'Ok', onPressed: () => null),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              ),
            ),
          ),
        ],
      );
    }
    return const Center(
      child: Text('Error recognizing image'),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Angle Validation'),
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
          DropdownButton(
              value: _selectedValue,
              items: dropdownItems,
              onChanged: (value) {
                _selectedValue = value;
                setState(() {});
              }),
          Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: _model != null
                    ? Center(
                        child: SizedBox(
                          // height: size.height * 0.3,
                          width: size.width * 0.9,
                          child: getAngleBoxImage(),
                        ),
                      )
                    : const SizedBox(),
              )),
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
                      AngelApiResponse response = await uploadFileForAngle(imagePath: _selectedImagePath, angleOptional: _selectedValue);
                      _model = response;
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
