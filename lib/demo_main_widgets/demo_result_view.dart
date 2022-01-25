import 'dart:io';
import 'dart:typed_data';

import 'package:autolydemo/core/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:image_size_getter/image_size_getter.dart' as sizeGetter;
import 'package:juxtapose/juxtapose.dart';
import 'package:path_provider/path_provider.dart';

class DemoResultView extends StatefulWidget {
  final ConsolidateResult result;

  const DemoResultView({Key key, this.result}) : super(key: key);

  @override
  _DemoResultViewState createState() => _DemoResultViewState();
}

class _DemoResultViewState extends State<DemoResultView> {
  bool isCarnetModelAvailable() {
    if (widget.result.carNetPostProcessResponse != null) {
      if (widget.result.carNetPostProcessResponse.carNetModel != null) {
        if (widget.result.carNetPostProcessResponse.carNetModel.detections.isNotEmpty) {
          return true;
        }
      }
    }
    return false;
  }

  String getClassName() {
    if (widget.result.carNetPostProcessResponse.carNetModel.isSuccess) {
      try {
        return widget.result.carNetPostProcessResponse.carNetModel.detections[0].carClass.name;
      } catch (e) {
        return 'Could not recognized';
      }
    }
    return 'Could not recognized';
  }

  String getSubClassName() {
    if (widget.result.carNetPostProcessResponse.carNetModel.isSuccess) {
      try {
        return widget.result.carNetPostProcessResponse.carNetModel.detections[0].subclass[0].name;
      } catch (e) {
        return 'Could not recognized';
      }
    }
    return 'Could not recognized';
  }

  String getSubClassProbability() {
    if (widget.result.carNetPostProcessResponse.carNetModel.isSuccess) {
      try {
        return widget.result.carNetPostProcessResponse.carNetModel.detections[0].subclass[0].probability.toString();
      } catch (e) {
        return 'Could not recognized';
      }
    }
    return '0.0';
  }

  String getMakeName() {
    if (widget.result.carNetPostProcessResponse.carNetModel.isSuccess) {
      try {
        return widget.result.carNetPostProcessResponse.carNetModel.detections[0].mmg[0].makeName;
      } catch (e) {
        return 'Could not recognized';
      }
    }
    return 'Could not recognized';
  }

  String getMakeProbability() {
    if (widget.result.carNetPostProcessResponse.carNetModel.isSuccess) {
      try {
        return widget.result.carNetPostProcessResponse.carNetModel.detections[0].mmg[0].probability.toString();
      } catch (e) {
        return 'Could not recognized';
      }
    }
    return '0.0';
  }

  String getModelName() {
    if (widget.result.carNetPostProcessResponse.carNetModel.isSuccess) {
      try {
        return widget.result.carNetPostProcessResponse.carNetModel.detections[0].mmg[0].modelName;
      } catch (e) {
        return 'Could not recognized';
      }
    }
    return 'Could not recognized';
  }

  String getYears() {
    if (widget.result.carNetPostProcessResponse.carNetModel.isSuccess) {
      try {
        return widget.result.carNetPostProcessResponse.carNetModel.detections[0].mmg[0].years;
      } catch (e) {
        return 'Could not recognized';
      }
    }
    return 'Could not recognized';
  }

  String getColor() {
    if (widget.result.carNetPostProcessResponse.carNetModel.isSuccess) {
      try {
        return widget.result.carNetPostProcessResponse.carNetModel.detections[0].color[0].name;
      } catch (e) {
        return 'Could not recognized';
      }
    }
    return 'Could not recognized';
  }

  String getColorProbability() {
    if (widget.result.carNetPostProcessResponse.carNetModel.isSuccess) {
      try {
        return widget.result.carNetPostProcessResponse.carNetModel.detections[0].color[0].probability.toString();
      } catch (e) {
        return '0.0';
      }
    }
    return '0.0';
  }

  String getAngel() {
    if (widget.result.carNetPostProcessResponse.carNetModel.isSuccess) {
      try {
        return widget.result.carNetPostProcessResponse.carNetModel.detections[0].angle[0].name;
      } catch (e) {
        return 'Could not recognized';
      }
    }
    return 'Could not recognized';
  }

  String getAngelProbability() {
    if (widget.result.carNetPostProcessResponse.carNetModel.isSuccess) {
      try {
        return widget.result.carNetPostProcessResponse.carNetModel.detections[0].angle[0].probability.toString();
      } catch (e) {
        return 'Could not recognized';
      }
    }
    return 'Could not recognized';
  }

  String getProbability() {
    if (widget.result.carNetPostProcessResponse.carNetModel.isSuccess) {
      try {
        return widget.result.carNetPostProcessResponse.carNetModel.detections[0].carClass.probability.toString();
      } catch (e) {
        return '0.0';
      }
    }
    return '0.0';
  }

  Widget getCarNetBoxImage() {
    if (widget.result.carNetPostProcessResponse.imageResponse.isSuccess) {
      return Stack(
        children: [
          Center(child: Image.memory(widget.result.carNetPostProcessResponse.imageResponse.image)),
          Positioned(
            left: 12,
            bottom: 2,
            child: Container(
              color: Colors.black38,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  getProbability(),
                  style: const TextStyle(color: Colors.red, fontSize: 31, fontWeight: FontWeight.bold),
                ),
              ),
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
                  downloadBytesImage(widget.result.carNetPostProcessResponse.imageResponse.image, context);
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

  Widget getBoxImage() {
    Size size = MediaQuery.of(context).size;

    if (widget.result.damageCarModel.isSuccess) {
      return Column(
        children: [
          SizedBox(
            height: size.height * 0.3,
            width: size.width,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(
                  height: size.height * 0.3,
                  width: size.width * 0.8,
                  child: Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4, right: 2),
                          child: Image.network(
                            replaceImageCloud(widget.result.damageCarModel.partsDetails.image),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: IconButton(
                          onPressed: () {
                            downloadUrlImage(widget.result.damageCarModel.partsDetails.image, context);
                          },
                          icon: const Icon(Icons.download),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 8,
                        left: 0,
                        child: Center(
                          child: Container(
                            color: Colors.white24,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Parts',
                                style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.3,
                  width: size.width * 0.8,
                  child: Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4, right: 2),
                          child: Image.network(
                            replaceImageCloud(widget.result.damageCarModel.damageDetails.image),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: IconButton(
                          onPressed: () {
                            downloadUrlImage(widget.result.damageCarModel.damageDetails.image, context);
                          },
                          icon: const Icon(Icons.download),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 8,
                        left: 0,
                        child: Center(
                          child: Container(
                            color: Colors.white24,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Damage parts',
                                style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 10, right: 10),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Row(
          //         mainAxisSize: MainAxisSize.max,
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             "Severity Score : " + widget.result.damageCarModel.severity.score,
          //             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red),
          //           ),
          //           Text(
          //             "Type : " + widget.result.damageCarModel.severity.type.toString(),
          //             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red),
          //           ),
          //         ],
          //       ),
          //       Text(
          //         "State : " + widget.result.damageCarModel.state.toString(),
          //         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red),
          //       ),
          //       Text(
          //         "Damage parts : ${widget.result.damageCarModel.damageParts.toList().toString()}",
          //         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      );
    }
    return const Center(
      child: Text('Error recognizing image'),
    );
  }

  Widget getAngleBoxImage() {
    if (widget.result.carNetPostProcessResponse != null && widget.result.carNetPostProcessResponse.imageResponse.isSuccess) {
      if (widget.result.angelApiResponse.image == null) {
        return Center(
          child: Text(widget.result.angelApiResponse.msg),
        );
      }
      return Stack(
        children: [
          Center(
              child: Column(
            children: [
              Text(
                'Image validation with frame - ${widget.result.angelApiResponse.predictedPosition}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Image.network(replaceImageCloud(widget.result.angelApiResponse.image)),
            ],
          )),
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              color: Colors.black38,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      widget.result.angelApiResponse.predictedPosition.toUpperCase(),
                      style: const TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget.result.angelApiResponse.fillingPercentage}',
                      style: const TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
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
                  downloadUrlImage(widget.result.angelApiResponse.image, context);
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

  int getDimension() {
    final memoryImageSize = sizeGetter.ImageSizeGetter.getSize(sizeGetter.MemoryInput(widget.result.enhanceImgTFM1Response.image));
    double dim =
        (memoryImageSize.height * memoryImageSize.width) / (widget.result.imageDetail.imageHeight * widget.result.imageDetail.imageWidth);
    return dim.round();
  }

  int getFileSize() {
    File fileOriginal = File(widget.result.imageDetail.imagePath);
    double sizeTotal = (widget.result.enhanceImgTFM1Response.image.lengthInBytes / fileOriginal.readAsBytesSync().lengthInBytes);
    return sizeTotal.round();
  }

  Widget getResizeBoxImage() {
    if (widget.result.carNetPostProcessResponse != null && widget.result.carNetPostProcessResponse.imageResponse.isSuccess) {
      if (widget.result.enhanceImgTFM1Response.image == null) {
        return Center(
          child: Text(widget.result.enhanceImgTFM1Response.msg),
        );
      }
      return Stack(
        children: [
          Center(
              child: Column(
            children: [
              Image.memory(widget.result.enhanceImgTFM1Response.image),
            ],
          )),
          Positioned(
            left: 0,
            bottom: 11,
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
            bottom: 10,
            child: Container(
              color: Colors.white30,
              child: IconButton(
                icon: const Icon(Icons.download),
                onPressed: () async {
                  downloadBytesImage(widget.result.enhanceImgTFM1Response.image, context);
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
        title: const Text('Result'),
        // actions: [
        // ElevatedButton(
        //     onPressed: () {
        //       Navigator.of(context).pop();
        //     },
        //     child: Column(
        //       mainAxisSize: MainAxisSize.min,
        //       children: const [
        //         Icon(
        //           Icons.refresh,
        //           size: 14,
        //         ),
        //         Text('Retake'),
        //       ],
        //     ),)
        //  ],
      ),
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// original image data
            OriginalImageDetailImage(
              imageDetail: widget.result.imageDetail,
            ),
            const DividerWidget(),

            /// widgets carnet api data
            const Text(
              'Car Recognition Details',
              style: TextStyle(fontSize: 21),
            ),
            isCarnetModelAvailable()
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

                      /// carnet box image
                      Center(
                        child: SizedBox(
                          height: size.height * 0.3,
                          width: size.width * 0.9,
                          child: getCarNetBoxImage(),
                        ),
                      ),
                    ],
                  )
                : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Could not recognize car'),
                  ),

            const DividerWidget(),

            // const Text(
            //   'Image validation with frame',
            //   style: TextStyle(fontSize: 21),
            // ),
            getAngleBoxImage(),
            const DividerWidget(),

            /// Image Enhancement
            JuxtaposeBuilder(
              response: widget.result.imageTorchApiResponse,
              modelName: 'Image Enhancement',
              imageDetail: widget.result.imageDetail,
            ),
            const DividerWidget(),

            /// Image Resize
            /// Damage Recognition
            Column(children: [
              const Text(
                'Image Resize',
                style: TextStyle(fontSize: 21),
              ),
              Center(
                child: SizedBox(height: size.height * 0.40, width: size.width - 10, child: getResizeBoxImage()),
              ),
            ]),
            const DividerWidget(),

            /// Darkness remover Low Light
            JuxtaposeBuilder(
              response: widget.result.darknessTFM2Response,
              modelName: 'Darkness remover - Low light',
              imageDetail: widget.result.imageDetail,
            ),
            const DividerWidget(),

            /// Darkness remover No Light
            JuxtaposeBuilder(
              response: widget.result.removeDarknessM1Response,
              modelName: 'Darkness remover - No light',
              imageDetail: widget.result.imageDetail,
            ),
            const DividerWidget(),

            /// Damage Recognition
            Column(children: [
              const Text(
                'Damage Recognition',
                style: TextStyle(fontSize: 21),
              ),
              Center(
                child: SizedBox(
                  height: size.height * 0.40,
                  width: size.width - 10,
                  child: getBoxImage(),
                ),
              ),
            ]),
            const DividerWidget(),
          ],
        ),
      ),
    );
  }
}

class DividerWidget extends StatelessWidget {
  const DividerWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 5,
        width: size.width,
        color: Colors.grey,
      ),
    );
  }
}

class TableContentRow extends StatelessWidget {
  final String title;
  final String result;
  final String probability;

  const TableContentRow({Key key, this.title, this.result, this.probability}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasError = result.compareTo('Could not recognized') == 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Row(children: [
        Text(
          '$title:',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          result.toUpperCase(),
          style: TextStyle(fontSize: hasError ? 10 : 16),
        ),
        const SizedBox(
          width: 20,
        ),
        !hasError
            ? Text(
                'probability:$probability',
                style: const TextStyle(fontSize: 10),
              )
            : const SizedBox(),
      ]),
    );
  }
}

class OriginalImageDetailImage extends StatelessWidget {
  final ImageDetail imageDetail;

  const OriginalImageDetailImage({Key key, this.imageDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(
            'Original Image detail',
            style: TextStyle(fontSize: 21),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              width: 200,
              child: Image.file(File(imageDetail.imagePath)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Height:${imageDetail.imageHeight}'),
                Text('Width:${imageDetail.imageWidth}'),
                Text('Size in KB :${imageDetail.sizeInKB}'),
                Text('Size in MB :${imageDetail.sizeInMB}'),
              ],
            ),
            IconButton(
                // ignore: void_checks
                onPressed: () async {
                  File file = File(imageDetail.imagePath);
                  downloadFileImage(file, context);
                },
                icon: const Icon(Icons.download))
          ],
        ),
      ],
    );
  }
}

class JuxtaposeBuilder extends StatelessWidget {
  final TorchImageResponse response;
  final ImageDetail imageDetail;
  final String modelName;

  const JuxtaposeBuilder({Key key, this.response, this.imageDetail, this.modelName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (response == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                modelName,
                style: const TextStyle(fontSize: 21),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Failed enhancing image'),
            ],
          ),
        ),
      );
    }

    if (response.image == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                modelName,
                style: const TextStyle(fontSize: 21),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Failed enhancing image'),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            modelName,
            style: const TextStyle(fontSize: 21),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: size.height * 0.3,
            width: size.width,
            child: Juxtapose(
              backgroundColor: const Color(0xFF012747),
              foregroundWidget: Image.file(File(imageDetail.imagePath)),
              backgroundWidget: Image.memory(response.image),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Original',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () async {
                  downloadBytesImage(response.image, context);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      modelName,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Download',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
