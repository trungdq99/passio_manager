import 'package:flutter/material.dart';
import './constant.dart';

class CustomWidget {
  static Widget buildImageBackground(BuildContext context) {
    return Image.asset(
      backgroundImagePath,
      fit: BoxFit.fitHeight,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
    );
  }
}
