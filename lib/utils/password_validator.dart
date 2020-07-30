import 'dart:async';

class PasswordValidator {
  final StreamTransformer<String, String> validatePassword =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (password, sink) {
    if (password.isEmpty) {
      sink.addError('Invalid password!');
    } else {
      sink.add(password);
    }
  });
}
