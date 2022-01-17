import 'dart:typed_data';

import 'package:autolydemo/core/damage_car_model.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../carNet/carnet_model.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;

class TorchImageResponse {
  final bool isSuccess;
  final Uint8List image;
  final String msg;

  TorchImageResponse({this.isSuccess, this.image, this.msg});
}

// {message: the car is not in the right position., predicted_position: left, state: false}
//  {filling_percentage: 65.33, image: https://storage.cloud.google.com/car-damage-images-autoly/tmpscozhrmo0e22d646-774d-11ec-b81a-4d7e98de7515.jpg, message: right position, but the car should be close a little bit., predicted_position: front right, state: false}
class AngelApiResponse {
  final num fillingPercentage;
  final String image;
  final String msg;
  final String predictedPosition;
  final bool state;

  AngelApiResponse({this.fillingPercentage, this.image, this.msg, this.predictedPosition, this.state});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fillingPercentage'] = fillingPercentage;
    data['image'] = image;
    data['msg'] = msg;
    data['predictedPosition'] = predictedPosition;
    data['state'] = state;
    return data;
  }
}



class CarNetPostProcessResponse {
  final CarNetModel carNetModel;
  final TorchImageResponse imageResponse;

  CarNetPostProcessResponse(this.carNetModel, this.imageResponse);
}

class ConsolidateResult {
  final CarNetPostProcessResponse carNetPostProcessResponse;
  final TorchImageResponse imageTorchApiResponse;
  final TorchImageResponse enhanceImgTFM1Response;
  final TorchImageResponse darknessTFM2Response;
  final TorchImageResponse removeDarknessM1Response;
  final ImageDetail imageDetail;
  final AngelApiResponse angelApiResponse;
  final DamageCarModel damageCarModel;

  ConsolidateResult(
      {this.carNetPostProcessResponse,
      this.imageTorchApiResponse,
      this.enhanceImgTFM1Response,
      this.darknessTFM2Response,
      this.removeDarknessM1Response,
      this.imageDetail,this.angelApiResponse,this.damageCarModel});
}

class ImageDetail {
  final num imageHeight;
  final num imageWidth;
  final String sizeInKB;
  final String sizeInMB;
  final String imagePath;

  ImageDetail({this.imageHeight, this.imageWidth, this.sizeInKB, this.sizeInMB, this.imagePath});
}

enum imagePickerOption { camera, gallery }

/// function that pick image from gallery or camera
Future<String> pickImage({@required imagePickerOption option}) async {
  final ImagePicker _picker = ImagePicker();
  XFile image;
  switch (option) {
    case imagePickerOption.camera:
      image = await _picker.pickImage(source: ImageSource.camera);
      break;
    case imagePickerOption.gallery:
      image = await _picker.pickImage(source: ImageSource.gallery);
      break;
  }

  if (image != null) {
    return image.path;
  }
  return null;
}

/// api for Car Angel detection
///
String getAngleFromCarnet(CarNetModel model) {
  if (model.detections.isNotEmpty) {
    if (model.detections[0].angle.isNotEmpty) {
      if (model.detections[0].angle[0].name != null) {
        return model.detections[0].angle[0].name.replaceAll('-', ' ');
      }
    }
  }

  return '';
}

Future<AngelApiResponse> uploadFileForAngle({String imagePath, String angle}) async {
   CarNetModel carNetModel = await uploadToCarNet(imagePath: imagePath);

  String carNetAngle = getAngleFromCarnet(carNetModel);
   debugPrint(carNetAngle);

  String carAngleApi = "https://validate-cars-positions-yozbt3xo3q-uc.a.run.app/validate_car_pos";

  var headers = {
    'content-type': 'application/octet-stream',
    'accept': 'application/json',
  };
  try {
    File originalFile = File(imagePath);
    img.Image image = img.decodeImage(originalFile.readAsBytesSync());
    int oImageH = image.height;
    int oImageW = image.width;
    img.Image thumbnail = img.copyResize(image, width: 342);

    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    final Directory extDir = await getApplicationDocumentsDirectory();
    String dirPath = extDir.path;
    final String filePath = '$dirPath/$timeStamp.png';
    File resizeFie = File(filePath)..writeAsBytesSync(img.encodePng(thumbnail));

    var request = http.MultipartRequest('POST', Uri.parse(carAngleApi));
    var payload = {
      'position': carNetAngle,
      'orginal_width': oImageW.toString(),
      'orginal_hight': oImageH.toString(),
      'carnet_pos': carNetAngle,
    };
    request.headers.addAll(headers);
    request.fields["payload"] = jsonEncode(payload);

    request.files.add(http.MultipartFile('image', resizeFie.readAsBytes().asStream(), resizeFie.lengthSync(), filename: imagePath.split("/").last));

    var streamedResponse = await request.send();


    if (streamedResponse.statusCode == 200) {
      debugPrint('Car angle respnse code:${streamedResponse.statusCode} ');
      final respBody = await streamedResponse.stream.bytesToString();
      Map<String, dynamic> jsonResponse = json.decode(respBody.toString());
      debugPrint('final : $jsonResponse');

      final num fillingPercentage = jsonResponse['filling_percentage'] ?? 0.0;
      final String image = jsonResponse['image'] ?? '';
      final String msg = jsonResponse['message'] ?? '';
      final String predictedPosition = jsonResponse['predicted_position'] ?? '';
      final bool state = jsonResponse['state'] ?? false;

      return AngelApiResponse(
          state: state, msg: msg, image: image, fillingPercentage: fillingPercentage, predictedPosition: predictedPosition);
    }

    debugPrint('Car angle respnse code:${streamedResponse.statusCode} ');
  } catch (e) {
    debugPrint('Error:${e.toString()}');
    return AngelApiResponse(state: false, msg: e.toString());
  }

  return AngelApiResponse(state: false, msg: "unknown error");
}

/// api for Make Model recognize
Future<CarNetModel> uploadToCarNet({@required imagePath}) async {
  String carNetUrl = "https://api.carnet.ai/v2/mmg/detect?box_offset=0&box_min_width=180&box_min_height=180&box_min_ratio=1&box_max_ratio=3"
      ".15&box_select=center&region=DEF&features=mmg,color,angle";

  var headers = {'content-type': 'application/octet-stream', 'accept': 'application/json', 'api-key': '16ac08db-9d44-4512-afd5-7ffba3707da9'};

  var request = http.MultipartRequest('POST', Uri.parse(carNetUrl));

  request.headers.addAll(headers);

  request.files.add(http.MultipartFile('picture', File(imagePath).readAsBytes().asStream(), File(imagePath).lengthSync(), filename: imagePath.split("/").last));

  var streamedResponse = await request.send();

  final respBody = await streamedResponse.stream.bytesToString();
  var jsonResponse = json.decode(respBody.toString());
  return CarNetModel.fromJson(jsonResponse);
}

/// function that get detail of image including size
Future<ImageDetail> getImageDetail({@required String imagePath}) async {
  await Future.delayed(const Duration(seconds: 1));
  File originalFile = File(imagePath);
  final bytes = originalFile.readAsBytesSync().lengthInBytes;
  final kb = bytes / 1024;
  final mb = kb / 1024;
  img.Image image = img.decodeImage(originalFile.readAsBytesSync());
  final int oImageH = image.height;
  final int oImageW = image.width;
  return ImageDetail(
    imagePath: imagePath,
    imageHeight: oImageH,
    imageWidth: oImageW,
    sizeInKB: kb.toStringAsFixed(2).toString(),
    sizeInMB: mb.toStringAsFixed(2).toString(),
  );
}

/// function that draw rect on image
Future<Uint8List> imageWithRect(CarNetModel model, String imagePath) async {
  File originalFile = File(imagePath);
  img.Image image = img.decodeImage(originalFile.readAsBytesSync());

  if (!model.isSuccess) {
    return img.encodePng(image);
  }

  int oImageH = image.height;
  int oImageW = image.width;

  int x1 = oImageW - (oImageW * model.detections[0].box.brX).toInt();
  int y1 = (oImageH * model.detections[0].box.brY).toInt();
  int x2 = oImageW - (oImageW * (model.detections[0].box.tlX)).toInt();
  int y2 = (oImageH * (model.detections[0].box.tlY)).toInt();

  img.Image rectImage = img.drawRect(
    image,
    x1,
    y1,
    x2,
    y2,
    0xFFFFFFFF,
  );

  // int timeStamp = DateTime.now().millisecondsSinceEpoch;
  //
  // // Image imageReturn = Image.memory(img.encodePng(rectImage));
  //
  // final Directory extDir = await getApplicationDocumentsDirectory();
  // String dirPath = extDir.path;
  // final String filePath = '$dirPath/$timeStamp.png';
  // File resizeFie = File(filePath)..writeAsBytesSync(img.encodePng(rectImage));

  return img.encodePng(rectImage);
}

/// api for Car Detection
Future<String> detectCarApi({
  String imagePath,
}) async {
  String carAngleApi = "https://us-central1-autoly-inc.cloudfunctions.net/detect_car_api";
  var headers = {
    'content-type': 'application/octet-stream',
    'accept': 'application/json',
  };
  try {
    File originalFile = File(imagePath);
    img.Image image = img.decodeImage(originalFile.readAsBytesSync());
    int oImageH = image.height;
    int oImageW = image.width;
    img.Image thumbnail = img.copyResize(image, width: 342);

    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    final Directory extDir = await getApplicationDocumentsDirectory();
    String dirPath = extDir.path;
    final String filePath = '$dirPath/$timeStamp.png';
    File resizeFie = File(filePath)..writeAsBytesSync(img.encodePng(thumbnail));

    debugPrint(resizeFie.path);

    var request = http.MultipartRequest('POST', Uri.parse(carAngleApi));
    var payload = {'orginal_width': oImageW.toString(), 'orginal_hight': oImageH.toString()};
    request.headers.addAll(headers);
    request.fields["payload"] = jsonEncode(payload);

    request.files.add(http.MultipartFile('image', resizeFie.readAsBytes().asStream(), resizeFie.lengthSync(), filename: imagePath.split("/").last));

    var streamedResponse = await request.send();
    debugPrint('got added ${streamedResponse.statusCode}');
    if (streamedResponse.statusCode == 200) {
      final respBody = await streamedResponse.stream.bytesToString();
      var jsonResponse = json.decode(respBody.toString());
      debugPrint('final : $jsonResponse');
      return jsonResponse.toString();
    }
  } catch (e) {
    debugPrint('Error:${e.toString()}');
    return e.toString();
  }

  return 'unknown error';
}

/// api for image enhancement
Future<TorchImageResponse> imageTorchApi({String imagePath}) async {
  String imageTorchApi = "http://34.72.28.140:8084/enhanceImgTorchM2";
  var headers = {
    'content-type': 'application/octet-stream',
    'accept': 'application/json',
  };
  try {
    File originalFile = File(imagePath);
    img.Image image = img.decodeImage(originalFile.readAsBytesSync());
    img.Image thumbnail = img.copyResize(image, width: 342);

    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    final Directory extDir = await getApplicationDocumentsDirectory();
    String dirPath = extDir.path;
    final String filePath = '$dirPath/$timeStamp.png';
    File resizeFie = File(filePath)..writeAsBytesSync(img.encodePng(thumbnail));

    debugPrint(resizeFie.path);

    var request = http.MultipartRequest('POST', Uri.parse(imageTorchApi));
    request.headers.addAll(headers);
    // var payload = {'orginal_width':oImageW.toString(), 'orginal_hight':oImageH.toString()};
    // request.fields["payload"] = jsonEncode(payload);

    request.files.add(http.MultipartFile('image', originalFile.readAsBytes().asStream(), originalFile.lengthSync(), filename: imagePath.split("/").last));

    var streamedResponse = await request.send();
    debugPrint('got  ${streamedResponse.statusCode}');
    if (streamedResponse.statusCode == 200) {
      final respBody = await streamedResponse.stream.toBytes();

      // Image image = Image.memory(respBody);

      return TorchImageResponse(isSuccess: true, image: respBody);
    }
    return TorchImageResponse(isSuccess: false, image: null, msg: streamedResponse.statusCode.toString());
  } catch (e) {
    debugPrint('Error:${e.toString()}');

    return TorchImageResponse(isSuccess: false, image: null, msg: e.toString());
  }
}

/// api for car segment
Future<TorchImageResponse> segmentCarApi({String imagePath}) async {
  String imageTorchApi = "https://us-central1-autoly-inc.cloudfunctions.net/segment_car_api";
  var headers = {
    'content-type': 'application/octet-stream',
    'accept': 'application/json',
  };
  try {
    File originalFile = File(imagePath);
    img.Image image = img.decodeImage(originalFile.readAsBytesSync());
    img.Image thumbnail = img.copyResize(image, width: 342);

    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    final Directory extDir = await getApplicationDocumentsDirectory();
    String dirPath = extDir.path;
    final String filePath = '$dirPath/$timeStamp.png';
    File resizeFie = File(filePath)..writeAsBytesSync(img.encodePng(thumbnail));

    debugPrint(resizeFie.path);

    var request = http.MultipartRequest('POST', Uri.parse(imageTorchApi));
    request.headers.addAll(headers);
    // var payload = {'orginal_width':oImageW.toString(), 'orginal_hight':oImageH.toString()};
    // request.fields["payload"] = jsonEncode(payload);

    request.files.add(http.MultipartFile('image', originalFile.readAsBytes().asStream(), originalFile.lengthSync(), filename: imagePath.split("/").last));

    var streamedResponse = await request.send();
    debugPrint('got  ${streamedResponse.statusCode}');
    if (streamedResponse.statusCode == 200) {
      final respBody = await streamedResponse.stream.toBytes();
      // debugPrint(respBody);
      // Image image = Image.memory(respBody);

      return TorchImageResponse(isSuccess: true, image: respBody);
    }
    return TorchImageResponse(isSuccess: false, image: null, msg: streamedResponse.statusCode.toString());
  } catch (e) {
    debugPrint('Error:${e.toString()}');

    return TorchImageResponse(isSuccess: false, image: null, msg: e.toString());
  }
}

/// api for image enhancement
Future<TorchImageResponse> enhanceImgTFM1({String imagePath}) async {
  String imageTorchApi = "http://35.192.191.7:8082/enhanceImgTFM1";
  var headers = {
    'content-type': 'application/octet-stream',
    'accept': 'application/json',
  };
  try {
    File originalFile = File(imagePath);
    img.Image image = img.decodeImage(originalFile.readAsBytesSync());
    img.Image thumbnail = img.copyResize(image, width: 342);

    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    final Directory extDir = await getApplicationDocumentsDirectory();
    String dirPath = extDir.path;
    final String filePath = '$dirPath/$timeStamp.png';
    File resizeFie = File(filePath)..writeAsBytesSync(img.encodePng(thumbnail));

    debugPrint(resizeFie.path);

    var request = http.MultipartRequest('POST', Uri.parse(imageTorchApi));
    request.headers.addAll(headers);
    // var payload = {'orginal_width':oImageW.toString(), 'orginal_hight':oImageH.toString()};
    // request.fields["payload"] = jsonEncode(payload);

    request.files.add(http.MultipartFile('image', originalFile.readAsBytes().asStream(), originalFile.lengthSync(), filename: imagePath.split("/").last));

    var streamedResponse = await request.send();
    debugPrint('got  ${streamedResponse.statusCode}');
    if (streamedResponse.statusCode == 200) {
      final respBody = await streamedResponse.stream.toBytes();

      // Image image = Image.memory(respBody);

      return TorchImageResponse(isSuccess: true, image: respBody);
    }
    return TorchImageResponse(isSuccess: false, image: null, msg: streamedResponse.statusCode.toString());
  } catch (e) {
    debugPrint('Error:${e.toString()}');

    return TorchImageResponse(isSuccess: false, image: null, msg: e.toString());
  }
}

/// api to remove darkness
Future<TorchImageResponse> darknessTFM2({String imagePath}) async {
  String imageTorchApi = "http://35.192.191.7:8083/darknessTFM2";
  var headers = {
    'content-type': 'application/octet-stream',
    'accept': 'application/json',
  };
  try {
    File originalFile = File(imagePath);
    img.Image image = img.decodeImage(originalFile.readAsBytesSync());

    img.Image thumbnail = img.copyResize(image, width: 342);

    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    final Directory extDir = await getApplicationDocumentsDirectory();
    String dirPath = extDir.path;
    final String filePath = '$dirPath/$timeStamp.png';
    File resizeFie = File(filePath)..writeAsBytesSync(img.encodePng(thumbnail));

    debugPrint(resizeFie.path);

    var request = http.MultipartRequest('POST', Uri.parse(imageTorchApi));
    request.headers.addAll(headers);
    // var payload = {'orginal_width':oImageW.toString(), 'orginal_hight':oImageH.toString()};
    // request.fields["payload"] = jsonEncode(payload);

    request.files.add(http.MultipartFile('image', originalFile.readAsBytes().asStream(), originalFile.lengthSync(), filename: imagePath.split("/").last));

    var streamedResponse = await request.send();
    debugPrint('got  ${streamedResponse.statusCode}');
    if (streamedResponse.statusCode == 200) {
      final respBody = await streamedResponse.stream.toBytes();

      // Image image = Image.memory(respBody);

      return TorchImageResponse(isSuccess: true, image: respBody);
    }
    return TorchImageResponse(isSuccess: false, image: null, msg: streamedResponse.statusCode.toString());
  } catch (e) {
    debugPrint('Error:${e.toString()}');

    return TorchImageResponse(isSuccess: false, image: null, msg: e.toString());
  }
}

/// api to remove darkness
Future<TorchImageResponse> removeDarknessM1({String imagePath}) async {
  String imageTorchApi = "https://darkness-image-tf-model-m1-yozbt3xo3q-uc.a.run.app/removeDarknessM1";
  var headers = {
    'content-type': 'application/octet-stream',
    'accept': 'application/json',
  };
  try {
    File originalFile = File(imagePath);
    img.Image image = img.decodeImage(originalFile.readAsBytesSync());

    img.Image thumbnail = img.copyResize(image, width: 342);

    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    final Directory extDir = await getApplicationDocumentsDirectory();
    String dirPath = extDir.path;
    final String filePath = '$dirPath/$timeStamp.png';
    File resizeFie = File(filePath)..writeAsBytesSync(img.encodePng(thumbnail));

    debugPrint(resizeFie.path);

    var request = http.MultipartRequest('POST', Uri.parse(imageTorchApi));
    request.headers.addAll(headers);
    // var payload = {'orginal_width':oImageW.toString(), 'orginal_hight':oImageH.toString()};
    // request.fields["payload"] = jsonEncode(payload);

    request.files.add(http.MultipartFile('image', originalFile.readAsBytes().asStream(), originalFile.lengthSync(), filename: imagePath.split("/").last));

    var streamedResponse = await request.send();
    debugPrint('got  ${streamedResponse.statusCode}');
    if (streamedResponse.statusCode == 200) {
      final respBody = await streamedResponse.stream.toBytes();

      // Image image = Image.memory(respBody);

      return TorchImageResponse(isSuccess: true, image: respBody);
    }
    return TorchImageResponse(isSuccess: false, image: null, msg: streamedResponse.statusCode.toString());
  } catch (e) {
    debugPrint('Error:${e.toString()}');

    return TorchImageResponse(isSuccess: false, image: null, msg: e.toString());
  }
}

/// api to detect damages
Future<DamageCarModel> damagesDetectionApi({String imagePath}) async {
  String imageTorchApi = "https://car-damage-detection-yozbt3xo3q-uc.a.run.app/detectDamages";
  var headers = {
    'content-type': 'application/octet-stream',
    'accept': 'application/json',
  };
  try {
    File originalFile = File(imagePath);
    img.Image image = img.decodeImage(originalFile.readAsBytesSync());
    img.Image thumbnail = img.copyResize(image, width: 342);

    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    final Directory extDir = await getApplicationDocumentsDirectory();
    String dirPath = extDir.path;
    final String filePath = '$dirPath/$timeStamp.png';
    File resizeFie = File(filePath)..writeAsBytesSync(img.encodePng(thumbnail));

    debugPrint(resizeFie.path);

    var request = http.MultipartRequest('POST', Uri.parse(imageTorchApi));
    request.headers.addAll(headers);
    // var payload = {'orginal_width':oImageW.toString(), 'orginal_hight':oImageH.toString()};
    // request.fields["payload"] = jsonEncode(payload);
    debugPrint('added header');
    request.files.add(http.MultipartFile('image', originalFile.readAsBytes().asStream(), originalFile.lengthSync(), filename: imagePath.split("/").last));
    debugPrint('added file');
    var streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);


    debugPrint(response.statusCode.toString());
    debugPrint(response.body);
    if(response.statusCode==200){
      Map<String,dynamic> jsonResponse = jsonDecode(response.body);
      return DamageCarModel.fromJson(jsonResponse);
    }
    return DamageCarModel(
      state: 'State code 500',
      isSuccess:  false,
    );



  } catch (e) {
    debugPrint('Error:${e.toString()}');
    return DamageCarModel(
      state: 'State code 500',
      isSuccess:  false,
    );
  }
}

/// api for processing carnet function after guided camera
Future<CarNetPostProcessResponse> carNetProcessing({String imagePath}) async {
  CarNetModel _model;
  try {
    _model = await uploadToCarNet(imagePath: imagePath);
  } catch (e) {
    return CarNetPostProcessResponse(
      null,
      TorchImageResponse(
        msg: 'Could not process Image',
        isSuccess: false,
        image: null,
      ),
    );
  }

  try {
    Uint8List imageFile = await imageWithRect(_model, imagePath);
    return CarNetPostProcessResponse(_model, TorchImageResponse(msg: 'ok', isSuccess: true, image: imageFile));
  } catch (e) {
    return CarNetPostProcessResponse(
      null,
      TorchImageResponse(
        msg: e.toString(),
        isSuccess: false,
        image: null,
      ),
    );
  }
}
