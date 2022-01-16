import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';

import 'basic_view_model.dart';
import 'imageHolderClass.dart';
import 'replace_image.dart';
import 'step_guided_camera.dart';

int photoIndex = 0;
const appBarColor = Color(0xff2b6a92);
const String image_car_outline = 'assets/images/image_car_outline.svg';
const azure = Color(0xff03a0e6);
const ceruleanTwo = Color(0xff008dcc);

class StepExteriorPhotos extends StatelessWidget {
  const StepExteriorPhotos({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: azure,
      appBar: AppBar(
        title: const Text('Demo Guided Camera'),
      ),
      body: ViewModelBuilder<BasicAdViewModel>.reactive(
        viewModelBuilder: () => BasicAdViewModel(),
        disposeViewModel: false,
        onModelReady: (model) => model.initScreen(),
        builder: (context, model, child) {
          Size size = MediaQuery.of(context).size;
          return Center(
            child: SizedBox(
              height: size.height * 0.68,
              child: Stack(
                children: [
                  Center(
                    child: SizedBox(
                      height: size.height * 0.5,
                      width: size.width * 0.9,
                      child: SvgPicture.asset(
                        image_car_outline,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Stack(
                    //model.carAd.exteriorImages
                    children: exteriorImageDefaultList.map(
                      (e) {
                        return Positioned(
                          top: size.height * e.topPosition,
                          left: size.width * e.leftPosition,
                          child: Center(
                            child: CameraButtonWidget(
                              directionText: e.title,
                              onAction: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StepGuidedCamera(
                                      list: model.carAd.exteriorImages,
                                      selectedImageIndex: e.imageIndex,
                                    ),
                                  ),
                                );
                                // if (e.imagePath != null && e.isUploading) {
                                //   // Show dialog for replace & delete
                                //   final checkResult = await showReplaceImageDialog(context, e);
                                //   if (checkResult == true) {
                                //     // Replace image
                                //     List<ImagesHolderClass> list = await Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (context) => StepGuidedCamera(list: model.carAd.exteriorImages, selectedImageIndex: e.imageIndex),
                                //       ),
                                //     );
                                //     for (e in list) {
                                //       print('LIST E > $e');
                                //
                                //       // model.updateExteriorImageClassList(index: e.imageIndex, imagesHolderClass: e);
                                //     }
                                //   } else if (checkResult == false) {
                                //     // check is there any image will be available
                                //     bool checkAvailable = false;
                                //     model.carAd.exteriorImages.forEach((element) {
                                //       if (element.imagePath != null && element.isUploading && e.imageIndex != element.imageIndex) {
                                //         checkAvailable = true;
                                //       } else {
                                //         checkAvailable = false;
                                //       }
                                //     });
                                //     if (checkAvailable) {
                                //       // Delete image
                                //       final result = exteriorImageDefaultList.firstWhere((element) => element.imageIndex == e.imageIndex);
                                //       model.carAd.exteriorImages[e.imageIndex].isUploading = false;
                                //       model.carAd.exteriorImages[e.imageIndex].imagePath = null;
                                //
                                //       // await model.updateExteriorPhotoFb(model.carAd, result);
                                //       Fluttertoast.showToast(
                                //           msg: 'Removed successfully', backgroundColor: Colors.green, textColor: Colors.white, timeInSecForIosWeb: 3);
                                //       model.notifyListeners();
                                //     } else {
                                //       Fluttertoast.showToast(
                                //           msg: 'You can\'t delete image, it required one image',
                                //           backgroundColor: Colors.red,
                                //           textColor: Colors.white,
                                //           timeInSecForIosWeb: 3);
                                //     }
                                //   } else {
                                //     return;
                                //   }
                                //   return;
                                // } else {
                                //   // Add images
                                //   List<ImagesHolderClass> list = await Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => StepGuidedCamera(list: model.carAd.exteriorImages, selectedImageIndex: e.imageIndex)),
                                //   );
                                //   for (e in list) {
                                //
                                //     model.updateExteriorImageClassList(index: e.imageIndex, imagesHolderClass: e);
                                //   }
                                // }
                              },
                              isCompleted: e.imagePath != null,
                              filePath: e.imagePath,
                              isUploading: e.isUploading,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static Future<bool> showReplaceImageDialog(BuildContext context, ImagesHolderClass imageHolder) async {
    return await showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: appBarColor.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return ReplaceImage(imageHolder);
      },
      transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15 * anim1.value, sigmaY: 15 * anim1.value),
        child: FadeTransition(
          child: child,
          opacity: anim1,
        ),
      ),
    );
  }
}

class CameraButtonWidget extends StatelessWidget {
  final Function onAction;
  final bool isCompleted;
  final bool isUploading;
  final String directionText;
  final String filePath;

  const CameraButtonWidget(
      {Key key, @required this.onAction, @required this.isCompleted, @required this.isUploading, @required this.directionText, @required this.filePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 2,
          ),
          Text(
            directionText,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 2,
          ),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(color: isCompleted ? Colors.green : Colors.white, shape: BoxShape.circle),
            padding: const EdgeInsets.all(2),
            child: isCompleted
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: isUploading
                        ? Image.network(
                            filePath,
                            height: 40,
                            width: 40,
                            fit: BoxFit.fill,
                          )
                        : Image.file(
                            File(filePath),
                            height: 40,
                            width: 40,
                            fit: BoxFit.fill,
                          ))
                : const Icon(
                    Icons.camera_alt,
                    color: ceruleanTwo,
                  ),
          ),
        ],
      ),
    );
  }
}
