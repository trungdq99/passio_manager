import 'package:flutter/material.dart';
import './constant.dart';
import './custom_colors.dart';

class CustomWidget {
  static Widget buildImageBackground(BuildContext context) {
    return Image.asset(
      backgroundImagePath,
      fit: BoxFit.fitHeight,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
    );
  }

  static Widget buildProcessing(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      child: AlertDialog(
        title: Center(
          child: CircularProgressIndicator(
            backgroundColor: CustomColors.sick_green,
          ),
        ),
      ),
    );
  }

  static Widget buildErrorMessage(
      BuildContext context, String message, Function handleErrorFunction) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: AlertDialog(
        title: Center(
          child: Text(
            message,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
        ),
        titlePadding: EdgeInsets.only(
          top: 20,
        ),
        actions: [
          Container(
            alignment: Alignment.center,
            width: double.maxFinite,
            child: FlatButton(
              onPressed: handleErrorFunction,
              child: Text(
                'OK',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
