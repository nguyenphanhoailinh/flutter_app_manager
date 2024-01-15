import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_manager/models/Status.dart';
import 'package:flutter_app_manager/models/table.dart';
import 'package:flutter_app_manager/views_app/View_Menu/menu_dish.dart';

import 'Order_Dish.dart';
import 'create_Table.dart';

class Menu_Table extends StatefulWidget {
  @override
  _TableListState createState() => _TableListState();
}

class _TableListState extends State<Menu_Table> {
  Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:8888/api/v1/tables"));
  List<TableB> tables = [];

  Future<void> _fetchTables() async {
    final response = await dio.get("/all");
    if (response.statusCode == 200) {
      setState(() {
        tables = (response.data as List).map((item) => TableB.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load tables');
    }
  }

  static void updateTableStatus(String tableName, String newStatus) {
  }
  String statusToString(Status status) {
    return status.toString().split('.').last;
  }
  @override
  void initState() {
    super.initState();
    _fetchTables();
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
      backgroundColor: const Color.fromARGB(255, 50, 73, 113),
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
                    idtable: tables[index].idtable,
                    updateTableStatus: updateTableStatus,
                  ),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Color.fromARGB(255, 50, 73, 113), width: 2),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    tables[index].nametable,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // Text(
                  //   statusToString(tables[index].status),
                  //   style: TextStyle(fontWeight: FontWeight.bold),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
