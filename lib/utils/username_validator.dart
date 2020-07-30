import 'dart:async';

class UsernameValidator {
  final StreamTransformer<String, String> validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.isEmpty) {
      sink.addError('Invalid username!');
    } else {
      sink.add(email);
    }
  });
}
