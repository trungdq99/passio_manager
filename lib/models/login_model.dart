class LoginModel {
  String username;
  String fullname;
  String email;
  String accessToken;
  LoginModel({this.username, this.fullname, this.email, this.accessToken});
  LoginModel.fromMap(Map<String, dynamic> map) {
    this.username = map['username'];
    this.fullname = map['fullname'];
    this.email = map['email'];
    this.accessToken = map['access_token'];
  }
}
