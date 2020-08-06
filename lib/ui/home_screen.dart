import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passio_manager/blocs/overview/overview_bloc.dart';
import 'package:passio_manager/blocs/overview/overview_event.dart';
import 'package:passio_manager/blocs/overview/overview_state.dart';
import 'package:passio_manager/models/date_report_model.dart';
import 'package:passio_manager/ui/overview_revenue_screen.dart';
import 'package:passio_manager/ui/overview_screen.dart';
import '../blocs/login/authentication_event.dart';
import '../blocs/store/store_bloc.dart';
import '../blocs/store/store_state.dart';
import './profile_screen.dart';
import './select_store_screen.dart';
import '../utils/custom_colors.dart';
import '../utils/custom_widget.dart';
import '../bloc_helpers/bloc_provider.dart';
import '../bloc_widgets/bloc_state_builder.dart';
import '../blocs/login/authentication_bloc.dart';
import '../blocs/login/authentication_state.dart';
import './login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthenticationBloc _authenticationBloc;
  StoreBloc _storeBloc;
  OverviewBloc _overviewBloc;
  @override
  Widget build(BuildContext context) {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _storeBloc = BlocProvider.of<StoreBloc>(context);
    _overviewBloc = BlocProvider.of<OverviewBloc>(context);
    return BlocEventStateBuilder<AuthenticationState>(
      bloc: _authenticationBloc,
      builder: (context, state) {
        if (state.isAuthenticated) {
          return _buildHomeScreen();
        } else if (state.isAuthenticating && state.user != null) {
          return Stack(
            children: [
              CustomWidget.buildImageBackground(context),
              CustomWidget.buildProcessing(context),
            ],
          );
        } else {
          return LoginScreen();
        }
      },
    );
  }

  Widget _buildHomeScreen() {
    return BlocEventStateBuilder<StoreState>(
      bloc: _storeBloc,
      builder: (context, storeState) {
        if (storeState.isSelected) {
          loadData();
          return CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items: _bottomNavigationBarItemList,
              activeColor: Colors.black,
              inactiveColor: CustomColors.cool_grey,
            ),
            tabBuilder: (context, index) {
              CupertinoTabView returnValue;
              switch (index) {
                case 0:
                  returnValue = CupertinoTabView(
                    builder: (context) {
                      return OverviewScreen();
                    },
                  );
                  break;
                case 1:
                  returnValue = CupertinoTabView(
                    builder: (context) {
                      return CupertinoPageScaffold(
                        child: Scaffold(
                          body: Container(
                            alignment: Alignment.center,
                            color: Colors.teal,
                            child: Text(
                                '${storeState.store.id} - ${storeState.store.name}'),
                          ),
                        ),
                      );
                    },
                  );
                  break;
                case 2:
                  returnValue = CupertinoTabView(
                    builder: (context) {
                      return ProfileScreen();
                    },
                  );
                  break;
              }
              return returnValue;
            },
          );
          ;
        }
        if (storeState.hasFailed) {
          CustomWidget.buildErrorMessage(context, 'Something when wrong!', () {
            _authenticationBloc.emitEvent(AuthenticationEventLogout());
          });
        }
        return SelectStoreScreen();
      },
    );
  }

  // 3 tabs
  List<BottomNavigationBarItem> _bottomNavigationBarItemList = [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.assessment,
        color: CustomColors.cool_grey,
        size: 24,
      ),
      title: Text(
        'Tổng quan',
        style: TextStyle(
          fontSize: 10,
        ),
      ),
      activeIcon: Icon(
        Icons.assessment,
        color: CustomColors.sick_green,
        size: 24,
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.description,
        color: CustomColors.cool_grey,
        size: 24,
      ),
      title: Text(
        'Báo cáo',
        style: TextStyle(
          fontSize: 10,
        ),
      ),
      activeIcon: Icon(
        Icons.description,
        color: CustomColors.sick_green,
        size: 24,
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.account_circle,
        color: CustomColors.cool_grey,
        size: 24,
      ),
      title: Text(
        'Cá nhân',
        style: TextStyle(
          fontSize: 10,
        ),
      ),
      activeIcon: Icon(
        Icons.account_circle,
        color: CustomColors.sick_green,
        size: 24,
      ),
    ),
  ];

  loadData() async {
    DateReportModel dateReportModel;
    if (_authenticationBloc.lastState.user != null &&
        _storeBloc.lastState.store != null) {
      dateReportModel = await _overviewBloc.getDateReport(
        _authenticationBloc.lastState.user.accessToken,
        '2018/08/12',
        '2018/08/12',
        _storeBloc.lastState.store.id,
      );
    } else {
      dateReportModel = null;
    }
    _overviewBloc.emitEvent(OverviewEvent(dateReportModel: dateReportModel));
  }
}
