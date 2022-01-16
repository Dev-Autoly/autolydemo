class CarNetModel {
  final bool isSuccess;
  final Error error;
  final List<Detections> detections;
  final Meta meta;

  CarNetModel({
    this.isSuccess,
    this.error,
    this.detections,
    this.meta,
  });

  CarNetModel.fromJson(Map<String, dynamic> json)
      : isSuccess = json['is_success'] as bool,
        error = (json['error'] as Map<String,dynamic>) != null ? Error.fromJson(json['error'] as Map<String,dynamic>) : null,
        detections = (json['detections'] as List).map((dynamic e) => Detections.fromJson(e as Map<String,dynamic>)).toList(),
        meta = (json['meta'] as Map<String,dynamic>) != null ? Meta.fromJson(json['meta'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'is_success' : isSuccess,
    'error' : error?.toJson(),
    'detections' : detections?.map((e) => e.toJson())?.toList(),
    'meta' : meta?.toJson()
  };
}

class Error {
  final num code;
  final String message;

  Error({
    this.code,
    this.message,
  });

  Error.fromJson(Map<String, dynamic> json)
      : code = json['code'] as num,
        message = json['message'] as String;

  Map<String, dynamic> toJson() => {
    'code' : code,
    'message' : message
  };
}

class Detections {
  final Box box;
  final CarClass carClass;
  final List<Subclass> subclass;
  final Status status;
  final List<Mm> mm;
  final List<Mmg> mmg;
  final List<ColorValue> color;
  final List<Angle> angle;

  Detections({
  this.box,
  this.carClass,
  this.subclass,
  this.status,
  this.mm,
  this.mmg,
  this.color,
  this.angle,
  });

  Detections.fromJson(Map<String, dynamic> json)
      : box = (json['box'] as Map<String,dynamic>) != null ? Box.fromJson(json['box'] as Map<String,dynamic>) : null,
        carClass = (json['class'] as Map<String,dynamic>) != null ? CarClass.fromJson(json['class'] as Map<String,dynamic>) : null,
  subclass = (json['subclass'] as List)?.map((dynamic e) => Subclass.fromJson(e as Map<String,dynamic>))?.toList(),
  status = (json['status'] as Map<String,dynamic>) != null ? Status.fromJson(json['status'] as Map<String,dynamic>) : null,
  mm = (json['mm'] as List)?.map((dynamic e) => Mm.fromJson(e as Map<String,dynamic>))?.toList(),
  mmg = (json['mmg'] as List)?.map((dynamic e) => Mmg.fromJson(e as Map<String,dynamic>))?.toList(),
  color = (json['color'] as List)?.map((dynamic e) => ColorValue.fromJson(e as Map<String,dynamic>))?.toList(),
  angle = (json['angle'] as List)?.map((dynamic e) => Angle.fromJson(e as Map<String,dynamic>))?.toList();

  Map<String, dynamic> toJson() => {
  'box' : box?.toJson(),
  'class' : carClass?.toJson(),
  'subclass' : subclass?.map((e) => e.toJson())?.toList(),
  'status' : status?.toJson(),
  'mm' : mm?.map((e) => e.toJson())?.toList(),
  'mmg' : mmg?.map((e) => e.toJson())?.toList(),
  'color' : color?.map((e) => e.toJson())?.toList(),
  'angle' : angle?.map((e) => e.toJson())?.toList()
  };
}

class Box {
  final num brX;
  final num brY;
  final num tlX;
  final num tlY;

  Box({
    this.brX,
    this.brY,
    this.tlX,
    this.tlY,
  });

  Box.fromJson(Map<String, dynamic> json)
      : brX = json['br_x'] as num,
        brY = json['br_y'] as num,
        tlX = json['tl_x'] as num,
        tlY = json['tl_y'] as num;

  Map<String, dynamic> toJson() => {
    'br_x' : brX,
    'br_y' : brY,
    'tl_x' : tlX,
    'tl_y' : tlY
  };
}

class CarClass {
  final String name;
  final num probability;

  CarClass({
    this.name,
    this.probability,
  });

  CarClass.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        probability = json['probability'] as num;

  Map<String, dynamic> toJson() => {
    'name' : name,
    'probability' : probability
  };
}

class Subclass {
  final String name;
  final num probability;

  Subclass({
    this.name,
    this.probability,
  });

  Subclass.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        probability = json['probability'] as num;

  Map<String, dynamic> toJson() => {
    'name' : name,
    'probability' : probability
  };
}

class Status {
  final num code;
  final bool selected;
  final String message;

  Status({
    this.code,
    this.selected,
    this.message,
  });

  Status.fromJson(Map<String, dynamic> json)
      : code = json['code'] as num,
        selected = json['selected'] as bool,
        message = json['message'] as String;

  Map<String, dynamic> toJson() => {
    'code' : code,
    'selected' : selected,
    'message' : message
  };
}

class Mm {
  final num makeId;
  final String makeName;
  final num modelId;
  final String modelName;
  final num probability;

  Mm({
    this.makeId,
    this.makeName,
    this.modelId,
    this.modelName,
    this.probability,
  });

  Mm.fromJson(Map<String, dynamic> json)
      : makeId = json['make_id'] as num,
        makeName = json['make_name'] as String,
        modelId = json['model_id'] as num,
        modelName = json['model_name'] as String,
        probability = json['probability'] as num;

  Map<String, dynamic> toJson() => {
    'make_id' : makeId,
    'make_name' : makeName,
    'model_id' : modelId,
    'model_name' : modelName,
    'probability' : probability
  };
}

class Mmg {
  final num makeId;
  final String makeName;
  final num modelId;
  final String modelName;
  final num generationId;
  final String generationName;
  final String years;
  final num probability;

  Mmg({
    this.makeId,
    this.makeName,
    this.modelId,
    this.modelName,
    this.generationId,
    this.generationName,
    this.years,
    this.probability,
  });

  Mmg.fromJson(Map<String, dynamic> json)
      : makeId = json['make_id'] as num,
        makeName = json['make_name'] as String,
        modelId = json['model_id'] as num,
        modelName = json['model_name'] as String,
        generationId = json['generation_id'] as num,
        generationName = json['generation_name'] as String,
        years = json['years'] as String,
        probability = json['probability'] as num;

  Map<String, dynamic> toJson() => {
    'make_id' : makeId,
    'make_name' : makeName,
    'model_id' : modelId,
    'model_name' : modelName,
    'generation_id' : generationId,
    'generation_name' : generationName,
    'years' : years,
    'probability' : probability
  };
}

class ColorValue {
  final num id;
  final String name;
  final num probability;

  ColorValue({
    this.id,
    this.name,
    this.probability,
  });

  ColorValue.fromJson(Map<String, dynamic> json)
      : id = json['id'] as num,
        name = json['name'] as String,
        probability = json['probability'] as num;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'probability' : probability
  };
}

class Angle {
  final String name;
  final num probability;

  Angle({
    this.name,
    this.probability,
  });

  Angle.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        probability = json['probability'] as num;

  Map<String, dynamic> toJson() => {
    'name' : name,
    'probability' : probability
  };
}

class Meta {
  final num classifier;
  final String md5;
  final Parameters parameters;
  final num time;

  Meta({
    this.classifier,
    this.md5,
    this.parameters,
    this.time,
  });

  Meta.fromJson(Map<String, dynamic> json)
      : classifier = json['classifier'] as num,
        md5 = json['md5'] as String,
        parameters = (json['parameters'] as Map<String,dynamic>) != null ? Parameters.fromJson(json['parameters'] as Map<String,dynamic>) : null,
        time = json['time'] as num;

  Map<String, dynamic> toJson() => {
    'classifier' : classifier,
    'md5' : md5,
    'parameters' : parameters?.toJson(),
    'time' : time
  };
}

class Parameters {
  final num boxMaxRatio;
  final num boxMinHeight;
  final num boxMinRatio;
  final num boxMinWidth;
  final num boxOffset;
  final String boxSelect;
  final List<String> features;
  final List<String> region;

  Parameters({
    this.boxMaxRatio,
    this.boxMinHeight,
    this.boxMinRatio,
    this.boxMinWidth,
    this.boxOffset,
    this.boxSelect,
    this.features,
    this.region,
  });

  Parameters.fromJson(Map<String, dynamic> json)
      : boxMaxRatio = json['box_max_ratio'] as num,
        boxMinHeight = json['box_min_height'] as num,
        boxMinRatio = json['box_min_ratio'] as num,
        boxMinWidth = json['box_min_width'] as num,
        boxOffset = json['box_offset'] as num,
        boxSelect = json['box_select'] as String,
        features = (json['features'] as List)?.map((dynamic e) => e as String)?.toList(),
        region = (json['region'] as List)?.map((dynamic e) => e as String)?.toList();

  Map<String, dynamic> toJson() => {
    'box_max_ratio' : boxMaxRatio,
    'box_min_height' : boxMinHeight,
    'box_min_ratio' : boxMinRatio,
    'box_min_width' : boxMinWidth,
    'box_offset' : boxOffset,
    'box_select' : boxSelect,
    'features' : features,
    'region' : region
  };
}