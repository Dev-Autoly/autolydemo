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

  bool isCarnetModelAvailable(){
    if(widget.result.carNetPostProcessResponse!=null){
      if(widget.result.carNetPostProcessResponse.carNetModel!=null){
        if(widget.result.carNetPostProcessResponse.carNetModel.detections.isNotEmpty){
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
          widget.result.carNetPostProcessResponse.imageResponse.image,
          Positioned(
              right: 20,
              bottom: 20,
              child: Text(
                getProbability(),
                style: const TextStyle(color: Colors.red, fontSize: 31, fontWeight: FontWeight.bold),
              ))
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
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.refresh,
                    size: 14,
                  ),
                  Text('Retake'),
                ],
              ),)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// original image data
            OriginalImageDetailImage(imageDetail: widget.result.imageDetail,),
            const DividerWidget(),
            /// widgets carnet api data
            const Text(
              'Car Recognition Details',
              style: TextStyle(fontSize: 21),
            ),
            isCarnetModelAvailable()?Column(
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
                      width: size.width * 0.8,
                      child: Stack(
                        children: [
                          getCarNetBoxImage(),
                        ],
                      )),
                ),
            ],):const Padding(
              padding:  EdgeInsets.all(8.0),
              child:  Text('Could not recognize car'),
            ),


            const DividerWidget(),

            /// Image enhancement - TFM1 model
            JuxtaposeBuilder(
              response: widget.result.enhanceImgTFM1Response,
              modelName: 'TFM1 model',
              imageDetail: widget.result.imageDetail,

            ),
            const DividerWidget(),


            /// Image enhancement - TorchM2 model
            JuxtaposeBuilder(
              response: widget.result.imageTorchApiResponse,
              modelName: 'TorchM2 model',
              imageDetail: widget.result.imageDetail,

            ),
            const DividerWidget(),

            /// Image enhancement - darknessTFM2 model
            JuxtaposeBuilder(
              response: widget.result.darknessTFM2Response,
              modelName: 'darknessTFM2 model',
              imageDetail: widget.result.imageDetail,

            ),
            const DividerWidget(),


            /// Image enhancement - m1-yozbt3xo3q model
            JuxtaposeBuilder(
              response: widget.result.removeDarknessM1Response,
              modelName: 'm1-yozbt3xo3q model',
              imageDetail: widget.result.imageDetail,

            ),
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
    bool hasError = result.compareTo('Could not recognized')==0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Row(children: [
        Text(
          '$title:',
          style:   const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          result.toUpperCase(),
          style:  TextStyle(fontSize: hasError?10:16),
        ),
        const SizedBox(
          width: 20,
        ),
        !hasError? Text(
          'probability:$probability',
          style: const TextStyle(fontSize: 10),
        ):const SizedBox(),
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
            )
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

  const JuxtaposeBuilder({Key key, this.response,this.imageDetail,this.modelName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if(response==null){
      return  Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Image enhancement - $modelName',
                style: const TextStyle(fontSize: 21),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20,),
              const Text('Failed enhancing image'),
            ],
          ),
        ),
      );
    }

    if(response.image==null){
      return  Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Image enhancement - $modelName',
                style: const TextStyle(fontSize: 21),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20,),
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
            'Image enhancement - $modelName',
            style: const TextStyle(fontSize: 21),
             textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5,),
          SizedBox(
            height: size.height*0.3,
            width: size.width,
            child: Juxtapose(
              backgroundColor: const Color(0xFF012747),
              foregroundWidget: Image.file(File(imageDetail.imagePath)),
              backgroundWidget: response.image,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             const Text('Original',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
              Text(modelName,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
            ],
          ),
        ],
      ),
    );
  }
}
