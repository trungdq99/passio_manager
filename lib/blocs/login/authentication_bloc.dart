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

      if (event.user.accessToken.isEmpty) {
        yield AuthenticationState.notAuthenticated();
      } // Access token is empty => UnAuthorize
      else if (event.user.accessToken == 'failure') {
        yield AuthenticationState.failure();
      } // Login failed!
      else {
        yield AuthenticationState.authenticated(event.user);
      } // Login successful!
    }

    if (event is AuthenticationEventLoadLogin) {
      if (event.user.accessToken.isEmpty) {
        yield AuthenticationState.notAuthenticated();
      } else {
        yield AuthenticationState.authenticated(event.user);
      }
    }

    if (event is AuthenticationEventLogout) {
      yield AuthenticationState.notAuthenticated();
    }
  }

  Future<UserModel> handleLogin(String username, String password) async {
    var login = UserLoginModel(
      username: username,
      password: password,
    );
    Repository repository = Repository();
    Response response = await repository.fetchData(
      CHECK_LOGIN_API,
      RequestMethod.POST,
      UN_AUTHORIZE_HEADER,
      Helper.encodeJson(login.toMap()),
    );
    UserModel user = UserModel();
    user.accessToken = 'failure';
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = Helper.decodeJson(response.body);
      if (responseBody != null) {
        user = UserModel.fromMap(responseBody);
        String accessToken = user.accessToken;
        Helper.saveData(ACCESS_TOKEN_KEY, accessToken, SavingType.String);
        print('Login successful!');
        print('Access Token success: $accessToken');
      }
    } else {
      print('Login failed!');
    }
    return user;
  }

  Future<UserModel> getUser(String accessToken) async {
    Repository repository = Repository();
    Response response = await repository.fetchData(GET_USER_API,
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
        await Helper.loadData(ACCESS_TOKEN_KEY, SavingType.String);
    return getUser(accessToken);
  }
}
