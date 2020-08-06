import '../../models/user_model.dart';

import '../../bloc_helpers/bloc_event_state.dart';
import 'package:meta/meta.dart';

class AuthenticationState extends BlocState {
  AuthenticationState({
    @required this.isAuthenticated,
    this.isAuthenticating: false,
    this.hasFailed: false,
    this.user,
  });

  final bool isAuthenticated;
  final bool isAuthenticating;
  final bool hasFailed;

  final UserModel user;

  factory AuthenticationState.notAuthenticated() {
    return AuthenticationState(
      isAuthenticated: false,
    );
  }

  factory AuthenticationState.authenticated(UserModel user) {
    return AuthenticationState(
      isAuthenticated: true,
      user: user,
    );
  }

  factory AuthenticationState.authenticating() {
    return AuthenticationState(
      isAuthenticated: false,
      isAuthenticating: true,
    );
  }

  factory AuthenticationState.failure() {
    return AuthenticationState(
      isAuthenticated: false,
      hasFailed: true,
    );
  }
}
