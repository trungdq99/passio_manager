import 'package:flutter/material.dart';
import 'package:passio_manager/bloc_helpers/bloc_provider.dart';
import 'package:passio_manager/bloc_widgets/bloc_state_builder.dart';
import 'package:passio_manager/blocs/login/authentication_bloc.dart';
import 'package:passio_manager/blocs/login/authentication_state.dart';
import 'package:passio_manager/ui/select_store_screen.dart';

class Home extends StatelessWidget {
  Future<bool> _onWillPopScope() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
      body: SafeArea(
          child: BlocEventStateBuilder<AuthenticationState>(
              bloc: bloc,
              builder: (context, state) {
                if (state.isAuthenticated) {
                  return Container(
                    child: FlatButton(
                      child: Text('Click'),
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/select_store'),
                    ),
                  );
                } else {
                  return Container(
                    child: Text('Hello World!'),
                    color: Colors.teal,
                  );
                }
              })),
    );
  }
}
