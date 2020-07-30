import 'package:flutter/material.dart';
import '../blocs/login/authentication_event.dart';
import '../blocs/login/authentication_state.dart';
import '../ui/home_screen.dart';
import '../bloc_helpers/bloc_provider.dart';
import '../blocs/login/authentication_bloc.dart';
import '../utils/helper.dart';
import '../bloc_widgets/bloc_state_builder.dart';
import '../blocs/application_initialization/application_initialization_state.dart';
import '../blocs/application_initialization/application_initialization_bloc.dart';
import '../blocs/application_initialization/application_initialization_event.dart';
import '../utils/constant.dart';
import '../utils/custom_widget.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _logoAnimation;

  ApplicationInitializationBloc _applicationInitializationBloc;
  AuthenticationBloc _authenticationBloc;
  double _logoSize = 250;
  bool error;
  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    _logoAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInCirc));
    _animationController.forward();

    _applicationInitializationBloc = ApplicationInitializationBloc();
    _applicationInitializationBloc.emitEvent(ApplicationInitializationEvent());
    _authenticationBloc = null;
    error = false;
    _checkIsLogin();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _applicationInitializationBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocEventStateBuilder<ApplicationInitializationState>(
      bloc: _applicationInitializationBloc,
      builder: (context, state) {
        if (state.isInitialized && _authenticationBloc != null) {
          return BlocProvider<AuthenticationBloc>(
            bloc: _authenticationBloc,
            child: BlocEventStateBuilder<AuthenticationState>(
              bloc: _authenticationBloc,
              builder: (context, state) {
                if (state.hasFailed && error) {
                  return CustomWidget.buildErrorMessage(
                    context,
                    'Something when wrong!',
                    () {
                      _authenticationBloc
                          .emitEvent(AuthenticationEventLogout());
                      error = false;
                    },
                  );
                } else if (state.isAuthenticating && error) {
                  return Container();
                } else {
                  return HomeScreen();
                }
              },
            ),
          );
        }

        List<Widget> _children = [];
        _children.add(CustomWidget.buildImageBackground(context));
        _children.add(_buildLogo());
        if (state.isInitializing) {
          _children.add(CustomWidget.buildProcessing(context));
        }
        return Scaffold(
          body: Stack(
            children: _children,
          ),
        );
      },
    );
  }

  _checkIsLogin() async {
    String accessToken =
        await Helper.loadData(accessTokenKey, SavingType.String);
    print('AccessToken: $accessToken');
    _authenticationBloc = AuthenticationBloc(null);
    var user = await _authenticationBloc.getUser(accessToken);
//    var user = await _authenticationBloc.getUser(
//        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJjN2JhMDkzMS1jMWRjLTQ2ZGUtYmE0My01NTIxN2VhZGMyMmUiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiZGVtbyIsImV4cCI6MTU5NTcyODU3NCwiaXNzIjoiVGhpcyBpcyBJc3Nlci4iLCJhdWQiOiJUaGlzIGlzIElzc2VyLiJ9.o6OE4vQZr5vlSJXuUu-Okeyw9mzM9ceuYR2L4uuu9jk');
    if (user == null) {
      if (accessToken != null) {
        error = true;
        _authenticationBloc
            .emitEvent(AuthenticationEventLogin(accessToken: "failure"));
      }
    } else {
      _authenticationBloc
          .emitEvent(AuthenticationEventLogin(accessToken: accessToken));
    }
  }

  Widget _buildLogo() {
    return FadeTransition(
      opacity: _logoAnimation,
      child: Center(
        child: SizedBox(
          height: _logoSize,
          child: Image.asset(logoImagePath),
        ),
      ),
    );
  }
}
