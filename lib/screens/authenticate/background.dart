import 'package:app/constants/colour.dart';
import 'package:flutter/material.dart';


// background class to make any alterations easy
class Background extends StatelessWidget {
  
  final Widget child;
  Background({this.child});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // total height and width of screen

    return Scaffold(
      body: Container(
          height: size.height,
          width: double.infinity,
          color: bodyColour,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              child,
            ],
          )),
    );
  }
}
