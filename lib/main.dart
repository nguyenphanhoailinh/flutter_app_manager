import 'package:flutter/material.dart';
import 'package:flutter_app_manager/views_app/View_Menu/CreateDishPage.dart';
import 'package:flutter_app_manager/register/registerform.dart';
import 'package:flutter_app_manager/login/loginform.dart';
import 'package:flutter_app_manager/views_app/View_Table/create_Table.dart';
import 'package:flutter_app_manager/views_app/View_Table/menu_Table.dart';
import 'package:flutter_app_manager/views_app/View_Menu/menu_dish.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/menuTable': (context) => Menu_Table(),
      },
      home: Scaffold(
        body: LoginForm() ,
      ),
    );
  }
}
