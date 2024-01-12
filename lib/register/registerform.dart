import 'package:flutter_app_manager/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_manager/login/loginform.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState  ();
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

    // Kiểm tra xem người dùng có nhập tất cả các trường hay không
    if (username.trim().isEmpty || password.trim().isEmpty || fullname.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập tất cả các trường'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
// Kiểm tra xem chuỗi nhập vào có phải là email hợp lệ hay không
    RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!regex.hasMatch(username)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập email hợp lệ'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Kiểm tra xem email đã được tạo tài khoản hay chưa
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
      // Email chưa được tạo tài khoản, tiếp tục đăng ký
    }

    final response = await dio.post("/signup",
        data: User(username: username, password: password, fullname: fullname).toJson());
    if (response.statusCode == 200) {
      // Xử lý đăng ký thành công
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
      backgroundColor: Color.fromARGB(255, 50, 73, 113),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 50),
            Center(
              child: const Text(
                'Đăng ký',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 50),
            TextField(
              controller: _fullnameController,
              decoration: InputDecoration(
                labelText: 'Họ và tên',
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Email đăng nhập',
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Đăng ký',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
              ),
              style: ElevatedButton.styleFrom(
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(20),
                minimumSize: const Size(double.infinity, 50),
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),

              ),

            ),
            const SizedBox(height: 10),
            TextButton(
              child: const Text(
                "Bạn đã có tài khoản? Đăng nhập",
                style: TextStyle(
                  color: Colors.blue,
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
