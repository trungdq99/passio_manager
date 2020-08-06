import 'package:flutter/material.dart';
import '../bloc_widgets/bloc_state_builder.dart';
import '../blocs/login/authentication_state.dart';
import '../bloc_helpers/bloc_provider.dart';
import '../blocs/login/authentication_bloc.dart';
import '../blocs/login/authentication_event.dart';
import '../blocs/store/store_bloc.dart';
import '../blocs/store/store_event.dart';
import '../models/store_model.dart';
import '../models/user_model.dart';
import '../utils/constant.dart';
import '../utils/custom_colors.dart';
import '../utils/custom_widget.dart';
import '../utils/helper.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthenticationBloc _authenticationBloc;
  StoreBloc _storeBloc;
  double _deviceWidth;
  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _storeBloc = BlocProvider.of<StoreBloc>(context);
    return Scaffold(
      backgroundColor: CustomColors.background,
      body: Column(
        children: [
          Stack(
            children: [
              CustomWidget.buildBackgroundCover(context),
              BlocEventStateBuilder<AuthenticationState>(
                  bloc: _authenticationBloc,
                  builder: (context, state) {
                    if (state.isAuthenticated) {
                      return _buildProfile();
                    } else {
                      return Container();
                    }
                  }),
            ],
          ),
          _buildSupportInfo(),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    UserModel user = _authenticationBloc.lastState.user;
    return Container(
      height: _deviceWidth / 2,
      width: _deviceWidth,
      alignment: Alignment.center,
      child: ListTile(
        title: Text(
          'Xin chào, ${user.userName}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          user.email,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(
            AVATAR_IMAGE_PATH,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 24),
      ),
    );
  }

  Widget _buildSupportInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              'Vui lòng gọi đến Hotline hoặc gửi mail cho chúng tôi để được hỗ trợ kĩ thuật 24/7.',
              style: TextStyle(
                fontSize: 14,
                color: CustomColors.dark_sage,
              ),
            ),
          ),
          ListTile(
            title: Text(
              '1900 1234',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            leading: Icon(
              Icons.call,
              size: 24,
              color: CustomColors.cool_grey,
            ),
            trailing: Icon(
              Icons.chevron_right,
              size: 24,
              color: CustomColors.cool_grey,
            ),
            contentPadding: EdgeInsets.all(0),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'support@gmail.com',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            leading: Icon(
              Icons.mail,
              size: 24,
              color: CustomColors.cool_grey,
            ),
            trailing: Icon(
              Icons.chevron_right,
              size: 24,
              color: CustomColors.cool_grey,
            ),
            contentPadding: EdgeInsets.all(0),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return FlatButton(
      onPressed: () {
        Helper.removeData(ACCESS_TOKEN_KEY);
        Helper.removeData(STORE_ID_KEY);
        _authenticationBloc.emitEvent(AuthenticationEventLogout());
        _storeBloc.emitEvent(StoreEventSelecting(
          store: StoreModel(
            id: -1,
          ),
        ));
      },
      child: Text(
        'Đăng xuất',
        style: TextStyle(
          color: CustomColors.pastel_red,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
