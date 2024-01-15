class User {
  String fullname;
  String username;
  String password;

  User({required this.username, required this.password, required this.fullname});


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'],
      fullname: json['fullname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password, 'fullname': fullname};
  }
}