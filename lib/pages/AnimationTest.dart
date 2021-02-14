import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorfly/component/StaggerAnimation.dart';

class AnimationTest extends StatefulWidget {
  AnimationTest({Key key}) : super(key: key);

  @override
  _AnimationTestState createState() => _AnimationTestState();
}

class _AnimationTestState extends State<AnimationTest>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    animation = Tween(begin: -50.0, end: 50.0).animate(controller);
    // animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("动画测试"),
      ),
      body: Container(
          child: Stack(
        children: [
          // StaggerAnimation(
          //   controller: controller,
          // ),
          Positioned(
            child: AnimatedBuilder(
                animation: animation,
                child: Container(
                  color: Colors.amber,
                ),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, animation.value),
                    child: Container(
                      width: 50,
                      height: 50,
                      child: child,
                    ),
                  );
                }),
            // top: animation.value,
          )
        ],
      )),
    ));
  }
}
