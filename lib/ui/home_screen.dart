import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../blocs/filter/filter_bloc.dart';
import '../blocs/filter/filter_event.dart';
import '../blocs/filter/filter_state.dart';
import '../blocs/overview/overview_bloc.dart';
import '../blocs/overview/overview_event.dart';
import '../blocs/overview/overview_state.dart';
import '../models/store_model.dart';
import '../ui/overview_filter_screen.dart';
import '../ui/overview_screen.dart';
import '../blocs/login/authentication_event.dart';
import './profile_screen.dart';
import './select_store_screen.dart';
import '../utils/custom_colors.dart';
import '../utils/custom_widget.dart';
import '../bloc_helpers/bloc_provider.dart';
import '../bloc_widgets/bloc_state_builder.dart';
import '../blocs/login/authentication_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthenticationBloc _authenticationBloc;
  FilterBloc _filterBloc;
  OverviewBloc _overviewBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _filterBloc = BlocProvider.of<FilterBloc>(context);
    _overviewBloc = BlocProvider.of<OverviewBloc>(context);
    String accessToken = '';
    if (_authenticationBloc.lastState.isAuthenticated) {
      accessToken = _authenticationBloc.lastState.userModel?.accessToken;
    }
    if (accessToken.isNotEmpty) {
      _filterBloc
          .emitEvent(FilterEventLoadPreviousStore(accessToken: accessToken));
    }
    StoreModel storeModel;
    DateTimeRange dateTimeRange;
    return BlocEventStateBuilder<FilterState>(
      bloc: _filterBloc,
      builder: (context, filterState) {
        if (filterState.isSelected) {
          storeModel = _filterBloc.storeModel;
          dateTimeRange = _filterBloc.dateTimeRange;
        } else if (filterState.isSelecting) {
          return Scaffold(
            body: CustomWidget.buildProcessing(context),
            backgroundColor: CustomColors.background,
          );
        } else if (filterState.notSelectStore) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SelectStoreScreen(
                route: '',
              ),
            ));
          });
        } else if (filterState.isOverview) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => OverviewFilterScreen(),
            ));
          });
        } else if (filterState.hasFailed) {
          CustomWidget.buildErrorMessage(context, 'Something when wrong!', () {
            _authenticationBloc.emitEvent(AuthenticationEventLogout());
          });
        }
        if (storeModel != null && dateTimeRange != null) {
          _overviewBloc.emitEvent(OverviewEventLoad(
            storeModel: storeModel,
            dateTimeRange: dateTimeRange,
            accessToken: accessToken,
          ));
        }
//        return Scaffold(
//          body: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: [
//              Text(storeModel.name),
//              Text(dateTimeRange.toString()),
//              FlatButton(
//                onPressed: () => _filterBloc.emitEvent(FilterEventOverview(
////                  storeModel: storeModel,
////                  dateTimeRange: dateTimeRange,
//                  storeModel: filterState.storeModel,
//                  dateTimeRange: filterState.dateTimeRange,
//                )),
//                child: Text('Filter'),
//                color: Colors.teal,
//              ),
//              FlatButton(
//                onPressed: () =>
//                    _authenticationBloc.emitEvent(AuthenticationEventLogout()),
//                child: Text('Logout'),
//                color: Colors.teal,
//              ),
//            ],
//          ),
//        );
        return _buildHomeScreen();
      },
    );
  }

  Widget _buildHomeScreen() {
    return BlocEventStateBuilder<FilterState>(
      bloc: _filterBloc,
      builder: (context, filterState) {
        return BlocEventStateBuilder<OverviewState>(
          builder: (context, overviewState) {
            if (overviewState.showRevenue) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context)
                    .pushNamed('/overview_revenue')
                    .whenComplete(() =>
                        _overviewBloc.emitEvent(OverviewEventShowOverview()));
              });
            }
            if (overviewState.showReceipts) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context)
                    .pushNamed('/overview_receipts')
                    .whenComplete(() =>
                        _overviewBloc.emitEvent(OverviewEventShowOverview()));
              });
            }
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
                                  '${filterState.storeModel.id} - ${filterState.storeModel.name}'),
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
          },
          bloc: _overviewBloc,
        );
      },
    );
  }

  // List Bottom Navigation Bar Items
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
}
