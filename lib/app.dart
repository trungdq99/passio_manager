import 'package:flutter/material.dart';
import './bloc_helpers/bloc_provider.dart';
import './blocs/login/authentication_bloc.dart';
import './blocs/overview/overview_bloc.dart';
import './blocs/store/store_bloc.dart';
import './utils/constant.dart';
import './ui/splash_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: AuthenticationBloc(),
      child: BlocProvider<StoreBloc>(
        bloc: StoreBloc(),
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
          ),
        ),
      ),
    );
  }
}
