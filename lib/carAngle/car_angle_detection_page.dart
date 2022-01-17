

import 'dart:io';

import 'package:autolydemo/core/common_functions.dart';
import 'package:autolydemo/core/scan_animation.dart';
import 'package:flutter/material.dart';

class CarAngleDetectionPage extends StatefulWidget {
  const CarAngleDetectionPage({Key key}) : super(key: key);

  @override
  State<CarAngleDetectionPage> createState() => _CarAngleDetectionPageState();
}

class _CarAngleDetectionPageState extends State<CarAngleDetectionPage> {
  String _selectedValue = "front";
  String _selectedImagePath;
  bool isProcessing = false;
  String _model;

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("Front"),value: "front"),
      const DropdownMenuItem(child: Text("Front Right"),value: "front right"),
      const DropdownMenuItem(child: Text("Front Left"),value: "front left"),
      const DropdownMenuItem(child: Text("Rear"),value: "rear"),
      const DropdownMenuItem(child: Text("Rear Right"),value: "rear right"),
      const DropdownMenuItem(child: Text("Rear Left"),value: "rear left"),
      const DropdownMenuItem(child: Text("Left"),value: "left"),
      const DropdownMenuItem(child: Text("Right"),value: "right"),
    ];
    return menuItems;
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Angle Detection'),
      ),
      body:
      Column(
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
              items: dropdownItems, onChanged: (value){
            _selectedValue = value;
            setState(() {

            });
          }),
          Expanded(flex: 1, child: SingleChildScrollView(
            child: _model!=null?Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(_model),
            ):const SizedBox(),
          )
          ),
          SizedBox(
            height: 50,
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () async{
                    if(_selectedImagePath!=null){
                      isProcessing = true;
                      _model =null;
                      setState(() {

                      });
                      _model = await uploadFileForAngle( imagePath: _selectedImagePath,angle: _selectedValue);
                      isProcessing = false;
                      setState(() {

                      });
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
