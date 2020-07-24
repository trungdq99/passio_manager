import 'package:flutter/material.dart';
import '../utils/custom_widget.dart';
import '../blocs/bloc_provider.dart';
import '../blocs/login_bloc.dart';
import '../utils/custom_colors.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _txtUsernameController;
  TextEditingController _txtPasswordController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _txtUsernameController = TextEditingController();
    _txtPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LoginBloc>(context);
    bloc.enableBtnLogin(false);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Stack(
            children: [
              CustomWidget.buildImageBackground(context),
              Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          boxShadow: [
                            BoxShadow(
                                color: CustomColors.pale_grey,
                                offset: Offset(0, -1),
                                blurRadius: 0,
                                spreadRadius: 0)
                          ],
                          color: Colors.white),
                      child: TextFormField(
                        controller: _txtUsernameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 20),
                          labelText: 'Email',
                          hintText: 'email@passio.com',
                          hintStyle: TextStyle(
                            color: CustomColors.cool_grey,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onChanged: (_) => bloc.enableBtnLogin(
                            _txtUsernameController.text.isNotEmpty &&
                                _txtPasswordController.text.isNotEmpty),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          boxShadow: [
                            BoxShadow(
                                color: CustomColors.pale_grey,
                                offset: Offset(0, -1),
                                blurRadius: 0,
                                spreadRadius: 0)
                          ],
                          color: Colors.white),
                      child: TextFormField(
                        controller: _txtPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 20),
                          labelText: 'Password',
                          hintText: '••••••••••',
                          hintStyle: TextStyle(
                            color: CustomColors.cool_grey,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        obscureText: true,
                        onChanged: (_) => bloc.enableBtnLogin(
                            _txtUsernameController.text.isNotEmpty &&
                                _txtPasswordController.text.isNotEmpty),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // btnLogin
                    StreamBuilder(
                        stream: bloc.btnLoginStream,
                        builder: (context, snapshot) {
                          return Container(
                            height: 50,
                            width: double.maxFinite,
                            margin: EdgeInsets.symmetric(
                              horizontal: 30,
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              boxShadow: [
                                BoxShadow(
                                    color: const Color(0x3353584e),
                                    offset: Offset(0, 4),
                                    blurRadius: 8,
                                    spreadRadius: 0)
                              ],
                              color: snapshot.hasError
                                  ? CustomColors.cool_grey
                                  : CustomColors.sick_green,
                            ),
                            child: FlatButton(
                              onPressed: () {
                                if (!snapshot.hasError) {
                                  bloc.handleLogin(_txtUsernameController.text,
                                      _txtPasswordController.text);
                                }
                              },
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
                        }),
                    SizedBox(
                      height: 30,
                    ),
                    FlatButton(
                      child: Text(
                        'Quên mật khẩu',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
