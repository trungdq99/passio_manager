import 'package:flutter/material.dart';
import 'package:passio_manager/bloc_helpers/bloc_provider.dart';
import 'package:passio_manager/bloc_widgets/bloc_state_builder.dart';
import 'package:passio_manager/blocs/login/authentication_bloc.dart';
import 'package:passio_manager/blocs/login/authentication_event.dart';
import 'package:passio_manager/blocs/store/store_bloc.dart';
import 'package:passio_manager/blocs/store/store_state.dart';
import 'package:passio_manager/utils/constant.dart';
import 'package:passio_manager/utils/helper.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    final _storeBloc = BlocProvider.of<StoreBloc>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BlocEventStateBuilder<StoreState>(
                bloc: _storeBloc,
                builder: (context, state) {
                  if (!state.isSelected) {
                    return Container();
                  } else {
                    return Text(state.store.name);
                  }
                },
              ),
              FlatButton(
                color: Colors.teal,
                child: Text('Logout'),
                onPressed: () {
                  Helper.removeData(accessTokenKey);
                  Helper.removeData(storeIdKey);
                  _authenticationBloc.emitEvent(AuthenticationEventLogout());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
