

import 'package:flutter/material.dart';

class ScanAnimationWidget extends StatefulWidget {
  const ScanAnimationWidget({Key key}) : super(key: key);

  @override
  _ScanAnimationWidgetState createState() => _ScanAnimationWidgetState();
}

class _ScanAnimationWidgetState extends State<ScanAnimationWidget> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animateScanAnimation(true);
      } else if (status == AnimationStatus.dismissed) {
        animateScanAnimation(false);
      }
    });
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void animateScanAnimation(bool reverse) {
    if (reverse) {
      _animationController.reverse(from: 1.0);
    } else {
      _animationController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color color1 = const Color(0x5532CD32);
    Color color2 = const Color(0x0032CD32);

    if (_animationController.status == AnimationStatus.reverse) {
      color1 = const Color(0x0032CD32);
      color2 = const Color(0x5532CD32);
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        return Positioned(
          bottom: (_animationController.value * size.height * 0.3),
          left: 10.0,
          right: 10.0,
          child: Container(
            height: 60.0,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.1, 0.9],
                colors: [color1, color2],
              ),
            ),
          ),
        );
      },
    );
  }
}