import 'package:flutter_app_manager/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_manager/login/loginform.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}


class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:8888/api/v1/auth"));

  Future<void> _register() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String fullname = _fullnameController.text;

    final response = await dio.post("/signup",
        data: User(username: username, password: password, fullname: fullname).toJson());
    if (response.statusCode == 200) {
      // Xử lý đăng ký thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const  SnackBar(
          content: Text('Đăng ký thành công'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng ký thất bại'),
          backgroundColor: Colors.green,
        ),
      );// Xử lý đăng ký thất bại
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: _fullnameController,
            decoration: const InputDecoration(labelText: 'Họ và tên'),
          ),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'email đăng nhập'),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Mật khẩu'),
            obscureText: true,
          ),

          ElevatedButton(
            onPressed: _register,
            child: const Text('Đăng ký'),
          ),
          TextButton(
            child: const Text(
              "bạn đã có tài khoản? Đăng nhập",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginForm()),
              );
            },
          ),
        ],
      ),
    );
  }

}
