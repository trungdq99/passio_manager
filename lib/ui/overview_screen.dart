import 'package:flutter/material.dart';
import './overview_receipts_screen.dart';
import '../bloc_helpers/bloc_provider.dart';
import '../bloc_widgets/bloc_state_builder.dart';
import '../blocs/login/authentication_bloc.dart';
import '../blocs/login/authentication_event.dart';
import '../blocs/overview/overview_bloc.dart';
import '../blocs/overview/overview_screen_bloc.dart';
import '../blocs/overview/overview_state.dart';
import '../blocs/store/store_bloc.dart';
import '../blocs/store/store_event.dart';
import '../models/date_report_model.dart';
import './overview_revenue_screen.dart';
import '../utils/constant.dart';
import '../utils/custom_colors.dart';
import '../utils/custom_widget.dart';
import '../utils/helper.dart';

class OverviewScreen extends StatefulWidget {
  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  ScrollController _scrollController;
  OverviewScreenBloc _overviewScreenBloc;
  OverviewBloc _overviewBloc;
  AuthenticationBloc _authenticationBloc;
  StoreBloc _storeBloc;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(initialScrollOffset: 0.0);
    _overviewScreenBloc = OverviewScreenBloc();
    _scrollController.addListener(
        () => _overviewScreenBloc.onScroll(_scrollController.offset));
  }

  @override
  Widget build(BuildContext context) {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _storeBloc = BlocProvider.of<StoreBloc>(context);
    _overviewBloc = BlocProvider.of<OverviewBloc>(context);
    return BlocEventStateBuilder<OverviewState>(
      bloc: _overviewBloc,
      builder: (context, state) {
        if (state.hasFailed) {
          CustomWidget.buildErrorMessage(context, 'Something when wrong!', () {
            _authenticationBloc.emitEvent(AuthenticationEventLogout());
          });
        }
        DateReportModel dateReport = DateReportModel();
        if (state.dateReport != null) {
          dateReport = state.dateReport;
        }
        List<Widget> _children = [];
        _children.add(_buildScreen(dateReport));
        if (state.isLoading) {
          _children.add(CustomWidget.buildProcessing(context));
        }
        return Stack(
          children: _children,
        );
      },
    );
  }

  // Build Screen
  Widget _buildScreen(DateReportModel dateReport) {
    return Scaffold(
      backgroundColor: CustomColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(),
          SliverList(
              delegate: SliverChildListDelegate([
            _buildFinalAmount(dateReport),
            _buildTotalOrder(dateReport),
            SizedBox(
              height: 100,
            ),
          ])),
        ],
      ),
    );
  }

  // App bar
  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 400.0,
      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          height: 400.0,
          padding: EdgeInsets.only(
            left: 16.0,
            bottom: 20.0,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.5, 1),
              end: Alignment(0.5, 0),
              colors: [
                const Color(0xff59a927),
                const Color(0xffa6ce39),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _storeBloc.lastState.store != null
                    ? _storeBloc.lastState.store.name
                    : '',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                'Chủ nhật, 12/08/2018',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: 250,
              ),
            ],
          ),
        ),
      ),
      title: StreamBuilder<Color>(
          stream: _overviewScreenBloc.appBarColor,
          builder: (context, snapshot) {
            Color color = Colors.white;
            if (snapshot.hasData) {
              color = snapshot.data;
            }
            return Text(
              'Tổng quan',
              style: TextStyle(
                color: color,
                fontSize: 24.0,
                fontWeight: FontWeight.w800,
              ),
            );
          }),
      backgroundColor: Colors.white,
      actions: <Widget>[
        StreamBuilder<String>(
            stream: _overviewScreenBloc.filterIcon,
            builder: (context, snapshot) {
              String icon = FILTER_WHITE_ICON_PATH;
              if (snapshot.hasData) {
                icon = snapshot.data;
              }
              return IconButton(
                icon: Image.asset(icon),
                onPressed: () {
                  print('You have pressed filter button');
                  _storeBloc.emitEvent(
                      StoreEventSelecting(store: _storeBloc.lastState.store));
                },
              );
            }),
        StreamBuilder<String>(
            stream: _overviewScreenBloc.shareIcon,
            builder: (context, snapshot) {
              String icon = SHARE_WHITE_ICON_PATH;
              if (snapshot.hasData) {
                icon = snapshot.data;
              }
              return IconButton(
                icon: Image.asset(icon),
                onPressed: () {
                  print('You have pressed share button');
                },
              );
            }),
      ],
    );
  }

  // Build Final Amount
  Widget _buildFinalAmount(DateReportModel dateReport) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 10.0,
      ),
      shadowColor: CustomColors.pale_grey,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: CustomColors.bluey_green,
          child: Icon(
            Icons.attach_money,
            color: Colors.white,
            size: 24,
          ),
        ),
        title: Text(
          'Tổng doanh thu',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),
        subtitle: Text(
          Helper.numberFormat(dateReport.finalAmount, UnitType.vnd),
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.left,
        ),
        children: [
          _buildDetail('Trước giảm giá', dateReport.totalAmount, UnitType.vnd),
          _buildDetail('Giảm giá bán hàng', dateReport.discount, UnitType.vnd),
          _buildDetail('Thực tế', dateReport.finalAmount, UnitType.vnd),
          _buildDetail('Nạp thẻ', dateReport.finalAmountCard, UnitType.vnd),
          Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          FlatButton(
            onPressed: () {
              print('show revenue');
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => OverviewRevenueScreen(),
              ));
            },
            child: Text(
              'Xem chi tiết',
              style: TextStyle(
                fontSize: 14.0,
                color: CustomColors.sick_green,
                fontWeight: FontWeight.w800,
              ),
            ),
            height: 50,
            minWidth: MediaQuery.of(context).size.width,
          ),
        ],
      ),
    );
  }

  // Build Total Order
  Widget _buildTotalOrder(DateReportModel dateReport) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 10.0,
      ),
      shadowColor: CustomColors.pale_grey,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: CustomColors.dark_sky_blue,
          child: Icon(
            Icons.receipt,
            color: Colors.white,
            size: 24,
          ),
        ),
        title: Text(
          'Tổng số hoá đơn',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),
        subtitle: Text(
          Helper.numberFormat(dateReport.totalOrder, UnitType.order),
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.left,
        ),
        children: [
          _buildDetail(
              'Tại quán', dateReport.totalOrderAtStore, UnitType.order),
          _buildDetail(
              'Mang đi', dateReport.totalOrderTakeAway, UnitType.order),
          _buildDetail(
              'Giao hàng', dateReport.totalOrderDelivery, UnitType.order),
          _buildDetail('Nạp thẻ', dateReport.totalOrderCard, UnitType.order),
          Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          FlatButton(
            onPressed: () {
              print('show receipts');
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => OverviewReceiptsScreen(),
              ));
            },
            child: Text(
              'Xem chi tiết',
              style: TextStyle(
                fontSize: 14.0,
                color: CustomColors.sick_green,
                fontWeight: FontWeight.w800,
              ),
            ),
            height: 50,
            minWidth: MediaQuery.of(context).size.width,
          ),
        ],
      ),
    );
  }

  // Build Detail
  Widget _buildDetail(String key, dynamic value, UnitType type) {
    return ListTile(
      title: Text(
        key,
        style: TextStyle(
          fontStyle: FontStyle.normal,
          fontSize: 14.0,
          color: CustomColors.dark_sage,
        ),
      ),
      trailing: Text(
        Helper.numberFormat(value, type),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
