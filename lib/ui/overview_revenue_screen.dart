import 'package:flutter/material.dart';
import '../blocs/overview/overview_event.dart';
import '../utils/helper.dart';
import '../blocs/filter/filter_bloc.dart';
import '../bloc_helpers/bloc_provider.dart';
import '../blocs/overview/overview_bloc.dart';
import '../models/date_report_model.dart';
import '../models/store_model.dart';
import '../utils/constant.dart';
import '../utils/custom_colors.dart';
import '../utils/custom_widget.dart';

class OverviewRevenueScreen extends StatefulWidget {
  @override
  _OverviewRevenueScreenState createState() => _OverviewRevenueScreenState();
}

class _OverviewRevenueScreenState extends State<OverviewRevenueScreen> {
  OverviewBloc _overviewBloc;
  FilterBloc _filterBloc;
  @override
  Widget build(BuildContext context) {
    _overviewBloc = BlocProvider.of<OverviewBloc>(context);
    _filterBloc = BlocProvider.of<FilterBloc>(context);
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
          'Doanh thu thực tế',
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
          dateReportModel.finalAmount,
          dateReportModel.finalAmountAtStore,
          dateReportModel.finalAmountDelivery,
          dateReportModel.finalAmountTakeAway,
          UnitType.vnd),
    );
  }
}
