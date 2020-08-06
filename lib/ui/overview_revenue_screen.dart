import 'package:flutter/material.dart';
import '../bloc_helpers/bloc_provider.dart';
import '../bloc_widgets/bloc_state_builder.dart';
import '../blocs/overview/overview_bloc.dart';
import '../blocs/overview/overview_state.dart';
import '../blocs/store/store_bloc.dart';
import '../blocs/store/store_state.dart';
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
  @override
  Widget build(BuildContext context) {
    final _overviewBloc = BlocProvider.of<OverviewBloc>(context);
    final _storeBloc = BlocProvider.of<StoreBloc>(context);
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
      body: BlocEventStateBuilder<StoreState>(
        bloc: _storeBloc,
        builder: (context, storeState) {
          StoreModel storeModel = StoreModel(id: -1);
          if (storeState.store != null) {
            storeModel = storeState.store;
          }
          return BlocEventStateBuilder<OverviewState>(
              bloc: _overviewBloc,
              builder: (context, state) {
                DateReportModel dateReportModel = DateReportModel();
                if (state.dateReport != null) {
                  dateReportModel = state.dateReport;
                }
                return CustomWidget.buildOverviewDetail(
                    context,
                    storeModel.name,
                    'Chủ nhật, 12/08/2018',
                    dateReportModel.finalAmount,
                    dateReportModel.finalAmountAtStore,
                    dateReportModel.finalAmountDelivery,
                    dateReportModel.finalAmountTakeAway,
                    UnitType.vnd);
              });
        },
      ),
    );
  }
}
