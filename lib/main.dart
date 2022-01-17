
import 'package:autolydemo/core/common_functions.dart';
import 'package:autolydemo/guided_camera/imageHolderClass.dart';
import 'package:autolydemo/removeDarknessM1/removeDarknessM1Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'carAngle/car_angle_detection_page.dart';
import 'carDetection/car_detection_page.dart';
import 'carNet/carnet_main_widget.dart';
import 'car_damage_page/car_damage_main.dart';
import 'darknessTFM2/darknessTFM2Home.dart';
import 'demo_main_widgets/demo_inprogress_widget.dart';
import 'enhanceImgTFM1Widgets/enhanceingImageTFM1Widget.dart';
import 'guided_camera/basic_view_model.dart';
import 'guided_camera/step_exterior_photo.dart';
import 'image_enhancement/image_enhancement_page.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BasicAdViewModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Autoly Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );

  }
}

class MyHomePage extends StatelessWidget {

  const MyHomePage({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autoly Demo'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        children: [
          ListItemWidget(
            title: 'Guided Camera',
            description: 'Guided camera steps',
            onTap: () async{
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StepExteriorPhotos(),
                ),
              );
            },
          ),
          ListItemWidget(
            title: 'Car  Detection',
            description: 'Detect if car is available in the image',
            onTap: () async{
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CarDetectionPage(),
                ),
              );
            },
          ),
          ListItemWidget(
            title: 'Make Model Recognizer',
            description: 'Cloud ML model, recognize make, model,year,color and angle of car in given image',
            onTap: () async{
              //
              // String file = await pickImage(option: imagePickerOption.gallery);
              //
              // if(file!=null){
              //   await damagesDetectionApi(imagePath: file);
              // }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CarNetHomePage(),
                ),
              );
            },
          ),

          ListItemWidget(
            title: 'Car Angle Detection',
            description: 'Detect car angle',
            onTap: () async{
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CarAngleDetectionPage(),
                ),
              );
            },
          ),

          ListItemWidget(
            title: 'Image Enhancement Option 1',
            description: 'Api enhances image quality',
            onTap: () async{
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ImageEnhancementPage(),
                ),
              );
            },
          ),

          // ListItemWidget(
          //   title: 'Segment Api',
          //   description: 'Car segment api example',
          //   onTap: () async{
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const SegmentCarPage(),
          //       ),
          //     );
          //   },
          // ),
          ListItemWidget(
            title: 'Image Enhancement Option 2',
            description: 'Image Enhancement Option 2',
            onTap: () async{
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EnhanceImgTFM1Page(),
                ),
              );
            },
          ),


          ListItemWidget(
            title: 'Darkness Removal Option 1',
            description: 'This API removes the darkness from image.',
            onTap: () async{
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DarknessTFM2Page(),
                ),
              );
            },
          ),
          ListItemWidget(
            title: 'Darkness Removal Option 2',
            description: 'This API removes the darkness from image.',
            onTap: () async{
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RemoveDarknessM1(),
                ),
              );
            },
          ),

          ListItemWidget(
            title: 'Car Damage Prediction',
            description: 'This API predict damage to car parts',
            onTap: () async{
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CarDamageApiPage(),
                ),
              );

            },
          ),

        ],
      ),
    );
  }
}

class ListItemWidget extends StatelessWidget {
  final String title;
  final String description;
  final Function onTap;
  const ListItemWidget({Key key, @required this.title, @required this.description, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        child: SizedBox(
          height: 200,
          width: size.width * 0.9,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(description),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      color: Colors.blue,
                      onPressed: (){
                        onTap.call();
                      },
                      child: const SizedBox(
                        height: 40,
                        width: 50,
                        child: Center(
                            child: Text(
                          'Explore',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


//uploadFileForAngle: https://validate-cars-positions-yozbt3xo3q-uc.a.run.app/validate_car_pos
//carAngleApi ="https://us-central1-autoly-inc.cloudfunctions.net/detect_car_api";
//https://api.carnet.ai/v2/mmg/detect?box_offset=0&box_min_width=180&box_min_height=180&box_min_ratio=1&box_max_ratio=3"
//       ".15&box_select=center&region=DEF&features=mmg,color,angle
// String Enhance_Torch_M2 ="http://34.72.28.140:8084/enhanceImgTorchM2";


//segement_car_api: 'https://us-central1-autoly-inc.cloudfunctions.net/segment_car_api';
//Enhance_Torch_M2 : 'http://34.72.28.140:8084/enhanceImgTorchM2';
//Darkness_M1_API: 'https://darkness-image-tf-model-m1-yozbt3xo3q-uc.a.run.app/removeDarknessM1';
//Darkness_TF_M2: 'http://35.192.191.7:8083/darknessTFM2';
//Enhance_TF_M1: 'http://35.192.191.7:8082/enhanceImgTFM1';