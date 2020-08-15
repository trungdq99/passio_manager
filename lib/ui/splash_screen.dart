import 'package:flutter/material.dart';
import 'package:passio_manager/blocs/login/authentication_state.dart';
import '../blocs/filter/filter_bloc.dart';
import 'package:passio_manager/blocs/overview/overview_bloc.dart';
import '../blocs/store/store_bloc.dart';
import '../blocs/store/store_event.dart';
import '../models/store_model.dart';
import '../models/user_model.dart';
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
    _applicationInitializationBloc.emitEvent(ApplicationInitializationEvent(
        applicationInitializationEventType:
            ApplicationInitializationEventType.initialized));
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
    _authenticationBloc.emitEvent(AuthenticationEventLoadLogin());
    return BlocEventStateBuilder<ApplicationInitializationState>(
      bloc: _applicationInitializationBloc,
      builder: (context, applicationInitializationState) {
        if (applicationInitializationState.isInitialized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/authentication');
          });
        }
        // Build children widget for Stack Widget
        List<Widget> _children = [];
        _children.add(CustomWidget.buildImageBackground(context));
        _children.add(_buildLogoTransition());
        return Scaffold(
          body: Stack(
            children: _children,
          ),
        );
      },
    );
  }

  // Build logo with animation
  Widget _buildLogoTransition() {
    return FadeTransition(
      opacity: _logoAnimation,
      child: Center(
        child: SizedBox(
          height: _logoSize,
          child: Image.asset(LOGO_IMAGE_PATH),
        ),
      ),
    );
  }
}
