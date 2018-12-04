import 'package:flutter/material.dart';

class LinearGradientCustom{
  List<Color> color;

  LinearGradientCustom(List<Color> color) {
    this.color = color;
  }

  Shader getGradient(){
    return LinearGradient(
      colors: this.color,
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  }
}