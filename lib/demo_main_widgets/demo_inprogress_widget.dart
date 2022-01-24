import 'dart:io';
import 'package:autolydemo/core/common_functions.dart';
import 'package:autolydemo/core/damage_car_model.dart';
import 'package:autolydemo/guided_camera/imageHolderClass.dart';
import 'package:flutter/material.dart';

import 'demo_result_view.dart';

class DemoNetworkCallInProgress extends StatefulWidget {
  final ImagesHolderClass selectedImage;
  const DemoNetworkCallInProgress({Key key, this.selectedImage}) : super(key: key);

  @override
  _DemoNetworkCallInProgressState createState() => _DemoNetworkCallInProgressState();
}

class _DemoNetworkCallInProgressState extends State<DemoNetworkCallInProgress> {
  CarNetPostProcessResponse _carNetData;
  TorchImageResponse _imageTorchApiData;
  TorchImageResponse _enhanceImgTFM1Data;
  TorchImageResponse _removeDarknessM1Data;
  TorchImageResponse _darknessTFM2Data;
  DamageCarModel _damageCarModel;
  AngelApiResponse _angelApiResponse;

  ImageDetail _imageSizeDetail;
  bool isAllApiSuccessfull = false;

  Future<CarNetPostProcessResponse> _carMakeModel;
  Future<TorchImageResponse> _imageTorchApi;
  Future<TorchImageResponse> _enhanceImgTFM1;
  Future<TorchImageResponse> _removeDarknessM1;
  Future<TorchImageResponse> _darknessTFM2;
  Future<ImageDetail> _imageDetail;
  Future<DamageCarModel> _damageDetail;
  Future<AngelApiResponse> _uploadFileForAngle;

  Future<CarNetPostProcessResponse> _carNetModel() async {
    return carNetProcessing(imagePath: widget.selectedImage.imagePath);
  }

  Future<TorchImageResponse> _torchM2Api() async {
    return imageTorchApi(imagePath: widget.selectedImage.imagePath);
  }

  Future<TorchImageResponse> _tfm1Api() async {
    return enhanceImgTFM1(imagePath: widget.selectedImage.imagePath);
  }

  Future<TorchImageResponse> _darknessM1() async {
    return removeDarknessM1(imagePath: widget.selectedImage.imagePath);
  }

  Future<TorchImageResponse> _tfm2Api() async {
    return darknessTFM2(imagePath: widget.selectedImage.imagePath);
  }

  Future<ImageDetail> _getImageDetail() async {
    return getImageDetail(imagePath: widget.selectedImage.imagePath);
  }

  Future<DamageCarModel> _getDamageDetail() async {
    return damagesDetectionApi(imagePath: widget.selectedImage.imagePath);
  }

  Future<AngelApiResponse> _getAngleResponse() async {
    return uploadFileForAngle(imagePath: widget.selectedImage.imagePath);
  }

  bool checkApiStatus(TorchImageResponse response) {
    if (response != null) {
      if (response.isSuccess) {
        return true;
      }
    }
    return false;
  }

  bool updateApiStatus() {
    try {
      if (_carNetData.carNetModel.detections.isNotEmpty) {
        return checkApiStatus(_imageTorchApiData) &&
            checkApiStatus(_enhanceImgTFM1Data) &&
            checkApiStatus(_removeDarknessM1Data) &&
            checkApiStatus(_darknessTFM2Data);
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  @override
  void initState() {
    _imageDetail = _getImageDetail();
    _carMakeModel = _carNetModel();
    _uploadFileForAngle = _getAngleResponse();
    _imageTorchApi = _torchM2Api();
    _enhanceImgTFM1 = _tfm1Api();
    _removeDarknessM1 = _darknessM1();
    _darknessTFM2 = _tfm2Api();
    _damageDetail = _getDamageDetail();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Processing'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 30,
              child: Center(
                child: Text('Processing Selected image'),
              ),
            ),
            SizedBox(
              height: size.height * 0.25,
              width: size.width * 0.9,
              child: Center(
                child: Image.file(
                  File(widget.selectedImage.imagePath),
                ),
              ),
            ),
            FutureBuilder<ImageDetail>(
              future: _imageDetail,
              builder: (context, snapshot) {
                String msg = 'Getting image details';
                if (snapshot.hasError) {
                  return ProcessTextWidget(
                    msg: msg,
                    isDone: true,
                    hasError: true,
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    _imageSizeDetail = snapshot.data;
                    return ProcessTextWidget(
                      msg: msg,
                      isDone: true,
                      hasError: false,
                    );
                  } else {
                    return ProcessTextWidget(
                      msg: msg,
                      isDone: true,
                      hasError: true,
                    );
                  }
                }

                return ProcessTextWidget(
                  msg: msg,
                  isDone: false,
                  hasError: false,
                );
              },
            ),
            FutureBuilder<CarNetPostProcessResponse>(
              future: _carMakeModel,
              builder: (context, snapshot) {
                String msg = 'Uploading Image';
                String msg1 = 'Getting car position';
                String msg2 = 'Getting make model of car';
                if (snapshot.hasError) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ProcessTextWidget(
                        msg: msg,
                        isDone: true,
                        hasError: true,
                      ),
                      ProcessTextWidget(
                        msg: msg1,
                        isDone: true,
                        hasError: true,
                      ),
                      ProcessTextWidget(
                        msg: msg2,
                        isDone: true,
                        hasError: true,
                      ),
                    ],
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    if (snapshot.data.imageResponse.isSuccess) {
                      _carNetData = snapshot.data;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ProcessTextWidget(
                            msg: msg,
                            isDone: true,
                            hasError: false,
                          ),
                          ProcessTextWidget(
                            msg: msg1,
                            isDone: true,
                            hasError: false,
                          ),
                          ProcessTextWidget(
                            msg: msg2,
                            isDone: true,
                            hasError: false,
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ProcessTextWidget(
                            msg: msg,
                            isDone: true,
                            hasError: false,
                          ),
                          ProcessTextWidget(
                            msg: msg1,
                            isDone: true,
                            hasError: true,
                          ),
                          ProcessTextWidget(
                            msg: msg2,
                            isDone: true,
                            hasError: true,
                          ),
                        ],
                      );
                    }
                  }
                }
                return Column(
                  children: [
                    ProcessTextWidget(
                      msg: msg2,
                      isDone: false,
                      hasError: false,
                    ),
                    ProcessTextWidget(
                      msg: msg,
                      isDone: false,
                      hasError: false,
                    ),
                  ],
                );
              },
            ),
            FutureBuilder<AngelApiResponse>(
              future: _uploadFileForAngle,
              builder: (context, snapshot) {
                String msg = 'validating car position';
                if (snapshot.hasError) {
                  return ProcessTextWidget(
                    msg: msg,
                    isDone: true,
                    hasError: true,
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    _angelApiResponse = snapshot.data;
                    return ProcessTextWidget(
                      msg: msg,
                      isDone: true,
                      hasError: false,
                    );
                  } else {
                    return ProcessTextWidget(
                      msg: msg,
                      isDone: true,
                      hasError: true,
                    );
                  }
                }
                return ProcessTextWidget(
                  msg: msg,
                  isDone: false,
                  hasError: false,
                );
              },
            ),
            FutureBuilder<TorchImageResponse>(
              future: _imageTorchApi,
              builder: (context, snapshot) {
                String msg = 'Image Enhancement';
                if (snapshot.hasError) {
                  return ProcessTextWidget(
                    msg: msg,
                    isDone: true,
                    hasError: true,
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.isSuccess) {
                    _imageTorchApiData = snapshot.data;
                    isAllApiSuccessfull = updateApiStatus();
                    return ProcessTextWidget(
                      msg: msg,
                      isDone: true,
                      hasError: false,
                    );
                  } else {
                    return ProcessTextWidget(
                      msg: msg,
                      isDone: true,
                      hasError: true,
                    );
                  }
                }

                return ProcessTextWidget(
                  msg: msg,
                  isDone: false,
                  hasError: false,
                );
              },
            ),
            FutureBuilder<TorchImageResponse>(
              future: _enhanceImgTFM1,
              builder: (context, snapshot) {
                String msg = 'Image resize';

                if (snapshot.hasError) {
                  return ProcessTextWidget(
                    msg: msg,
                    isDone: true,
                    hasError: true,
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.isSuccess) {
                    _enhanceImgTFM1Data = snapshot.data;
                    isAllApiSuccessfull = updateApiStatus();

                    return ProcessTextWidget(
                      msg: msg,
                      isDone: true,
                      hasError: false,
                    );
                  } else {
                    return ProcessTextWidget(
                      msg: msg,
                      isDone: true,
                      hasError: true,
                    );
                  }
                }

                return ProcessTextWidget(
                  msg: msg,
                  isDone: false,
                  hasError: snapshot.hasError,
                );
              },
            ),
            FutureBuilder<TorchImageResponse>(
              future: _removeDarknessM1,
              builder: (context, snapshot) {
                String msg = 'Darkness remover - Low light';
                if (snapshot.hasError) {
                  return ProcessTextWidget(
                    msg: msg,
                    isDone: true,
                    hasError: true,
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.isSuccess) {
                    _removeDarknessM1Data = snapshot.data;
                    return ProcessTextWidget(
                      msg: msg,
                      isDone: true,
                      hasError: false,
                    );
                  } else {
                    return ProcessTextWidget(
                      msg: msg,
                      isDone: true,
                      hasError: false,
                    );
                  }
                }

                return ProcessTextWidget(
                  msg: msg,
                  isDone: false,
                  hasError: snapshot.hasError,
                );
              },
            ),
            FutureBuilder<TorchImageResponse>(
              future: _darknessTFM2,
              builder: (context, snapshot) {
                String msg = 'Darkness remover - No light';
                if (snapshot.hasError) {
                  return ProcessTextWidget(
                    msg: msg,
                    isDone: true,
                    hasError: true,
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.isSuccess) {
                    _darknessTFM2Data = snapshot.data;
                    return ProcessTextWidget(
                      msg: msg,
                      isDone: true,
                      hasError: false,
                    );
                  } else {
                    return ProcessTextWidget(
                      msg: msg,
                      isDone: true,
                      hasError: true,
                    );
                  }
                }

                return ProcessTextWidget(
                  msg: msg,
                  isDone: false,
                  hasError: false,
                );
              },
            ),
            FutureBuilder<DamageCarModel>(
              future: _damageDetail,
              builder: (context, snapshot) {
                String msg = 'Damage Recognition';
                if (snapshot.hasError) {
                  return ProcessTextWidget(
                    msg: msg,
                    isDone: true,
                    hasError: true,
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.isSuccess) {
                    _damageCarModel = snapshot.data;
                    return ProcessTextWidget(
                      msg: msg,
                      isDone: true,
                      hasError: false,
                    );
                  } else {
                    return ProcessTextWidget(
                      msg: msg,
                      isDone: true,
                      hasError: true,
                    );
                  }
                }

                return ProcessTextWidget(
                  msg: msg,
                  isDone: false,
                  hasError: false,
                );
              },
            ),
            ElevatedButton(
              onPressed:() async {
                      ConsolidateResult _resultAll = ConsolidateResult(
                          carNetPostProcessResponse: _carNetData,
                          imageTorchApiResponse: _imageTorchApiData,
                          enhanceImgTFM1Response: _enhanceImgTFM1Data,
                          darknessTFM2Response: _darknessTFM2Data,
                          removeDarknessM1Response: _removeDarknessM1Data,
                          imageDetail: _imageSizeDetail,
                          angelApiResponse: _angelApiResponse,
                          damageCarModel: _damageCarModel);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DemoResultView(
                            result: _resultAll,
                          ),
                        ),
                      );
                    },
              child: SizedBox(
                height: 50,
                width: size.width * 0.5,
                child: const Center(
                  child: Text('Continue'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProcessTextWidget extends StatelessWidget {
  final String msg;
  final bool isDone;
  final bool hasError;

  const ProcessTextWidget({Key key, @required this.msg, @required this.isDone, @required this.hasError}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: 70,
      width: size.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              msg,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          isDone
              ? hasError
                  ? const Icon(
                      Icons.close,
                      color: Colors.red,
                    )
                  : const Icon(
                      Icons.done,
                      color: Colors.green,
                    )
              : const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                )
        ],
      ),
    );
  }
}
