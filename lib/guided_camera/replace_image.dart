import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'basic_view_model.dart';
import 'imageHolderClass.dart';
import 'touchable_opacity.dart';

class ReplaceImage extends StatefulWidget {
  final ImagesHolderClass imageHolder;

  const ReplaceImage(this.imageHolder, {Key key}) : super(key: key);

  @override
  _ReplaceImageState createState() => _ReplaceImageState();
}

class _ReplaceImageState extends State<ReplaceImage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ViewModelBuilder<BasicAdViewModel>.reactive(
          viewModelBuilder: () => BasicAdViewModel(),
          disposeViewModel: false,
          builder: (context, model, child) {
            return Align(
                alignment: Alignment.topCenter,
                child: Stack(
                  children: [
                    Center(
                      child: AnimatedContainer(
                        height: 400,
                        duration: const Duration(milliseconds: 400),
                        width: 320,
                        // margin: EdgeInsets.all(10),
                        // padding: const EdgeInsets.all(20).copyWith(left: 30, right: 30, bottom: 8),
                        // decoration: BoxDecoration(
                        //   // color: Colors.white,
                        //   borderRadius: BorderRadius.circular(20),
                        // ),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: Container(
                                    width: 330,
                                    // height: 300,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(11)),
                                        image: DecorationImage(image: NetworkImage(widget.imageHolder.imagePath), fit: BoxFit.cover),
                                        border: Border.all(color: const Color(0xff008dcc), width: 0.5)))),
                            Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        return Navigator.pop(context, true);
                                      },
                                      child: Container(
                                          width: 120,
                                          height: 60,
                                          margin: const EdgeInsets.all(4),
                                          alignment: Alignment.center,
                                          child: // Save
                                              Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: const [
                                              Icon(
                                                Icons.sync_rounded,
                                                color: Colors.white,
                                                size: 26,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 3, left: 5),
                                                child: Text("Retake",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w700,
                                                        // fontFamily: grandStanderFamilyName,
                                                        fontStyle: FontStyle.normal,
                                                        fontSize: 18.0),
                                                    textAlign: TextAlign.left),
                                              ),
                                            ],
                                          ),
                                          decoration:
                                              const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Color(0xffff77a3))),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        return Navigator.pop(context, false);
                                      },
                                      child: Container(
                                          width: 120,
                                          height: 60,
                                          margin: const EdgeInsets.all(4),
                                          alignment: Alignment.center,
                                          child: // Save
                                              Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: const [
                                               Icon(
                                                Icons.cancel_outlined,
                                                // color: ceruleanTwo,
                                                size: 26,
                                              ),
                                               Padding(
                                                padding: EdgeInsets.only(top: 3, left: 5),
                                                child: Text("Delete",
                                                    style: TextStyle(
                                                        // color: ceruleanTwo,
                                                        fontWeight: FontWeight.w700,
                                                        // fontFamily: grandStanderFamilyName,
                                                        fontStyle: FontStyle.normal,
                                                        fontSize: 18.0),
                                                    textAlign: TextAlign.left),
                                              ),
                                            ],
                                          ),
                                          decoration:
                                              const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.white)),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        right: 20,
                        top: 30,
                        child: TouchableOpacity(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(
                            Icons.cancel_outlined,
                            color: Colors.white,
                            size: 26,
                          ),
                        ))
                  ],
                ));
          }),
    );
  }
}
