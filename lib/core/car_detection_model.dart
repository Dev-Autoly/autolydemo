class CarDetectionResponse {
  List<num> box;
  double carAccuracy;
  String image;
  String message;
  bool state;

  CarDetectionResponse(
      {this.box, this.carAccuracy, this.image, this.message, this.state});

  CarDetectionResponse.fromJson(Map<String, dynamic> json) {
    box = json['box'].cast<num>();
    carAccuracy = json['car_accuracy'];
    image = json['image'];
    message = json['message'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['box'] = box;
    data['car_accuracy'] = carAccuracy;
    data['image'] = image;
    data['message'] = message;
    data['state'] = state;
    return data;
  }
}