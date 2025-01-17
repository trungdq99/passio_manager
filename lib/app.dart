import 'package:flutter/material.dart';
import 'package:passio_manager/blocs/overview/overview_bloc.dart';
import './utils/constant.dart';
import './bloc_helpers/bloc_provider.dart';
import './blocs/login/authentication_bloc.dart';
import './ui/splash_screen.dart';
import './blocs/filter/filter_bloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: AuthenticationBloc(),
      child: BlocProvider<FilterBloc>(
        bloc: FilterBloc(),
        child: BlocProvider<OverviewBloc>(
          bloc: OverviewBloc(),
          child: MaterialApp(
            title: 'Passio Manager',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Muli',
              primaryColor: Colors.black,
              accentColor: Colors.green,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: SplashScreen(),
            routes: listRoutes,
          ),
        ),
      ),
    );
  }
}
