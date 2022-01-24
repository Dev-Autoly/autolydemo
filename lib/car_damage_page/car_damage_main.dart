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
        title: const Text('Damage Recognition'),
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
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.8,
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 2, right: 2),
                                            child: Image.network(
                                              replaceImageCloud(_response.damageDetails.image),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 10,
                                          left: 10,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Damage parts'),
                                              IconButton(
                                                icon: const Icon(Icons.download),
                                                onPressed: () {
                                                  downloadUrlImage(replaceImageCloud(_response.damageDetails.image), context);
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.8,
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Image.network(
                                            replaceImageCloud(_response.partsDetails.image),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 10,
                                          left: 10,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Parts'),
                                              IconButton(
                                                icon: const Icon(Icons.download),
                                                onPressed: () {
                                                  downloadUrlImage(replaceImageCloud(_response.partsDetails.image), context);
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 10,right: 10),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     mainAxisSize: MainAxisSize.min,
                            //     children: [
                            //       Row(
                            //         mainAxisSize: MainAxisSize.max,
                            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           Text(
                            //             "Severity Score : " + _response.severity.score.toString(),
                            //             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red),
                            //           ),
                            //           Text(
                            //             "Type : " + _response.severity.type.toString(),
                            //             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red),
                            //           ),
                            //         ],
                            //       ),
                            //       Text(
                            //         "State : " + _response.state.toString(),
                            //         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red),
                            //       ),
                            //       Text(
                            //         "Damage parts : ${_response.damageParts.toList().toString()}",
                            //         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red),
                            //       ),
                            //     ],
                            //   ),
                            // ),
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
