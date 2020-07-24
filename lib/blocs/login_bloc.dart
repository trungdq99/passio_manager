import 'dart:async';

import '../models/login_model.dart';

import '../models/user_login_model.dart';
import '../repository/repository.dart';
import '../utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './bloc.dart';

class LoginBloc implements Bloc {
  Repository _repository = Repository();

  // Stream Controller
  StreamController _btnLoginController = StreamController.broadcast();
  StreamController _loginController = StreamController.broadcast();

  // Get Stream
  Stream get loginStream => _loginController.stream;
  Stream get btnLoginStream => _btnLoginController.stream;

  void enableBtnLogin(bool isEnable) {
    print('Is enable: $isEnable');
    if (isEnable) {
      _btnLoginController.sink.add('OK');
    } else {
      _btnLoginController.sink.addError('Disable Login');
    }
  }

  Future handleLogin(String username, String password) async {
    var user = UserLoginModel(
      username: username,
      password: password,
    );
    Map<String, dynamic> responseBody = await _repository.fetchData(
      loginApi,
      'post',
      unAuthorizeHeader,
      user.toMap(),
    );
    if (responseBody.isNotEmpty) {
      var login = LoginModel.fromMap(responseBody);
      saveAccessToken(login.accessToken);
      _loginController.sink.add(login);
    }
  }

  saveAccessToken(String accessToken) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(accessTokenKey, accessToken);
  }

  Future<String> loadAccessToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print('load token');
    return (pref.getString(accessTokenKey) ?? '');
  }

  loadLogin() async {
    String accessToken = await loadAccessToken();
    print('Token: $accessToken');
    if (accessToken.isNotEmpty) {
      print('Add login');
      _loginController.sink.add(LoginModel(
          username: 'a', accessToken: 'a', email: 'a', fullname: 'a'));
      print('You are login');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _btnLoginController.close();
    _loginController.close();
  }
}
