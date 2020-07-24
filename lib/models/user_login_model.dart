class UserLoginModel {
  String username;
  String password;
  UserLoginModel({this.username, this.password});
  Map<String, dynamic> toMap() => {
        'username': this.username,
        'password': this.password,
      };
}
