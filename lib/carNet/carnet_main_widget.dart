import 'dart:convert';
import 'dart:io';

import 'package:autolydemo/core/scan_animation.dart';
import 'package:autolydemo/demo_main_widgets/demo_result_view.dart';

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

  String processJson() {
    if (_model != null) {
      Map<String, dynamic> json = _model.toJson();
      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      return encoder.convert(json);
    }
    return '';
  }

  bool isCarnetModelAvailable() {
    // if (widget.result.carNetPostProcessResponse != null) {
    if (_model != null) {
      if (_model.detections.isNotEmpty) {
        return true;
      }
    }
    // }
    return false;
  }

  String getClassName() {
    if (_model.isSuccess) {
      try {
        return _model.detections[0].carClass.name;
      } catch (e) {
        return 'Could not recognized';
      }
    }
    return 'Could not recognized';
  }

  String getSubClassName() {
    if (_model.isSuccess) {
      try {
        return _model.detections[0].subclass[0].name;
      } catch (e) {
        return 'Could not recognized';
      }
    }
    return 'Could not recognized';
  }

  String getSubClassProbability() {
    if (_model.isSuccess) {
      try {
        return _model.detections[0].subclass[0].probability.toString();
      } catch (e) {
        return 'Could not recognized';
      }
    }
    return '0.0';
  }

  String getMakeName() {
    if (_model.isSuccess) {
      try {
        return _model.detections[0].mmg[0].makeName;
      } catch (e) {
        return 'Could not recognized';
      }
    }
    return 'Could not recognized';
  }

  String getMakeProbability() {
    if (_model.isSuccess) {
      try {
        return _model.detections[0].mmg[0].probability.toString();
      } catch (e) {
        return 'Could not recognized';
      }
    }
    return '0.0';
  }

  String getModelName() {
    if (_model.isSuccess) {
      try {
        return _model.detections[0].mmg[0].modelName;
      } catch (e) {
        return 'Could not recognized';
      }
    }
    return 'Could not recognized';
  }

  String getYears() {
    if (_model.isSuccess) {
      try {
        return _model.detections[0].mmg[0].years;
      } catch (e) {
        return 'Could not recognized';
      }
    }
    return 'Could not recognized';
  }

  String getColor() {
    if (_model.isSuccess) {
      try {
        return _model.detections[0].color[0].name;
      } catch (e) {
        return 'Could not recognized';
      }
    }
    return 'Could not recognized';
  }

  String getColorProbability() {
    if (_model.isSuccess) {
      try {
        return _model.detections[0].color[0].probability.toString();
      } catch (e) {
        return '0.0';
      }
    }
    return '0.0';
  }

  String getAngel() {
    if (_model.isSuccess) {
      try {
        return _model.detections[0].angle[0].name;
      } catch (e) {
        return 'Could not recognized';
      }
    }
    return 'Could not recognized';
  }

  String getAngelProbability() {
    if (_model.isSuccess) {
      try {
        return _model.detections[0].angle[0].probability.toString();
      } catch (e) {
        return 'Could not recognized';
      }
    }
    return 'Could not recognized';
  }

  String getProbability() {
    if (_model.isSuccess) {
      try {
        return _model.detections[0].carClass.probability.toString();
      } catch (e) {
        return '0.0';
      }
    }
    return '0.0';
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
              ],
            ),
          ),
          Container(
            height: 1,
            width: size.width,
            color: Colors.grey,
          ),
          Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: _model != null
                    ? isCarnetModelAvailable()
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TableContentRow(
                                title: 'Class',
                                result: getClassName(),
                                probability: getProbability(),
                              ),
                              TableContentRow(
                                title: 'SubClass',
                                result: getSubClassName(),
                                probability: getSubClassProbability(),
                              ),
                              TableContentRow(
                                title: 'Make',
                                result: getMakeName(),
                                probability: getMakeProbability(),
                              ),
                              TableContentRow(
                                title: 'Model',
                                result: getModelName(),
                                probability: getMakeProbability(),
                              ),
                              TableContentRow(
                                title: 'Year',
                                result: getYears(),
                                probability: getMakeProbability(),
                              ),
                              TableContentRow(
                                title: 'Color',
                                result: getColor(),
                                probability: getColorProbability(),
                              ),
                              TableContentRow(
                                title: 'Angel',
                                result: getAngel(),
                                probability: getAngelProbability(),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          )
                        : const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Could not recognize car'),
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
                    // if (_model == null) {
                    if (_selectedImagePath != null) {
                      isProcessing = true;
                      _model = null;
                      setState(() {});
                      _model = await uploadToCarNet(imagePath: _selectedImagePath);
                      isProcessing = false;
                      setState(() {});
                    }
                    // }
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
                    _model = null;
                    setState(() {});
                  },
                  icon: const Icon(Icons.image_rounded),
                ),
                IconButton(
                  onPressed: () async {
                    _selectedImagePath = await pickImage(option: imagePickerOption.camera);
                    _model = null;
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
  const ResultWidget({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (model.detections != null) {
      if (model.detections.isNotEmpty) {
        if (model.detections[0].mmg.isNotEmpty) {
          Mmg mmg = model.detections[0].mmg[0];
        }
      }
    }

    return Container();
  }
}
