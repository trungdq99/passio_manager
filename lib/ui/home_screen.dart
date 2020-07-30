import 'package:flutter/material.dart';
import 'package:passio_manager/ui/home.dart';
import 'package:passio_manager/ui/select_store_screen.dart';
import 'package:passio_manager/utils/custom_widget.dart';
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
  @override
  Widget build(BuildContext context) {
    AuthenticationBloc bloc = BlocProvider.of<AuthenticationBloc>(context);
    return BlocEventStateBuilder<AuthenticationState>(
      bloc: bloc,
      builder: (context, state) {
        if (state.isAuthenticated) {
          return Home();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
