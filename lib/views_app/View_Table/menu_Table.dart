import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_manager/models/Status.dart';
import 'package:flutter_app_manager/models/table.dart';
import 'package:flutter_app_manager/views_app/View_Menu/menu_dish.dart';

import '../views_home/Home_Page.dart';
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
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () =>
              Navigator.pushNamed(context, '/home'),
        ),
        title: const Row(
          children: [
            // Add some space between the home icon and the title
            Text('Bàn'),
          ],
        ),
        backgroundColor: Color.fromRGBO(109, 117, 208, 0.8),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.fastfood),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Menu_Dish()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.view_agenda),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateTableForm()),
              );
            },
          ),
        ],
      ),

      //backgroundColor: const Color.fromARGB(255, 50, 73, 113),
      body: GridView.builder(

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
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

                side: const BorderSide(color:  Color.fromRGBO(109, 117, 208, 0.8), width: 2),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(

                    tables[index].nametable,
                    style: const TextStyle(fontWeight: FontWeight.bold, color:  Color.fromRGBO(109, 117, 208, 0.8)),

                  ),
                  Text(
                    statusToString(tables[index].status),
                    style: const TextStyle(fontWeight: FontWeight.bold, color:  Color.fromRGBO(109, 117, 208, 0.8)),
                  ),
                ],
              ),
            ),

          );
        },
      ),
    );
  }
}
