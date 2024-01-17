import 'package:flutter/material.dart';
import 'package:flutter_app_manager/views_app/View_Menu/CreateDishPage.dart';
import 'package:flutter_app_manager/views_app/View_Table/create_Table.dart';
import 'package:flutter_app_manager/views_app/View_Table/menu_Table.dart';
import 'package:flutter_app_manager/views_app/View_Menu/menu_dish.dart';
import 'package:flutter_app_manager/views_app/login/loginform.dart';
import 'package:flutter_app_manager/views_app/view_Bill/billpage.dart';
import 'package:flutter_app_manager/views_app/views_home/Home_Page.dart';

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
        '/menudish':(context) => Menu_Dish(),
        '/home':(context) => HomePage(),
        '/login':(context) => LoginForm(),
        '/bill':(context) => BillPage(),
      },
      home: Scaffold(
        body: HomePage(),
      ),
    );
  }
}
