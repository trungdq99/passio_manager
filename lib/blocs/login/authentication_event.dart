import '../../models/user_model.dart';

import '../../bloc_helpers/bloc_event_state.dart';

abstract class AuthenticationEvent extends BlocEvent {
  final UserModel user;

  AuthenticationEvent({
    this.user,
  });
}

class AuthenticationEventLogin extends AuthenticationEvent {
  AuthenticationEventLogin({
    UserModel user,
  }) : super(
          user: user,
        );
}

class AuthenticationEventLoadLogin extends AuthenticationEvent {
  AuthenticationEventLoadLogin({
    UserModel user,
  }) : super(
          user: user,
        );
}

class AuthenticationEventLogout extends AuthenticationEvent {}
