import '../../bloc_helpers/bloc_event_state.dart';
import 'package:meta/meta.dart';

class AuthenticationState extends BlocState {
  AuthenticationState({
    @required this.isAuthenticated,
    this.isAuthenticating: false,
    this.hasFailed: false,
    this.accessToken: '',
  });

  final bool isAuthenticated;
  final bool isAuthenticating;
  final bool hasFailed;

  final String accessToken;

  factory AuthenticationState.notAuthenticated() {
    return AuthenticationState(
      isAuthenticated: false,
    );
  }

  factory AuthenticationState.authenticated(String accessToken) {
    return AuthenticationState(
      isAuthenticated: true,
      accessToken: accessToken,
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
