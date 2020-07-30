class UserModel {
  String userName;
  String fullName;
  String email;
  String accessToken;
  UserModel({this.userName, this.fullName, this.email, this.accessToken});
  UserModel.fromMap(Map<String, dynamic> map) {
    this.userName = map['user_name'];
    this.fullName = map['full_name'];
    this.email = map['email'];
    this.accessToken = map['access_token'];
  }
}
