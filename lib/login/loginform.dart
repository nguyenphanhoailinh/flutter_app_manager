import 'package:flutter_app_manager/models/signin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_manager/views_app/menu_dish.dart';


class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:8888/api/v1/auth"));

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final response = await dio.post("/signin",
        data: User(username: username, password: password).toJson());
    if (response.statusCode == 200) {
      // Xử lý đăng nhập thành công
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Menu_Dish()));
      print('Đăng nhập thành công');
    } else {
      // Xử lý đăng nhập thất bại
      print('Đăng nhập thất bại');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Column(
      children: [
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(labelText: 'nhập email'),
        ),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: 'nhập Mật khẩu'),
          obscureText: true,
        ),
        ElevatedButton(
          onPressed: _login,
          child: const Text('Đăng nhập'),
        ),
      ],
    ),
    );
  }
}
