import 'package:flutter/material.dart';
import 'package:passio_manager/blocs/login/authentication_event.dart';
import 'package:passio_manager/blocs/store/store_bloc.dart';
import 'package:passio_manager/blocs/store/store_state.dart';
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
  AuthenticationBloc _authenticationBloc;
  @override
  Widget build(BuildContext context) {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    return BlocEventStateBuilder<AuthenticationState>(
      bloc: _authenticationBloc,
      builder: (context, state) {
        if (state.isAuthenticated) {
          return _buildHomeScreen();
        } else if (state.isAuthenticating && state.accessToken.isNotEmpty) {
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
    final _storeBloc = BlocProvider.of<StoreBloc>(context);
    return BlocEventStateBuilder<StoreState>(
      bloc: _storeBloc,
      builder: (context, state) {
        if (state.isSelected) {
          return Home();
        }
        if (state.hasFailed) {
          CustomWidget.buildErrorMessage(context, 'Something when wrong!', () {
            _authenticationBloc.emitEvent(AuthenticationEventLogout());
          });
        }
        return SelectStoreScreen();
      },
    );
  }
}
