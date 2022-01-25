import 'dart:io';

import 'package:autolydemo/core/common_functions.dart';
import 'package:autolydemo/core/scan_animation.dart';
import 'package:autolydemo/core/text_display_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_size_getter/image_size_getter.dart' as sizeGetter;

class ResizeImagePage extends StatefulWidget {
  const ResizeImagePage({Key key}) : super(key: key);

  @override
  State<ResizeImagePage> createState() => _ResizeImagePageState();
}

class _ResizeImagePageState extends State<ResizeImagePage> {
  String _selectedImagePath;
  bool isProcessing = false;
  TorchImageResponse _response;

  int orignalWidth, orignalHeight;

  int getDimension() {
    final memoryImageSize = sizeGetter.ImageSizeGetter.getSize(sizeGetter.MemoryInput(_response.image));

    double dim = (memoryImageSize.height * memoryImageSize.width) / (orignalHeight * orignalWidth);
    return dim.round();
  }

  int getFileSize() {
    File fileOriginal = File(_selectedImagePath);
    double sizeTotal = (_response.image.lengthInBytes / fileOriginal.readAsBytesSync().lengthInBytes);
    return sizeTotal.round();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Resize'),
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
                              left: 0,
                              bottom: 0,
                              child: Container(
                                color: Colors.black38,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Resolution increased by ${getDimension()}x',
                                        style: const TextStyle(color: Colors.red, fontSize: 17, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'File size increased by ${getFileSize()}x',
                                        style: const TextStyle(color: Colors.red, fontSize: 17, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 10,
                              bottom: 0,
                              child: IconButton(
                                onPressed: () {
                                  downloadBytesImage(_response.image, context);
                                },
                                icon: const Icon(Icons.download),
                              ),
                            ),
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
                      File image = File(_selectedImagePath);
                      var decodedImage = await decodeImageFromList(image.readAsBytesSync());
                      orignalWidth = decodedImage.width;
                      orignalHeight = decodedImage.height;

                      isProcessing = false;
                      setState(() {});
                    }
                  },
                  icon: const Icon(Icons.cloud_upload),
                ),
                IconButton(
                  onPressed: () async {
                    _selectedImagePath = await pickImage(option: imagePickerOption.gallery);
                    _response = null;

                    setState(() {});
                  },
                  icon: const Icon(Icons.image_rounded),
                ),
                IconButton(
                  onPressed: () async {
                    _selectedImagePath = await pickImage(option: imagePickerOption.camera);
                    _response = null;

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
