import 'package:flutter/material.dart';
import 'package:passio_manager/utils/helper.dart';
import 'package:pie_chart/pie_chart.dart';
import './constant.dart';
import './custom_colors.dart';
import 'dart:math' as math;

class CustomWidget {
  static Widget buildImageBackground(BuildContext context) {
    return Image.asset(
      BACKGROUND_IMAGE_PATH,
      fit: BoxFit.fill,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
    );
  }

  static Widget buildBackgroundCover(BuildContext context) {
    return Image.asset(
      'assets/images/cover_profile.png',
      height: MediaQuery.of(context).size.width / 2,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.fill,
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

  static Widget buildChart(BuildContext context, Map<String, double> data) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PieChart(
        dataMap: data,
        colorList: CHART_COLOR,
        showLegends: false,
        chartRadius: MediaQuery.of(context).size.width / 2,
        animationDuration: Duration(milliseconds: 1000),
        initialAngle: -math.pi / 2,
      ),
    );
  }

  static Widget buildOverviewDetail(
      BuildContext context,
      String storeName,
      String date,
      double total,
      double atStore,
      double delivery,
      double takeAway,
      UnitType type) {
    double percentAtStore = total > 0 ? atStore / total : 0;
    double percentDelivery = total > 0 ? delivery / total : 0;
    double percentTakeAway = total > 0 ? takeAway / total : 0;
    Map<String, double> chartData = {
      'at store': percentAtStore,
      'delivery': percentDelivery,
      'take away': percentTakeAway,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomWidget.buildChart(context, chartData),
        Text(
          Helper.numberFormat(total, type),
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          storeName,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          date,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),

        // Chart Detail
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: Table(
            columnWidths: {
              0: FractionColumnWidth(0.12),
              1: FractionColumnWidth(0.44),
              2: FractionColumnWidth(0.44),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder.symmetric(
              outside: BorderSide(
                color: CustomColors.pale_grey,
                width: 1,
              ),
            ),
            children: [
              // Final amount at store
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: CHART_COLOR[0],
                  ),
                  Text(
                    'Tại cửa hàng (${Helper.percentFormat(percentAtStore)})',
                    style: TextStyle(
                      color: CustomColors.dark_sage,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    height: 55,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(
                      right: 16.0,
                    ),
                    child: Text(
                      Helper.numberFormat(atStore, type),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      //textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              // Final amount delivery
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: CHART_COLOR[1],
                  ),
                  Text(
                    'Giao hàng (${Helper.percentFormat(percentDelivery)})',
                    style: TextStyle(
                      color: CustomColors.dark_sage,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    height: 20,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(
                      right: 16.0,
                    ),
                    child: Text(
                      Helper.numberFormat(delivery, type),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      //textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              // Final amount take away
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: CHART_COLOR[2],
                  ),
                  Text(
                    'Mang về (${Helper.percentFormat(percentTakeAway)})',
                    style: TextStyle(
                      color: CustomColors.dark_sage,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    height: 55,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(
                      right: 16.0,
                    ),
                    child: Text(
                      Helper.numberFormat(takeAway, type),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      //textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
