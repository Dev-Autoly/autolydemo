
import 'package:stacked/stacked.dart';

import 'car_ad.dart';
import 'imageHolderClass.dart';

class BasicAdViewModel extends BaseViewModel {
  CarAd carAd = CarAd();



  initScreen() {
    carAd.exteriorImages = [
      ImagesHolderClass(topPosition: 0.0, leftPosition: 0.45, title: 'Front', imageIndex: 0, guideImagePath: frontView),
      ImagesHolderClass(topPosition: 0.03, leftPosition: 0.7, title: 'Front Corner R', imageIndex: 1, guideImagePath: topRightCorner),
      // ImagesHolderClass(topPosition: 0.15, leftPosition: 0.75, title: 'Front Wheel R', imageIndex: 2, guideImagePath: frontRightWheel),
      ImagesHolderClass(topPosition: 0.32, leftPosition: 0.76, title: 'Side R', imageIndex: 2, guideImagePath: sideRight),
      // ImagesHolderClass(topPosition: 0.48, leftPosition: 0.75, title: 'Back Wheel R', imageIndex: 4, guideImagePath: backRightWheel),
      ImagesHolderClass(topPosition: 0.58, leftPosition: 0.7, title: 'Back Corner R', imageIndex: 3, guideImagePath: backRightCorner),
      ImagesHolderClass(topPosition: 0.6, leftPosition: 0.45, title: 'Back', imageIndex: 4, guideImagePath: backView),
      ImagesHolderClass(topPosition: 0.58, leftPosition: 0.2, title: 'Back Corner L', imageIndex: 5, guideImagePath: backLeftCorner),
      // ImagesHolderClass(topPosition: 0.48, leftPosition: 0.12, title: 'Back Wheel L', imageIndex: 8, guideImagePath: backLeftWheel),
      ImagesHolderClass(topPosition: 0.32, leftPosition: 0.12, title: 'Side L', imageIndex: 6, guideImagePath: sideLeft),
      ImagesHolderClass(topPosition: 0.15, leftPosition: 0.12, title: 'Front Wheel L', imageIndex: 7, guideImagePath: frontLeftWheel),
      // ImagesHolderClass(topPosition: 0.03, leftPosition: 0.2, title: 'Front Corner L', imageIndex: 7, guideImagePath: topLeftCorner),
    ];
  }
  void updateExteriorImageClassList({int index, ImagesHolderClass imagesHolderClass}) async {
    carAd.exteriorImages[index] = imagesHolderClass;
    notifyListeners();
  }

}
