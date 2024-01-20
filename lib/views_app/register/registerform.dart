import 'package:flutter_app_manager/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_manager/views_app/login/loginform.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState  ();
}


class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:8889/api/v1/auth"));

  Future<void> _register() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String fullname = _fullnameController.text;

    if (username.trim().isEmpty || password.trim().isEmpty || fullname.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập tất cả các trường'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      final response = await dio.post("/signin",
          data: User(username: username, password: 'dummy_password', fullname: fullname).toJson());
      if (response.statusCode == 200 || response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email đã được tạo tài khoản'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } catch (e) {
    }

    final response = await dio.post("/signup",
        data: User(username: username, password: password, fullname: fullname).toJson());
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng ký thành công'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Xử lý đăng ký thất bại
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng ký thất bại'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //  backgroundColor: Color.fromARGB(255, 50, 73, 113),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 50),
            const Center(
              child: Text(
                'Đăng ký',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(109, 117, 208, 0.8)
                ),
              ),
            ),
            const SizedBox(height: 50),
            TextField(
              controller: _fullnameController,
              decoration: const InputDecoration(
                labelText: 'Họ và tên',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(109, 117, 208, 0.8),
                minimumSize: const Size(double.infinity, 50),
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),

              ),
              child: const Text('Đăng ký',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              ),

            ),
            const SizedBox(height: 10),
            TextButton(
              child: const Text(
                "Bạn đã có tài khoản? Đăng nhập",
                style: TextStyle(
                  color: Color.fromRGBO(109, 117, 208, 0.8),
                  fontWeight: FontWeight.bold,
                ),
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
      ),
    );
  }
}
