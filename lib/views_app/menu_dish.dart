import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_manager/models/dish.dart';

class Menu_Dish extends StatefulWidget {
  const Menu_Dish({super.key});

  @override
  _MenuDishState createState() => _MenuDishState();
}

class _MenuDishState extends State<Menu_Dish> {
  List<Dish> dishes = [];
  Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:8888/api/v1/dishs"));

  Future<List<Dish>> fetchDishes() async {
    try {
      final response = await dio.get("/all");

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = response.data;
        if (jsonResponse is List) {
          return jsonResponse.map((item) => Dish.fromJson(item)).toList();
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load dishes from API');
      }
    } catch (error) {
      throw Exception('Failed to connect to API');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDishes().then((dishes) {
      setState(() {
        this.dishes = dishes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dish List'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: dishes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return Card(
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
                        Text(
                          dishes[index].namedish,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Price: \$${dishes[index].price.toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
