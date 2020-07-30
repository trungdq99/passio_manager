import 'package:flutter/material.dart';
import '../blocs/login/authentication_event.dart';
import '../ui/home_screen.dart';
import '../bloc_helpers/bloc_provider.dart';
import '../blocs/login/authentication_bloc.dart';
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
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _applicationInitializationBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    // Load previous login
    _authenticationBloc.loadPreviousLogin();
    return Scaffold(
      body: StreamBuilder<String>(
          stream: _authenticationBloc.loadStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _authenticationBloc.emitEvent(
                  AuthenticationEventLogin(accessToken: snapshot.data));
            } // When load available access token successful, add authentication
            return Container(
              child: BlocEventStateBuilder<ApplicationInitializationState>(
                bloc: _applicationInitializationBloc,
                builder: (context, state) {
                  // When app is loaded successful, navigate to HomeScreen
                  if (state.isInitialized) {
                    return HomeScreen();
                  }
                  // Build children widget for Stack Widget
                  List<Widget> _children = [];
                  _children.add(CustomWidget.buildImageBackground(context));
                  _children.add(_buildLogo());
                  // while loading app, show processing animation
                  if (state.isInitializing) {
                    _children.add(CustomWidget.buildProcessing(context));
                  }
                  return Stack(
                    children: _children,
                  );
                },
              ),
            );
          }),
    );
  }

  // Build logo with animation
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
