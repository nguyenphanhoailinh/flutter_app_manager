import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app_manager/models/Status.dart';
import 'package:flutter_app_manager/models/dish.dart';
import 'package:flutter_app_manager/views_app/View_Menu/CreateDishPage.dart';
import 'package:flutter_app_manager/views_app/View_Menu/menu_dish.dart';
import 'package:flutter_app_manager/views_app/View_Table/Menu_Table.dart';

import '../../models/table.dart';
import '../View_Menu/Edit_Dish.dart';
import '../View_Table/Order_Dish.dart';
import '../View_Table/create_Table.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:8888/api/v1"));
  List<TableB> tables = [];
  List<Dish> dishes = [];
  final ScrollController _scrollController = ScrollController();

  Future<void> _fetchTables() async {
    final response = await dio.get("/tables/all");
    if (response.statusCode == 200) {
      setState(() {
        tables = (response.data as List).map((item) => TableB.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load tables');
    }
  }

  Future<void> _fetchDishes() async {
    final response = await dio.get("/dishs/all");
    if (response.statusCode == 200) {
      setState(() {
        dishes = (response.data as List).map((item) => Dish.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load dishes');
    }
  }
  String statusToString(Status status) {
    return status.toString().split('.').last;
  }
  static void updateTableStatus(String tableName, String newStatus) {}

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
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                // Navigator.pushNamed(context, '/home');
              },
            ),
            const SizedBox(width: 8), // Add some space between the home icon and the title
            const Text('Trang chủ'),
          ],
        ),
        backgroundColor: Color.fromRGBO(109, 117, 208, 0.8),
        actions: <Widget>[
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: Text("Món ăn"),
              ),
              const PopupMenuItem(
                value: 2,
                child: Text("Bàn"),
              ),
              const PopupMenuItem(
                value: 3,
                child: Text("Danh sách Bàn đã thanh toán"),
              ),
            ],
            onSelected: (value) {
              if (value == 1) {
                Navigator.pushNamed(context, '/menudish');
              } else if (value == 2) {
                Navigator.pushNamed(context, '/menuTable');
              }
              else if(value == 3){
                Navigator.pushNamed(context, '/bill');
              }
            },
          ),
        ],
      ),

      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 20.0), // Add padding at the left, top and bottom
            child: Text(
              'Bàn',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(109, 117, 208, 0.8),
              ),
            ),
          ),

          _buildTableList(),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Món Ăn',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(109, 117, 208, 0.8),
              ),
            ),
          ),

          _buildDishGrid(),
        ],
      ),
    );
  }

  Widget _buildTableList() {
    return Container(
      height: 150,

      child: Scrollbar(
        thumbVisibility: true,
        controller: _scrollController,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          itemCount: tables.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                print(index);
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
              child: Container(
                width: 250, // Set the width of the Card
                child: Card(

                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Color.fromRGBO(109, 117, 208, 0.8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(30.0), // Increase the border radius
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          tables[index].nametable,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(109, 117, 208, 0.8),
                          ),
                        ),
                        Text(
                          statusToString(tables[index].status),
                          style: const TextStyle(fontWeight: FontWeight.bold, color:  Color.fromRGBO(109, 117, 208, 0.8)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }



  Widget _buildDishGrid() {
    return Expanded(
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: dishes.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: const BorderSide(
                  color: Color.fromRGBO(109, 117, 208, 0.8),
                  width: 2.0,
                ),
              ),
              elevation: 5.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
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
                        Text(
                          dishes[index].namedish,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(109, 117, 208, 0.8),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${dishes[index].price.toStringAsFixed(2)}\k',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
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
    );
  }
}
