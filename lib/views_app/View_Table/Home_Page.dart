import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_manager/models/Status.dart';
import 'package:flutter_app_manager/models/dish.dart';
import 'package:flutter_app_manager/views_app/View_Menu/CreateDishPage.dart';
import 'package:flutter_app_manager/views_app/View_Menu/menu_dish.dart';

import '../../models/table.dart';
import '../View_Menu/Edit_Dish.dart';
import 'Order_Dish.dart';
import 'create_Table.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:8888/api/v1"));
  List<TableB> tables = [];
  List<Dish> dishes = [];

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
  Future<void> deleteDish(int iddish) async {
    try {
      final response = await dio.delete("/delete/${iddish}");
      if (response.statusCode == 200) {
        print('Dish deleted successfully');
      } else {
        throw Exception('Failed to delete dish');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to connect to API');
    }
  }

  Future<void> _fetchDishes() async {
    final response = await dio.get("/dishs");
    if (response.statusCode == 200) {
      setState(() {
        dishes = (response.data as List).map((item) => Dish.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load dishes');
    }
  }
  static void updateTableStatus(String tableName, String newStatus) {
  }
  @override
  void initState() {
    super.initState();
    _fetchTables();
    _fetchDishes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang chủ'),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, // Display tables in a single row
                  childAspectRatio: 3, // Adjust aspect ratio for horizontal layout
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
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Display dishes in 3 rows
                ),
                itemCount: dishes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Bạn có thể sửa hoặc xóa món ăn này'),
                            content: Text('Bạn muốn làm gì với món ăn này?'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Sửa'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditDishPage(dish: dishes[index]),
                                    ),
                                  );
                                },
                              ),
                              TextButton(
                                child: Text('Xóa'),
                                onPressed: () {
                                  deleteDish(dishes[index].iddish);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                              child: Image.network(
                                '${dishes[index].imagefilename}',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text('${dishes[index].iddish}'),
                                Text(
                                  dishes[index].namedish,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${dishes[index].price.toStringAsFixed(2)}\k',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}