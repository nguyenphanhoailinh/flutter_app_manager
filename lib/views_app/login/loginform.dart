import 'dart:convert';

import 'package:flutter_app_manager/models/signin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_manager/views_app/register/registerform.dart';
import 'package:flutter_app_manager/views_app/View_Table/menu_Table.dart';
import 'package:flutter_app_manager/views_app/View_Menu/menu_dish.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}
class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:8889/api/v1/auth"));

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    if (username.trim().isEmpty || password.trim().isEmpty) {
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
      print(response.data);

      if (response.statusCode == 200) {
        // final user = User.fromJson(jsonDecode(response.data) ?? {});
        // final jwt = response.data['token']?.toString() ?? '';
        // final String role = response.data['role']?.toString() ?? '';
        if (username == 'admin001' && password =='123456') {
          Navigator.pushNamed(context, '/ingredients');
        } else if (username == 'user001' && password =='123456') {
          Navigator.pushNamed(context, '/home');
        }

      }
    } catch (e) {
      print('err:$e');
      if (e is DioError) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
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
     // backgroundColor: Color.fromARGB(255, 50, 73, 113),

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
                    color: Color.fromRGBO(109, 117, 208, 0.8),

                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                      labelStyle: TextStyle(
                          color: Color.fromRGBO(109, 117, 208, 0.8)
                      ),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email)
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Color.fromRGBO(109, 117, 208, 0.8)
                    ),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Color.fromRGBO(109, 117, 208, 0.8)// full width
                  ),
                  child: const Text('Đăng nhập',
                    style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  ),

                ),
                const SizedBox(height: 10),
                TextButton(
                  child: const Text(
                    "Bạn chưa có tài khoản? Đăng Ký",
                    style: TextStyle(
                      color:  Color.fromRGBO(109, 117, 208, 0.8),
                      fontWeight: FontWeight.bold,
                    ),
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

