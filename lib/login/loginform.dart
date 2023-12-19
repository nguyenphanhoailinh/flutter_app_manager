import 'package:flutter_app_manager/models/signin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_manager/register/registerform.dart';
import 'package:flutter_app_manager/views_app/menu_Table.dart';
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

    // Kiểm tra xem người dùng có nhập tất cả các trường hay không
    if (username
        .trim()
        .isEmpty || password
        .trim()
        .isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bạn chưa nhập các trường'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await dio.post("/signin",
          data: User(username: username, password: password).toJson());
      if (response.statusCode == 200) {
        // Xử lý đăng nhập thành công
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Menu_Table()));
      }
    } catch (e) {
      if (e is DioError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vui lòng kiểm tra lại email hoặc mật khẩu của bạn'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Đăng nhập',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Nhập email',
                    border: OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Nhập mật khẩu',
                    border: OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Đăng nhập'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50), // full width
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  child: const Text(
                    "Bạn chưa có tài khoản? Đăng ký",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 50), // full width
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterForm()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

