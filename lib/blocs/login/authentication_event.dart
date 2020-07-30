import '../../bloc_helpers/bloc_event_state.dart';

abstract class AuthenticationEvent extends BlocEvent {
  final String accessToken;

  AuthenticationEvent({
    this.accessToken: '',
  });
}

class AuthenticationEventLogin extends AuthenticationEvent {
  AuthenticationEventLogin({
    String accessToken,
  }) : super(
          accessToken: accessToken,
        );
}

class AuthenticationEventLogout extends AuthenticationEvent {}
