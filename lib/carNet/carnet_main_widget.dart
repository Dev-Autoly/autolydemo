import 'dart:convert';
import 'dart:io';

import 'package:autolydemo/core/scan_animation.dart';

import 'carnet_model.dart';
import '../core/common_functions.dart';
import 'package:flutter/material.dart';


class CarNetHomePage extends StatefulWidget {
  const CarNetHomePage({Key key}) : super(key: key);

  @override
  _CarNetHomePageState createState() => _CarNetHomePageState();
}

class _CarNetHomePageState extends State<CarNetHomePage> {
  String _selectedImagePath;
  CarNetModel _model;
  bool isProcessing = false;

  String processJson(){
    if(_model!=null){
      Map<String,dynamic> json = _model.toJson();
      JsonEncoder encoder =  const JsonEncoder.withIndent('  ');
      return encoder.convert(json);

    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;


    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Model Recognizer'),
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

                // I/flutter (29077): 420
                // I/flutter (29077): 315
                //
                // Positioned(
                //   top: size.height*tly,
                //   left: tlx,
                //   right: size.width - (size.width*brx),
                //   child: Container(
                //     height: 100,
                //     color: Colors.red.withOpacity(0.3),
                //   ),
                // )

              ],
            ),
          ),
          Container(
            height: 1,
            width: size.width,
            color: Colors.grey,
          ),
          Expanded(flex: 1, child: SingleChildScrollView(
            child: _model!=null?Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(processJson()),
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

                    if(_model==null){
                      if(_selectedImagePath!=null){
                        isProcessing = true;
                        _model =null;
                        setState(() {

                        });
                        _model = await uploadToCarNet(imagePath: _selectedImagePath);
                        isProcessing = false;
                        setState(() {

                        });
                      }
                    }
                    // else{
                    //   print('u hv model');
                    //   File _file = await imageWithRect(_model,_selectedImagePath);
                    //   if(_file!=null){
                    //     _selectedImagePath = _file.path;
                    //     setState(() {
                    //
                    //     });
                    //   }
                    // }



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

class ResultWidget extends StatelessWidget {
  final CarNetModel model;
   const ResultWidget({Key key,@required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(model.detections!=null){
      if(model.detections.isNotEmpty){
        if(model.detections[0].mmg.isNotEmpty){
          Mmg mmg = model.detections[0].mmg[0];
        }
      }
    }

    return Container();
  }
}


