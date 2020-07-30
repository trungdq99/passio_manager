import 'package:flutter/material.dart';
import 'package:passio_manager/bloc_helpers/bloc_provider.dart';
import 'package:passio_manager/blocs/login/authentication_bloc.dart';
import 'package:passio_manager/blocs/login/authentication_event.dart';
import 'package:passio_manager/utils/constant.dart';
import 'package:passio_manager/utils/helper.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: FlatButton(
              color: Colors.teal,
              child: Text('Logout'),
              onPressed: () {
                Helper.removeData(accessTokenKey);
                _authenticationBloc.emitEvent(AuthenticationEventLogout());
              },
            ),
          ),
        ),
      ),
    );
  }
}
