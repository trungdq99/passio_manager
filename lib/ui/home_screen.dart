import 'package:flutter/material.dart';
import './login_screen.dart';
import '../blocs/bloc_provider.dart';
import '../blocs/login_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LoginBloc>(context);
    bloc.loadLogin();
    return StreamBuilder(
      stream: bloc.loginStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: Container(
              color: Colors.teal,
            ),
          );
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
