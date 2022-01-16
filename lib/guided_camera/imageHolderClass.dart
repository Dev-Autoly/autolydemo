class ImagesHolderClass {
  String imagePath;
  double topPosition;
  double leftPosition;
  String title;
  int imageIndex;
  bool isUploading;
  String guideImagePath;

  ImagesHolderClass(
      {this.imagePath, this.topPosition, this.leftPosition, this.title, this.imageIndex, this.isUploading = false, this.guideImagePath});

  ImagesHolderClass.fromJson(Map<String, dynamic> json) {
    imagePath = json['imagePath'];
    topPosition = json['topPosition'].toDouble();
    leftPosition = json['leftPosition'];
    title = json['title'];
    imageIndex = json['imageIndex'];
    isUploading = json['isUploading'];
    guideImagePath = json['guideImagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imagePath'] = this.imagePath;
    data['topPosition'] = this.topPosition;
    data['leftPosition'] = this.leftPosition;
    data['title'] = this.title;
    data['imageIndex'] = this.imageIndex;
    data['isUploading'] = this.isUploading;
    data['guideImagePath'] = this.guideImagePath;
    return data;
  }
}

const String frontView = 'assets/guided_camera_new/0.svg';
const String topRightCorner = 'assets/guided_camera_new/1.svg';
const String frontRightWheel = 'assets/guided_camera_new/2.svg';
const String sideRight = 'assets/guided_camera_new/3.svg';
const String backRightWheel = 'assets/guided_camera_new/4.svg';
const String backRightCorner = 'assets/guided_camera_new/5.svg';
const String backView = 'assets/guided_camera_new/6.svg';
const String backLeftCorner = 'assets/guided_camera_new/7.svg';
const String backLeftWheel = 'assets/guided_camera_new/8.svg';
const String sideLeft = 'assets/guided_camera_new/9.svg';
const String frontLeftWheel = 'assets/guided_camera_new/10.svg';
const String topLeftCorner = 'assets/guided_camera_new/11.svg';

/// images for interior
const String interiorBack = "assets/guided_camera_new/interior/interior_back.svg";
const String interiorTopRight = "assets/guided_camera_new/interior/interior_topRight.svg";
const String interiorTopLeft = "assets/guided_camera_new/interior/interior_topLeft.svg";
const String interiorCornerRight = "assets/guided_camera_new/interior/interior_corner_right.svg";
const String interiorCornerLeft = "assets/guided_camera_new/interior/interior_corner_left.svg";
const String interiorDashBoard = 'assets/guided_camera_new/interior/interior_dashboard.svg';

List<ImagesHolderClass> exteriorImageDefaultList = [
  ImagesHolderClass(topPosition: 0.0, leftPosition: 0.45, title: 'Front', imageIndex: 0, guideImagePath: frontView),
  ImagesHolderClass(topPosition: 0.04, leftPosition: 0.67, title: 'Front Corner R', imageIndex: 1, guideImagePath: topRightCorner),
  // ImagesHolderClass(topPosition: 0.15, leftPosition: 0.7, title: 'Front Wheel R', imageIndex: 2, guideImagePath: frontRightWheel),
  ImagesHolderClass(topPosition: 0.32, leftPosition: 0.76, title: 'Side R', imageIndex: 3, guideImagePath: sideRight),
  // ImagesHolderClass(topPosition: 0.48, leftPosition: 0.7, title: 'Back Wheel R', imageIndex: 4, guideImagePath: backRightWheel),
  ImagesHolderClass(topPosition: 0.57, leftPosition: 0.66, title: 'Back Corner R', imageIndex: 3, guideImagePath: backRightCorner),
  ImagesHolderClass(topPosition: 0.6, leftPosition: 0.45, title: 'Back', imageIndex: 4, guideImagePath: backView),
  ImagesHolderClass(topPosition: 0.57, leftPosition: 0.1, title: 'Back Corner L', imageIndex: 5, guideImagePath: backLeftCorner),
  // ImagesHolderClass(topPosition: 0.48, leftPosition: 0.11, title: 'Back Wheel L', imageIndex: 8, guideImagePath: backLeftWheel),
  ImagesHolderClass(topPosition: 0.32, leftPosition: 0.15, title: 'Side L', imageIndex: 6, guideImagePath: sideLeft),
  ImagesHolderClass(topPosition: 0.04, leftPosition: 0.11, title: 'Front Wheel L', imageIndex: 7, guideImagePath: frontLeftWheel),
  // ImagesHolderClass(topPosition: 0.04, leftPosition: 0.1, title: 'Front Corner L', imageIndex: 11, guideImagePath: topLeftCorner),
];



