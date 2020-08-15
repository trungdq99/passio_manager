import 'package:flutter/material.dart';
import '../blocs/login/authentication_event.dart';
import '../bloc_helpers/bloc_provider.dart';
import '../bloc_widgets/bloc_state_builder.dart';
import '../blocs/login/authentication_bloc.dart';
import '../blocs/login/authentication_state.dart';
import '../blocs/login/login_form_bloc.dart';
import '../utils/custom_widget.dart';
import '../utils/custom_colors.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _txtUsernameController;
  TextEditingController _txtPasswordController;
  LoginFormBloc _loginFormBloc;
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _txtUsernameController = TextEditingController();
    _txtPasswordController = TextEditingController();
    _loginFormBloc = LoginFormBloc();
  }

  @override
  void dispose() {
    _txtUsernameController?.dispose();
    _txtPasswordController?.dispose();
    _loginFormBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: BlocEventStateBuilder<AuthenticationState>(
          bloc: _authenticationBloc,
          builder: (context, state) {
            List<Widget> _children = [];
            _children.add(CustomWidget.buildImageBackground(context));
            _children.add(_buildForm(state.hasFailed));
            if (state.isAuthenticating) {
              _children.add(CustomWidget.buildProcessing(context));
            }
            if (state.isAuthenticated) {
              return Container();
            } else {
              return SingleChildScrollView(
                child: Stack(
                  children: _children,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildForm(bool isLoginFailed) {
    return Container(
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTxtUsername(),
          SizedBox(
            height: 10,
          ),
          _buildTxtPassword(),
          isLoginFailed
              ? _buildLbFailed()
              : SizedBox(
                  height: 30,
                ),
          // btnLogin
          _buildBtnLogin(),
          SizedBox(
            height: 30,
          ),
          _buildBtnForgetPassword(),
        ],
      ),
    );
  }

  // TextField for input username
  Widget _buildTxtUsername() {
    return StreamBuilder<String>(
      stream: _loginFormBloc.username,
      builder: (context, snapshot) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          height: 70,
          alignment: Alignment.center,
          decoration: _textFieldDecoration,
          child: TextFormField(
            controller: _txtUsernameController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 20),
              labelText: 'Email',
              hintText: 'email@passio.com',
              hintStyle: _textFieldHintStyle,
            ),
            onChanged: _loginFormBloc.onUsernameChanged,
          ),
        );
      },
    );
  }

  // TextField for input password
  Widget _buildTxtPassword() {
    return StreamBuilder<String>(
      stream: _loginFormBloc.password,
      builder: (context, snapshot) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          height: 70,
          alignment: Alignment.center,
          decoration: _textFieldDecoration,
          child: TextFormField(
            controller: _txtPasswordController,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 20),
              labelText: 'Password',
              hintText: '••••••••••',
              hintStyle: _textFieldHintStyle,
            ),
            obscureText: true,
            onChanged: _loginFormBloc.onPasswordChanged,
          ),
        );
      },
    );
  }

  // Label for showing failed status
  Widget _buildLbFailed() {
    return Container(
      height: 30,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        'Sai Email hoặc Password',
        style: TextStyle(
          color: Colors.red,
          fontSize: 14,
        ),
      ),
    );
  }

  // Button Login
  Widget _buildBtnLogin() {
    return StreamBuilder(
        stream: _loginFormBloc.loginValid,
        builder: (context, snapshot) {
          bool isValid = (snapshot.hasData && snapshot.data == true);
          return Container(
            height: 50,
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(
              horizontal: 30,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              boxShadow: [
                BoxShadow(
                    color: const Color(0x3353584e),
                    offset: Offset(0, 4),
                    blurRadius: 8,
                    spreadRadius: 0)
              ],
              color: isValid ? CustomColors.sick_green : CustomColors.cool_grey,
            ),
            child: FlatButton(
              onPressed: isValid
                  ? () async {
                      FocusScope.of(context).unfocus();
                      _authenticationBloc.emitEvent(
                        AuthenticationEventLogin(
                          username: _txtUsernameController.text,
                          password: _txtPasswordController.text,
                        ),
                      );
                    }
                  : null,
              child: Text(
                'Đăng nhập',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 14.0,
                ),
              ),
            ),
          );
        });
  }

  // Button Forget Password
  Widget _buildBtnForgetPassword() {
    return FlatButton(
      child: Text(
        'Quên mật khẩu',
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w800,
        ),
      ),
      onPressed: () {},
    );
  }

  // BoxDecoration for 2 TextFields
  BoxDecoration _textFieldDecoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      boxShadow: [
        BoxShadow(
            color: CustomColors.pale_grey,
            offset: Offset(0, -1),
            blurRadius: 0,
            spreadRadius: 0)
      ],
      color: Colors.white);
  // TextStyle for hintStyle of textField
  TextStyle _textFieldHintStyle = TextStyle(
    color: CustomColors.cool_grey,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
  );
}
