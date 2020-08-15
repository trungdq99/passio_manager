import 'package:flutter/material.dart';
import '../blocs/filter/filter_bloc.dart';
import '../utils/helper.dart';
import '../bloc_helpers/bloc_provider.dart';
import '../blocs/overview/overview_bloc.dart';
import '../models/date_report_model.dart';
import '../models/store_model.dart';
import '../utils/constant.dart';
import '../utils/custom_colors.dart';
import '../utils/custom_widget.dart';

class OverviewReceiptsScreen extends StatefulWidget {
  @override
  _OverviewReceiptsScreenState createState() => _OverviewReceiptsScreenState();
}

class _OverviewReceiptsScreenState extends State<OverviewReceiptsScreen> {
  @override
  Widget build(BuildContext context) {
    final _overviewBloc = BlocProvider.of<OverviewBloc>(context);
    final _filterBloc = BlocProvider.of<FilterBloc>(context);
    StoreModel storeModel = _filterBloc.storeModel ?? StoreModel(id: -1);
    DateTimeRange dateTimeRange = _filterBloc.dateTimeRange ??
        DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now(),
        );
    DateReportModel dateReportModel =
        _overviewBloc.dateReportModel ?? DateReportModel();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hoá đơn bán hàng',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        leading: FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
            size: 24,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: CustomColors.background,
      body: CustomWidget.buildOverviewDetail(
          context,
          storeModel.name,
          Helper.formatDateTime(dateTimeRange.start),
          dateReportModel.totalOrder.toDouble(),
          dateReportModel.totalOrderAtStore.toDouble(),
          dateReportModel.totalOrderDelivery.toDouble(),
          dateReportModel.totalOrderTakeAway.toDouble(),
          UnitType.order),
    );
  }
}
