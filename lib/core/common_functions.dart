import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../carNet/carnet_model.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:palette_generator/palette_generator.dart';
import 'dart:ui' as ui;



class TorchImageResponse {
  final bool isSuccess;
  final Image image;
  final String msg;

  TorchImageResponse({this.isSuccess, this.image, this.msg});
}

class CarNetPostProcessResponse{
  final CarNetModel carNetModel;
  final TorchImageResponse imageResponse;

  CarNetPostProcessResponse(this.carNetModel, this.imageResponse);
}

class ConsolidateResult{
  final CarNetPostProcessResponse carNetPostProcessResponse;
  final TorchImageResponse imageTorchApiResponse;
  final TorchImageResponse enhanceImgTFM1Response;
  final TorchImageResponse darknessTFM2Response;
  final TorchImageResponse removeDarknessM1Response;
  final ImageDetail imageDetail;

  ConsolidateResult(
      {this.carNetPostProcessResponse,
      this.imageTorchApiResponse,
      this.enhanceImgTFM1Response,
      this.darknessTFM2Response,
      this.removeDarknessM1Response,
      this.imageDetail});
}

class ImageDetail {
  final num imageHeight;
  final num imageWidth;
  final String sizeInKB;
  final String sizeInMB;
  final String imagePath;

  ImageDetail({this.imageHeight, this.imageWidth, this.sizeInKB, this.sizeInMB,this.imagePath});


}

enum imagePickerOption { camera, gallery }

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

Future<File> uploadImageForAngle({@required imagePath}) async {
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

  var dio = Dio();
  String carAngleApi = "https://validate-cars-positions-yozbt3xo3q-uc.a.run.app/validate_car_pos";
  var payload = {'position': 'front right', 'orginal_width': oImageW, 'orginal_hight': oImageH};
  var headers = {
    'content-type': 'application/octet-stream',
    'accept': 'application/json',
  };

  dio.options.headers.addAll(headers);
  var formData = FormData.fromMap({
    'payload': {'position': 'front right', 'orginal_width': oImageW, 'orginal_hight': oImageH},
    'image': await MultipartFile.fromFile(resizeFie.path, filename: 'image.png'),
  });

  try {
    var response = await dio.post(carAngleApi, data: formData);
    print(response.statusCode);
  } catch (e) {
    print('error: ${e.toString()}');
  }

  return resizeFie;
}

Future<String> uploadFileForAngle({String imagePath, String angle}) async {
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

    print(resizeFie.path);

    var request = http.MultipartRequest('POST', Uri.parse(carAngleApi));
    var payload = {'position': angle, 'orginal_width': oImageW.toString(), 'orginal_hight': oImageH.toString()};
    request.headers.addAll(headers);
    request.fields["payload"] = jsonEncode(payload);

    request.files.add(http.MultipartFile('image', resizeFie.readAsBytes().asStream(), resizeFie.lengthSync(), filename: imagePath.split("/").last));

    var streamedResponse = await request.send();
    print('got added ${streamedResponse.statusCode}');
    if (streamedResponse.statusCode == 200) {
      final respBody = await streamedResponse.stream.bytesToString();
      var jsonResponse = json.decode(respBody.toString());
      debugPrint('final : $jsonResponse');
      return jsonResponse.toString();
    }
  } catch (e) {
    print('Error:${e.toString()}');
    return e.toString();
  }

  return 'unknown error';
}

Future<CarNetModel> uploadToCarNet({@required imagePath}) async {
  String carNetUrl = "https://api.carnet.ai/v2/mmg/detect?box_offset=0&box_min_width=180&box_min_height=180&box_min_ratio=1&box_max_ratio=3"
      ".15&box_select=center&region=DEF&features=mmg,color,angle";

  //old api key: 32954476-72e5-47ae-9d27-4e0606735f2e
  String apiKey = '16ac08db-9d44-4512-afd5-7ffba3707da9';

  var headers = {'content-type': 'application/octet-stream', 'accept': 'application/json', 'api-key': '16ac08db-9d44-4512-afd5-7ffba3707da9'};

  var request = http.MultipartRequest('POST', Uri.parse(carNetUrl));

  request.headers.addAll(headers);

  request.files.add(http.MultipartFile('picture', File(imagePath).readAsBytes().asStream(), File(imagePath).lengthSync(), filename: imagePath.split("/").last));

  var streamedResponse = await request.send();
  // if (streamedResponse.statusCode == 200) {
  //
  // }
  // var response = http.Response.fromStream(streamedResponse);
  final respBody = await streamedResponse.stream.bytesToString();
  var jsonResponse = json.decode(respBody.toString());
  debugPrint(jsonResponse.toString());
  return CarNetModel.fromJson(jsonResponse);
  return null;
}

Future<ImageDetail>getImageDetail({@required String imagePath})async{

  await Future.delayed(const Duration(seconds: 1));
  File originalFile = File(imagePath);
  final bytes  =  originalFile.readAsBytesSync().lengthInBytes;
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

Future<Image> imageWithRect(CarNetModel model, String imagePath) async{
  File originalFile = File(imagePath);
  img.Image image = img.decodeImage(originalFile.readAsBytesSync());

  if(!model.isSuccess){
    return Image.memory(img.encodePng(image));
  }

  int oImageH = image.height;
  int oImageW = image.width;


  int x1 = oImageW-(oImageW*model.detections[0].box.brX).toInt();
  int y1 = (oImageH*model.detections[0].box.brY).toInt();
  int x2 = oImageW-(oImageW*(model.detections[0].box.tlX)).toInt();
  int y2 = (oImageH*(model.detections[0].box.tlY)).toInt();

  img.Image rectImage = img.drawRect(
    image,
    x1,
    y1,
    x2,
    y2,
    0xFFFFFFFF,
  );

  int timeStamp = DateTime.now().millisecondsSinceEpoch;

  Image imageReturn = Image.memory(img.encodePng(rectImage));
  // final Directory extDir = await getApplicationDocumentsDirectory();
  // String dirPath = extDir.path;
  // final String filePath = '$dirPath/$timeStamp.png';
  // File resizeFie = File(filePath)..writeAsBytesSync(img.encodePng(rectImage));

  return imageReturn;
}



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

    print(resizeFie.path);

    var request = http.MultipartRequest('POST', Uri.parse(carAngleApi));
    var payload = {'orginal_width': oImageW.toString(), 'orginal_hight': oImageH.toString()};
    request.headers.addAll(headers);
    request.fields["payload"] = jsonEncode(payload);

    request.files.add(http.MultipartFile('image', resizeFie.readAsBytes().asStream(), resizeFie.lengthSync(), filename: imagePath.split("/").last));

    var streamedResponse = await request.send();
    print('got added ${streamedResponse.statusCode}');
    if (streamedResponse.statusCode == 200) {
      final respBody = await streamedResponse.stream.bytesToString();
      var jsonResponse = json.decode(respBody.toString());
      debugPrint('final : $jsonResponse');
      return jsonResponse.toString();
    }
  } catch (e) {
    print('Error:${e.toString()}');
    return e.toString();
  }

  return 'unknown error';
}

Future<TorchImageResponse> imageTorchApi({String imagePath}) async {
  String imageTorchApi = "http://34.72.28.140:8084/enhanceImgTorchM2";
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

    print(resizeFie.path);

    var request = http.MultipartRequest('POST', Uri.parse(imageTorchApi));
    request.headers.addAll(headers);
    // var payload = {'orginal_width':oImageW.toString(), 'orginal_hight':oImageH.toString()};
    // request.fields["payload"] = jsonEncode(payload);

    request.files.add(http.MultipartFile('image', originalFile.readAsBytes().asStream(), originalFile.lengthSync(), filename: imagePath.split("/").last));

    var streamedResponse = await request.send();
    print('got  ${streamedResponse.statusCode}');
    if (streamedResponse.statusCode == 200) {
      final respBody = await streamedResponse.stream.toBytes();

      Image image = Image.memory(respBody);

      return TorchImageResponse(isSuccess: true, image: image);
    }
    return TorchImageResponse(isSuccess: false, image: null, msg: streamedResponse.statusCode.toString());
  } catch (e) {
    print('Error:${e.toString()}');

    return TorchImageResponse(isSuccess: false, image: null, msg: e.toString());
  }
}

Future<TorchImageResponse> segmentCarApi({String imagePath}) async {
  String imageTorchApi = "https://us-central1-autoly-inc.cloudfunctions.net/segment_car_api";
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

    print(resizeFie.path);

    var request = http.MultipartRequest('POST', Uri.parse(imageTorchApi));
    request.headers.addAll(headers);
    // var payload = {'orginal_width':oImageW.toString(), 'orginal_hight':oImageH.toString()};
    // request.fields["payload"] = jsonEncode(payload);

    request.files.add(http.MultipartFile('image', originalFile.readAsBytes().asStream(), originalFile.lengthSync(), filename: imagePath.split("/").last));

    var streamedResponse = await request.send();
    print('got  ${streamedResponse.statusCode}');
    if (streamedResponse.statusCode == 200) {
      final respBody = await streamedResponse.stream.toBytes();
      print(respBody);
      Image image = Image.memory(respBody);

      return TorchImageResponse(isSuccess: true, image: image);
    }
    return TorchImageResponse(isSuccess: false, image: null, msg: streamedResponse.statusCode.toString());
  } catch (e) {
    print('Error:${e.toString()}');

    return TorchImageResponse(isSuccess: false, image: null, msg: e.toString());
  }
}

Future<TorchImageResponse> enhanceImgTFM1({String imagePath}) async {
  String imageTorchApi = "http://35.192.191.7:8082/enhanceImgTFM1";
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

    print(resizeFie.path);

    var request = http.MultipartRequest('POST', Uri.parse(imageTorchApi));
    request.headers.addAll(headers);
    // var payload = {'orginal_width':oImageW.toString(), 'orginal_hight':oImageH.toString()};
    // request.fields["payload"] = jsonEncode(payload);

    request.files.add(http.MultipartFile('image', originalFile.readAsBytes().asStream(), originalFile.lengthSync(), filename: imagePath.split("/").last));

    var streamedResponse = await request.send();
    print('got  ${streamedResponse.statusCode}');
    if (streamedResponse.statusCode == 200) {
      final respBody = await streamedResponse.stream.toBytes();

      Image image = Image.memory(respBody);

      return TorchImageResponse(isSuccess: true, image: image);
    }
    return TorchImageResponse(isSuccess: false, image: null, msg: streamedResponse.statusCode.toString());
  } catch (e) {
    print('Error:${e.toString()}');

    return TorchImageResponse(isSuccess: false, image: null, msg: e.toString());
  }
}

Future<TorchImageResponse> darknessTFM2({String imagePath}) async {
  String imageTorchApi = "http://35.192.191.7:8083/darknessTFM2";
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

    print(resizeFie.path);

    var request = http.MultipartRequest('POST', Uri.parse(imageTorchApi));
    request.headers.addAll(headers);
    // var payload = {'orginal_width':oImageW.toString(), 'orginal_hight':oImageH.toString()};
    // request.fields["payload"] = jsonEncode(payload);

    request.files.add(http.MultipartFile('image', originalFile.readAsBytes().asStream(), originalFile.lengthSync(), filename: imagePath.split("/").last));

    var streamedResponse = await request.send();
    print('got  ${streamedResponse.statusCode}');
    if (streamedResponse.statusCode == 200) {
      final respBody = await streamedResponse.stream.toBytes();

      Image image = Image.memory(respBody);

      return TorchImageResponse(isSuccess: true, image: image);
    }
    return TorchImageResponse(isSuccess: false, image: null, msg: streamedResponse.statusCode.toString());
  } catch (e) {
    print('Error:${e.toString()}');

    return TorchImageResponse(isSuccess: false, image: null, msg: e.toString());
  }
}

Future<TorchImageResponse> removeDarknessM1({String imagePath}) async {
  String imageTorchApi = "https://darkness-image-tf-model-m1-yozbt3xo3q-uc.a.run.app/removeDarknessM1";
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

    print(resizeFie.path);

    var request = http.MultipartRequest('POST', Uri.parse(imageTorchApi));
    request.headers.addAll(headers);
    // var payload = {'orginal_width':oImageW.toString(), 'orginal_hight':oImageH.toString()};
    // request.fields["payload"] = jsonEncode(payload);

    request.files.add(http.MultipartFile('image', originalFile.readAsBytes().asStream(), originalFile.lengthSync(), filename: imagePath.split("/").last));

    var streamedResponse = await request.send();
    print('got  ${streamedResponse.statusCode}');
    if (streamedResponse.statusCode == 200) {
      final respBody = await streamedResponse.stream.toBytes();

      Image image = Image.memory(respBody);

      return TorchImageResponse(isSuccess: true, image: image);
    }
    return TorchImageResponse(isSuccess: false, image: null, msg: streamedResponse.statusCode.toString());
  } catch (e) {
    print('Error:${e.toString()}');

    return TorchImageResponse(isSuccess: false, image: null, msg: e.toString());
  }
}

Future<void> damagesDetectionApi({String imagePath}) async {
  String imageTorchApi = "https://car-damage-detection-yozbt3xo3q-uc.a.run.app/detectDamages";
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

    print(resizeFie.path);

    var request = http.MultipartRequest('POST', Uri.parse(imageTorchApi));
    request.headers.addAll(headers);
    // var payload = {'orginal_width':oImageW.toString(), 'orginal_hight':oImageH.toString()};
    // request.fields["payload"] = jsonEncode(payload);

    request.files.add(http.MultipartFile('image', originalFile.readAsBytes().asStream(), originalFile.lengthSync(), filename: imagePath.split("/").last));

    var streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);
    print(response.statusCode);
    print(response.body);

  } catch (e) {
    print('Error:${e.toString()}');

  }
}

Future<CarNetPostProcessResponse> carNetProcessing({String imagePath})async{
  CarNetModel _model;
  try{
     _model = await uploadToCarNet(imagePath: imagePath);
  }catch(e){
    return CarNetPostProcessResponse(null, TorchImageResponse(
      msg: 'Could not process Image',
      isSuccess: false,
      image: null,
    ),
    );
  }



  try{
    Image imageFile = await imageWithRect(_model,imagePath);
    return CarNetPostProcessResponse(_model, TorchImageResponse(
      msg: 'ok',
      isSuccess: true,
      image: imageFile
    ));

  }catch(e){
    return CarNetPostProcessResponse(null, TorchImageResponse(
      msg: e.toString(),
      isSuccess: false,
      image: null,
    ),);
  }




}