import 'package:rxdart/rxdart.dart';

import '../../bloc_helpers/bloc_base.dart';

import '../../utils/password_validator.dart';
import '../../utils/username_validator.dart';

class LoginFormBloc extends Object
    with UsernameValidator, PasswordValidator
    implements BlocBase {
  final BehaviorSubject<String> _usernameController = BehaviorSubject<String>();
  final BehaviorSubject<String> _passwordController = BehaviorSubject<String>();

  // Inputs
  Function(String) get onUsernameChanged => _usernameController.sink.add;
  Function(String) get onPasswordChanged => _passwordController.sink.add;

  // Validators
  Stream<String> get username =>
      _usernameController.stream.transform(validateEmail);
  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);

  // Login Button
  Stream<bool> get loginValid =>
      CombineLatestStream.combine2(username, password, (a, b) => true);

  @override
  void dispose() {
    // TODO: implement dispose
    _usernameController?.close();
    _passwordController?.close();
  }
}
