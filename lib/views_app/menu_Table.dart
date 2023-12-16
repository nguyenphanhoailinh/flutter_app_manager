import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_manager/models/table.dart';

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
      body: ListView.builder(
        itemCount: tables.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tables[index].nametable),
            subtitle: Text(tables[index].status),
          );
        },
      ),
    );
  }
}
