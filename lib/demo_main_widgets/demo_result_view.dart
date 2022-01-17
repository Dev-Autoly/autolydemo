import 'dart:io';

import 'package:autolydemo/core/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:juxtapose/juxtapose.dart';

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
            left: 20,
            bottom: 10,
            child: Text(
              getProbability(),
              style: const TextStyle(color: Colors.red, fontSize: 31, fontWeight: FontWeight.bold),
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
    if (widget.result.carNetPostProcessResponse.imageResponse.isSuccess) {
      return Stack(
        children: [
          Center(
            child: Image.network(
              replaceImageCloud(widget.result.damageCarModel.partsDetails.image),
            ),
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
                  widget.result.damageCarModel.severity.score.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red),
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

  Widget getAngleBoxImage() {

    if (widget.result.carNetPostProcessResponse.imageResponse.isSuccess) {
      if(widget.result.angelApiResponse.image==null){
        return Center(
          child: Text(widget.result.angelApiResponse.msg),
        );
      }
      return Stack(
        children: [
          Center(child: Image.network(replaceImageCloud(widget.result.angelApiResponse.image))),
          Positioned(
            left: 20,
            bottom: 10,
            child: Column(
              children: [
                Text(
                  widget.result.angelApiResponse.predictedPosition,
                  style: const TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${widget.result.angelApiResponse.fillingPercentage}',
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

            const Text(
              'Image validation with frame',
              style: TextStyle(fontSize: 21),
            ),
            getAngleBoxImage(),
            const DividerWidget(),

            /// Image enhancement - Option 1
            JuxtaposeBuilder(
              response: widget.result.enhanceImgTFM1Response,
              modelName: 'Image enhancement Option 1',
              imageDetail: widget.result.imageDetail,
            ),
            const DividerWidget(),

            /// Image enhancement - Option 2
            JuxtaposeBuilder(
              response: widget.result.imageTorchApiResponse,
              modelName: 'Image enhancement  Option 2',
              imageDetail: widget.result.imageDetail,
            ),
            const DividerWidget(),

            /// Darkness remover Option 1
            JuxtaposeBuilder(
              response: widget.result.darknessTFM2Response,
              modelName: 'Darkness remover Option 1',
              imageDetail: widget.result.imageDetail,
            ),
            const DividerWidget(),

            /// Darkness remover Option 2
            JuxtaposeBuilder(
              response: widget.result.removeDarknessM1Response,
              modelName: 'Darkness remover Option 2',
              imageDetail: widget.result.imageDetail,
            ),
            const DividerWidget(),

            /// Damage detection
            Column(children: [
              const Text(
                'Damage Car Detection',
                style: TextStyle(fontSize: 21),
              ),
              Center(
                child: SizedBox(
                  height: size.height * 0.3,
                  width: size.width * 0.9,
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
