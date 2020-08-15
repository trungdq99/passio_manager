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
      UserModel userModel;
      userModel = await handleLogin(event.username, event.password);
      await Future.delayed(const Duration(milliseconds: 1000));
      if (userModel != null) {
        if (userModel.accessToken == 'failure') {
          yield AuthenticationState.failure();
        } // Login failed!
        else {
          Helper.saveData(
              ACCESS_TOKEN_KEY, userModel.accessToken, SavingType.String);
          yield AuthenticationState.authenticated(userModel: userModel);
        } // Login successful!
      }
    } // Finish Event Login
    else if (event is AuthenticationEventLoadLogin) {
      yield AuthenticationState.authenticating();
      UserModel userModel;
      userModel = await loadPreviousLogin();
      if (userModel != null) {
        if (userModel.accessToken.isEmpty) {
          yield AuthenticationState.notAuthenticated();
          print('Load failed!');
        } else {
          yield AuthenticationState.authenticated(userModel: userModel);
          print('Load successful!');
        }
      }
    } // Finish Event Load login
    else if (event is AuthenticationEventLogout) {
      Helper.removeData(ACCESS_TOKEN_KEY);
      Helper.removeData(STORE_ID_KEY);
      yield AuthenticationState.notAuthenticated();
    } // Finish Event Logout
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
    UserModel user = UserModel(accessToken: 'failure');
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = Helper.decodeJson(response.body);
      if (responseBody != null) {
        user = UserModel.fromMap(responseBody);
        String accessToken = user.accessToken;
        print('Access Token success: $accessToken');
      }
    } else {}
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
    if (accessToken == null) {
      return UserModel();
    } else {
      return getUser(accessToken);
    }
  }
}
