class User {
  String fullname;
  String username;
  String password;
  String role;
  User({required this.username, required this.password, required this.fullname,required this.role});


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      role: json['role'],
      username: json['username'],
      password: json['password'],
      fullname: json['fullname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password, 'fullname': fullname,'role':role};
  }
}