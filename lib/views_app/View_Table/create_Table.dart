import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_manager/models/Status.dart';
import 'package:flutter_app_manager/models/table.dart';
import 'package:flutter_app_manager/models/tableA.dart';
import 'package:flutter_app_manager/views_app/View_Table/Menu_Table.dart';

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
        data: TableA(nametable: name, status:Status.conTrong).toJson());
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
          backgroundColor: Color.fromRGBO(109, 117, 208, 0.8),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () =>
              Navigator.pushNamed(context, '/menuTable'),
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
            decoration: const InputDecoration(labelText: 'Tên bàn'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color.fromRGBO(109, 117, 208, 0.8),
              onPrimary: Color.fromRGBO(109, 117, 208, 0.8)
            ),
            onPressed: _createTable,

            child: const Text('Tạo bàn',
            style: TextStyle(
              color: Colors.white
            ),),

          ),
        ],
      ),
    );
  }
}
