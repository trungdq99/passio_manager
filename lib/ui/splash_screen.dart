import 'package:flutter/material.dart';
import 'package:passio_manager/blocs/store/store_bloc.dart';
import 'package:passio_manager/blocs/store/store_event.dart';
import 'package:passio_manager/models/store_model.dart';
import 'package:passio_manager/models/user_model.dart';
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
  StoreBloc _storeBloc;
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
    _storeBloc = BlocProvider.of<StoreBloc>(context);
    // Load previous login
    _loadPreviousLogin();
    return Scaffold(
      body: Container(
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
            return Stack(
              children: _children,
            );
          },
        ),
      ),
    );
  }

  _loadPreviousLogin() async {
    UserModel user = await _authenticationBloc.loadPreviousLogin();
    String accessToken = user.accessToken;
    if (user.accessToken.isNotEmpty) {
      _loadPreviousStore(accessToken);
    }
    _authenticationBloc
        .emitEvent(AuthenticationEventLoadLogin(accessToken: accessToken));
  }

  _loadPreviousStore(String accessToken) async {
    StoreModel store = await _storeBloc.loadPreviousStore(accessToken);
    if (store != null) {
      if (store.id >= -1) {
        _storeBloc.emitEvent(
          StoreEventSelected(
            store: store,
          ),
        );
        print('Selected');
      }
    }
    print('If you are here => not selected');
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
