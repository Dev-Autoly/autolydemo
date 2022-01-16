
import 'package:flutter/material.dart';

class DisplayCenterText extends StatelessWidget {
  final String msg;
  const DisplayCenterText({Key key, @required this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(msg),
      ),
    );
  }
}