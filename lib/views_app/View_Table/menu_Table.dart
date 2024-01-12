import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_manager/models/table.dart';
import 'package:flutter_app_manager/views_app/View_Menu/menu_dish.dart';

import 'Order_Dish.dart';

class Menu_Table extends StatefulWidget {
  @override
  _TableListState createState() => _TableListState();
}

class _TableListState extends State<Menu_Table> {
  Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:8888/api/v1"));
  List<TableB> tables = [];

  @override
  void initState() {
    super.initState();
    _fetchTables();
  }

  Future<void> _fetchTables() async {
    final response = await dio.get("/tables"); // Thay "/tables" bằng đường dẫn API của bạn
    if (response.statusCode == 200) {
      setState(() {
        tables = (response.data as List).map((item) => TableB.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load tables');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AppBar '),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.fastfood),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Menu_Dish()),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Số lượng cột trong GridView
        ),
        itemCount: tables.length,
        itemBuilder: (context, index) {
          return GestureDetector( // Thêm GestureDetector để xử lý sự kiện nhấn
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderDishPage(tableName: tables[index].nametable)),
              );
            },
            child: Card( // Sử dụng Card để tạo từng ô
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(tables[index].nametable),
                  Text(tables[index].status),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
