import '../../bloc_helpers/bloc_event_state.dart';

abstract class AuthenticationEvent extends BlocEvent {
  AuthenticationEvent({
    this.username,
    this.password,
  });
  String username;
  String password;
}

class AuthenticationEventLogin extends AuthenticationEvent {
  AuthenticationEventLogin({
    String username,
    String password,
  }) : super(
          username: username,
          password: password,
        );
}

class AuthenticationEventLoadLogin extends AuthenticationEvent {}

class AuthenticationEventLogout extends AuthenticationEvent {}
