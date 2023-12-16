class User {
  String fullname;
  String username;
  String password;
  User({required this.username, required this.password ,required this.fullname});

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password ,'fullname':fullname};
  }

}