import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_manager/models/table.dart';
import 'package:flutter_app_manager/views_app/View_Menu/menu_dish.dart';

import 'Order_Dish.dart';
import 'create_Table.dart';

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
    final response = await dio.get("/tables");
    if (response.statusCode == 200) {
      setState(() {
        tables = (response.data as List).map((item) => TableB.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load tables');
    }
  }

  // Phương thức để cập nhật trạng thái của bàn
  static void updateTableStatus(String tableName, String newStatus) {
    // Triển khai logic cập nhật trạng thái của bàn ở đây
    // Ví dụ:
    // Cập nhật trạng thái của bàn có tableName thành newStatus
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bàn'),
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

          IconButton(
            icon: Icon(Icons.view_agenda),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateTableForm()),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: tables.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDishPage(
                    tableName: tables[index].nametable,
                    updateTableStatus: updateTableStatus, // Truyền phương thức cập nhật trạng thái của bàn
                  ),
                ),
              );
            },
            child: Card(
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
