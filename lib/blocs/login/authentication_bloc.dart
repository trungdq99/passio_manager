import 'package:rxdart/rxdart.dart';

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
  AuthenticationBloc()
      : super(
          initialState: AuthenticationState.notAuthenticated(),
        );

  @override
  Stream<AuthenticationState> eventHandler(
      AuthenticationEvent event, AuthenticationState currentState) async* {
    if (event is AuthenticationEventLogin) {
      yield AuthenticationState.authenticating();

      await Future.delayed(const Duration(seconds: 2));

      if (event.accessToken.isEmpty) {
        yield AuthenticationState.notAuthenticated();
      } // Access token is empty => UnAuthorize
      else if (event.accessToken == "failure") {
        yield AuthenticationState.failure();
      } // Login failed!
      else {
        yield AuthenticationState.authenticated(event.accessToken);
      } // Login successful!
    }

    if (event is AuthenticationEventLoadLogin) {
      if (event.accessToken.isEmpty) {
        yield AuthenticationState.notAuthenticated();
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
    UserModel user = UserModel();
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = Helper.decodeJson(response.body);
      if (responseBody != null) {
        user = UserModel.fromMap(responseBody);
        user.accessToken = accessToken;
      }
    }
    return user;
  }

  Future<UserModel> loadPreviousLogin() async {
    String accessToken =
        await Helper.loadData(accessTokenKey, SavingType.String);
    return getUser(accessToken);
  }
}
