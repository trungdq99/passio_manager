import 'package:flutter/material.dart';
import 'package:passio_manager/bloc_helpers/bloc_provider.dart';
import 'package:passio_manager/blocs/login/authentication_bloc.dart';
import './utils/constant.dart';
import './ui/splash_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: AuthenticationBloc(),
      child: MaterialApp(
        title: 'Passio Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Muli',
          primaryColor: Colors.black,
          accentColor: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: routes,
        home: SplashScreen(),
      ),
    );
  }
}
