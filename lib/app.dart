import 'package:flutter/material.dart';
import 'package:passio_manager/ui/home_screen.dart';
import './blocs/bloc_provider.dart';
import './blocs/login_bloc.dart';
import 'splash_screen.dart';

class App extends StatelessWidget {
  final loginBLoc = LoginBloc();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      bloc: loginBLoc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Muli',
          primaryColor: Colors.black,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
