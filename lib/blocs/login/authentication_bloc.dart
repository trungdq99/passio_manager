import '../../models/user_model.dart';
import '../../models/user_login_model.dart';
import '../../utils/constant.dart';
import '../../utils/helper.dart';

import '../../repository/repository.dart';

import '../../bloc_helpers/bloc_event_state.dart';
import './authentication_event.dart';
import './authentication_state.dart';
import 'dart:async';
import 'package:http/http.dart' show Response;

class AuthenticationBloc
    extends BlocEventStateBase<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(String accessToken)
      : super(
          initialState: accessToken != null
              ? AuthenticationState.authenticated(accessToken)
              : AuthenticationState.notAuthenticated(),
        );

  @override
  Stream<AuthenticationState> eventHandler(
      AuthenticationEvent event, AuthenticationState currentState) async* {
    if (event is AuthenticationEventLogin) {
      // Inform that we are proceeding with the authentication
      yield AuthenticationState.authenticating();

      // Simulate a call to the authentication server
      await Future.delayed(const Duration(seconds: 2));

      // Inform that we have successfully authenticated, or not
      if (event.accessToken == "failure") {
        yield AuthenticationState.failure();
      } else {
        yield AuthenticationState.authenticated(event.accessToken);
      }
    }

    if (event is AuthenticationEventLogout) {
      yield AuthenticationState.notAuthenticated();
    }
  }

  Future<String> handleLogin(String username, String password) async {
    var user = UserLoginModel(
      username: username,
      password: password,
    );
    Repository repository = Repository();
    Response response = await repository.fetchData(
      checkLoginApi,
      RequestMethod.POST,
      unAuthorizeHeader,
      Helper.encodeJson(user.toMap()),
    );
    String accessToken = 'failure';
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = Helper.decodeJson(response.body);
      if (responseBody != null) {
        var user = UserModel.fromMap(responseBody);
        accessToken = user.accessToken;
        Helper.saveData(accessTokenKey, accessToken, SavingType.String);
        print('Login successful!');
        print('Access Token success: $accessToken');
      }
    } else {
      print('Login failed!');
    }
    return accessToken;
  }

  Future<UserModel> getUser(String accessToken) async {
    Repository repository = Repository();
    Response response = await repository.fetchData(getUserApi,
        RequestMethod.GET, Helper.getAuthorizeHeader(accessToken), null);
    UserModel user;
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = Helper.decodeJson(response.body);
      if (responseBody != null) {
        user = UserModel.fromMap(responseBody);
        user.accessToken = accessToken;
      }
    } else {
      user = null;
    }
    return user;
  }
}
