import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_manager/models/table.dart';

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
