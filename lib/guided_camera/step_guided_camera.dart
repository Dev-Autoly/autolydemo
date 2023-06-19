import 'dart:io';
import 'package:autolydemo/demo_main_widgets/demo_inprogress_widget.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:image/image.dart' as imglib;
import 'package:exif/exif.dart';
import 'package:image/image.dart' as img;
import 'package:native_device_orientation/native_device_orientation.dart';

import 'imageHolderClass.dart';
import 'image_selector.dart';
import 'step_exterior_photo.dart';

class StepGuidedCamera extends StatefulWidget {
  final List<ImagesHolderClass> list;
  final int selectedImageIndex;

  const StepGuidedCamera({Key key, @required this.list, this.selectedImageIndex = 0}) : super(key: key);

  @override
  _StepGuidedCameraState createState() => _StepGuidedCameraState();
}

class _StepGuidedCameraState extends State<StepGuidedCamera> with WidgetsBindingObserver {
  double zoomLevel = 1.0;
  bool isFlashOn = false;
  CameraController _controller;
  Future<void> _controllerInitializer;

  int currentImageIndex = 0;
  PageController scrollController;
  bool isHidden = false;

  Future<CameraDescription> getCamera(bool back) async {
    final c = await availableCameras();
    return back ? c.first : c.last;
  }

  void initializeCamera() {
    getCamera(true).then((camera) {
      if (camera == null) return;
      setState(() {
        _controller = CameraController(
          camera,
          ResolutionPreset.high,
          enableAudio: false,
        );
        _controllerInitializer = _controller.initialize();
        _controllerInitializer.whenComplete(() {});
        _controller.lockCaptureOrientation(DeviceOrientation.landscapeLeft);
      });
    });
  }

  void cameraZoomLevel(double zoomValue) {
    _controller.setZoomLevel(zoomValue);
    print(zoomValue);
    zoomLevel = zoomValue;
    setState(() {});
  }

  void toggleFlash() {
    print('flash is on :$isFlashOn');

    if (isFlashOn) {
      _controller?.setFlashMode(FlashMode.off);
      isFlashOn = false;
    } else {
      _controller?.setFlashMode(FlashMode.torch);
      isFlashOn = true;
    }
    setState(() {});
  }

  Future<String> takePicture() async {
    XFile xFile = await _controller.takePicture();
    File _file = File(xFile.path);
    File rotateImage = await fixImage(_file);
    widget.list[currentImageIndex].imagePath = rotateImage.path;
    return xFile.path;
  }

  Future<File> fixImage(File mfile) async {
    if (mfile == null) {
      return null;
    }
    var imageBytes = mfile.readAsBytesSync();
    imglib.Image image = imglib.decodeImage(imageBytes);
    imglib.Image checRotateImage = imglib.bakeOrientation(image);
    // imglib.Image rotateImage = imglib.copyRotate(checRotateImage, 180);

    return File(mfile.path)..writeAsBytesSync(imglib.encodePng(checRotateImage));
  }

  Future<File> fixExifRotation(String imagePath) async {
    final originalFile = File(imagePath);
    List<int> imageBytes = await originalFile.readAsBytes();

    final originalImage = img.decodeImage(imageBytes);

    final height = originalImage.height;
    final width = originalImage.width;

    // Let's check for the image size
    if (height >= width) {
      // I'm interested in portrait photos so
      // I'll just return here
      return originalFile;
    }

    // We'll use the exif package to read exif data
    // This is map of several exif properties
    // Let's check 'Image Orientation'
    final exifData = await readExifFromBytes(imageBytes);

    img.Image fixedImage;

    if (height < width) {
      print('Rotating image necessary');
      // rotate
      if (exifData['Image Orientation'].printable.contains('Horizontal')) {
        fixedImage = img.copyRotate(originalImage, angle: 90);
      } else if (exifData['Image Orientation'].printable.contains('180')) {
        fixedImage = img.copyRotate(originalImage, angle:-90);
      } else {
        fixedImage = img.copyRotate(originalImage,angle: 0);
      }
    }

    // Here you can select whether you'd like to save it as png
    // or jpg with some compression
    // I choose jpg with 100% quality
    final fixedFile = await originalFile.writeAsBytes(img.encodeJpg(fixedImage));

    return fixedFile;
  }

  @override
  void initState() {
    currentImageIndex = widget.selectedImageIndex;
    scrollController = PageController(
      initialPage: currentImageIndex,
      viewportFraction: 0.1,
    );
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    initializeCamera();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (_controller == null || !_controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_controller != null) {
        _controller?.dispose();
        initializeCamera();
      }
    }
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: azure,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xfff5f5f5),
        systemNavigationBarDividerColor: Color(0xfff5f5f5)));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _controllerInitializer = null;
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets devicePadding = MediaQuery.of(context).padding;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return Center(
      child: WillPopScope(
        onWillPop: () {
          Navigator.of(context).pop(widget.list);
          return Future.value(true);
        },
        child: Scaffold(
          body: NativeDeviceOrientationReader(useSensor: true,builder: (context) {

            return OrientationBuilder(builder: (context, orientation) {
              final orientation = NativeDeviceOrientationReader.orientation(context);
              print('orientation > $orientation');
              if (orientation == NativeDeviceOrientation.landscapeRight) {
                _controller.lockCaptureOrientation(DeviceOrientation.landscapeRight);
              }
              if (orientation == NativeDeviceOrientation.landscapeLeft) {
                _controller.lockCaptureOrientation(DeviceOrientation.landscapeLeft);
              }
              return SizedBox(
                height: size.height,
                width: size.width,
                child: Stack(
                  children: [
                    // camera preview
                    SizedBox(
                      height: size.height,
                      width: size.width,
                      child: FutureBuilder(
                        future: _controllerInitializer,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            // return RotatedBox(quarterTurns: 2, child: CameraPreview(_controller));
                            return RotatedBox(
                              quarterTurns: Platform.isIOS ? 4 : 4,
                              child: AspectRatio(
                                aspectRatio: size.width / size.height,
                                child: Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.diagonal3Values(1.0, 1.0, 1),
                                  child: CameraPreview(_controller),
                                ),
                              ),
                            );
                          } else {
                            return Center(
                              child: Container(),
                            );
                          }
                        },
                      ),
                    ),

                    // image outline preview
                    Positioned(
                      left: devicePadding.left,
                      right: devicePadding.right,
                      top: devicePadding.top,
                      bottom: devicePadding.bottom,
                      child: Container(
                          margin: const EdgeInsets.all(20),
                          child: SvgPicture.asset(
                            widget.list[currentImageIndex].guideImagePath,
                            fit: BoxFit.contain,
                            color: Colors.white,
                          )),
                    ),

                    // widget to hide on tap

                    // widget to tap for hiding all button
                    GestureDetector(
                      onTap: () {
                        isHidden = !isHidden;
                        setState(() {});
                      },
                      child: Container(
                        height: size.height,
                        width: size.width,
                        color: Colors.transparent,
                      ),
                    ),

                    // small preview of guideline images
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      bottom: isHidden ? -(size.height * 0.15) : 5,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          alignment: Alignment.center,
                          height: size.height * 0.15,
                          width: size.width,
                          child: PageView.builder(
                            scrollDirection: Axis.horizontal,
                            controller: scrollController,
                            onPageChanged: (index) {
                              currentImageIndex = index;
                              setState(() {});
                            },
                            itemCount: widget.list.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  currentImageIndex = index;
                                  setState(() {});
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Container(
                                          height: size.height * 0.1,
                                          width: currentImageIndex == index ? size.height * 0.3 : size.height * 0.1,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: widget.list[index].imagePath != null ? Colors.green : Colors.black, width: 1),
                                          ),
                                          padding: const EdgeInsets.all(4.0),
                                          child: SvgPicture.asset(
                                            widget.list[index].guideImagePath,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      widget.list[index].imagePath != null
                                          ? const Center(
                                              child: Icon(
                                              Icons.done,
                                              color: Colors.green,
                                              size: 30,
                                            ))
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // zoom and flash
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      left: isHidden ? -60 : 20,
                      top: 0,
                      bottom: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RotatedBox(
                            quarterTurns: 3,
                            child: SizedBox(
                              width: size.height * 0.7,
                              height: 40,
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 5,
                                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
                                ),
                                child: Slider(
                                    min: 1.0,
                                    max: 8.0,
                                    activeColor: Colors.white,
                                    inactiveColor: Colors.white54,
                                    value: zoomLevel,
                                    onChanged: cameraZoomLevel),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: toggleFlash,
                            child: Icon(
                              isFlashOn ? Icons.flash_off : Icons.flash_on,
                              color: Colors.white,
                              size: size.height * 0.12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // image picker button
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      right: isHidden ? -70 : 30,
                      top: 40,
                      child: GestureDetector(
                        onTap: () async {
                          File _file = await ImageSelector().selectImageWithOutCamera(count: 1);
                          if (_file != null) {
                            ImagesHolderClass result = widget.list[currentImageIndex];
                            result.imagePath = _file.path;

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DemoNetworkCallInProgress(selectedImage: result),
                              ),
                            );
                            // int index = widget.list.firstWhere((element) => element.imagePath == null).imageIndex;
                            // if (index != null) {
                            //   widget.list[currentImageIndex].imagePath = _file.path;
                            // }
                            // Navigator.of(context).pop(widget.list);
                          }
                        },
                        child: const Icon(
                          Icons.image_rounded,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),

                    // image capture button should always be on top
                    Positioned(
                      right: 10,
                      top: size.height * 0.5 - devicePadding.top,
                      child: GestureDetector(
                        onTap: () async {
                          String imagePath = await takePicture();
                          if (imagePath != null) {
                            ImagesHolderClass result = widget.list[currentImageIndex];
                            result.imagePath = imagePath;
                            result.title = widget.list[currentImageIndex].title;

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DemoNetworkCallInProgress(selectedImage: result),
                              ),
                            );
                          }

                          // if (currentImageIndex < widget.list.length - 1) {
                          //   currentImageIndex++;
                          //   setState(() {});
                          //   scrollController.animateToPage(currentImageIndex, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                          // } else {
                          //   Navigator.of(context).pop(widget.list);
                          // }
                        },
                        child: Container(
                          height: size.width * 0.1,
                          width: size.width * 0.1,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9), shape: BoxShape.circle, border: Border.all(color: Colors.black)),
                        ),
                      ),
                    ),

                    Positioned(
                      top: 20,
                      left: 10,
                      child: BackButton(
                          color: Colors.white,
                          onPressed: () {
                            return Navigator.of(context).pop();
                          }),
                    ),
                  ],
                ),
              );
            });
          }),
        ),
      ),
    );
  }
}
