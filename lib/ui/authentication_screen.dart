import 'package:flutter/material.dart';
import '../bloc_helpers/bloc_provider.dart';
import '../bloc_widgets/bloc_state_builder.dart';
import '../blocs/login/authentication_bloc.dart';
import '../blocs/login/authentication_state.dart';
import '../ui/home_screen.dart';
import './login_screen.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  @override
  Widget build(BuildContext context) {
    final _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    return BlocEventStateBuilder<AuthenticationState>(
      builder: (BuildContext context, AuthenticationState state) {
        if (state.isAuthenticated) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
      bloc: _authenticationBloc,
    );
  }
}
