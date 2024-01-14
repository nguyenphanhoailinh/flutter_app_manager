import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_manager/models/table.dart';

import '../View_Menu/menu_dish.dart';

class CreateTableForm extends StatefulWidget {
  @override
  _CreateTableFormState createState() => _CreateTableFormState();
}

class _CreateTableFormState extends State<CreateTableForm> {
  final TextEditingController _nameController = TextEditingController();
  Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:8888/api/v1/tables"));

  Future<void> _createTable() async {
    final String name = _nameController.text;

    final response = await dio.post("/create",
        data: TableB(nametable: name, status: "CÒN_TRỐNG").toJson());
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tạo bảng thành công'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tạo bảng thất bại'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo bàn'),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
      body: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Tên bảng'),
          ),
          ElevatedButton(
            onPressed: _createTable,
            child: const Text('Tạo bảng'),
          ),
        ],
      ),
    );
  }
}
