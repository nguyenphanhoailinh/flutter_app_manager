import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_manager/models/dish.dart';
import 'package:flutter_app_manager/views_app/View_Menu/CreateDishPage.dart';
import 'Edit_Dish.dart';

class Menu_Dish extends StatefulWidget {

  const Menu_Dish({super.key});

  @override
  _MenuDishState createState() => _MenuDishState();
}

class _MenuDishState extends State<Menu_Dish> {
  List<Dish> dishes = [];
  late final Dish dish;
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
      print('Error: $error');
      throw Exception('Failed to connect to API');
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
        title: Text('Danh sách món ăn '),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
        backgroundColor: Color.fromRGBO(109, 117, 208, 0.8),
        actions: <Widget>[

          PopupMenuButton<String>(
            icon: Icon(Icons.add_to_photos),
            onSelected: (String result) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateDishPage()),
                  );
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Thêm món ăn',
                child: Text('Thêm món ăn mới'),
              ),
            ],
          ),
        ],
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
                          child: Text('Sửa',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditDishPage(dish: dishes[index]),
                              ),
                            );
                            setState(() {});
                          },
                        ),
                        TextButton(
                          child: Text('Xóa',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),),
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
                    side: BorderSide(color: Color.fromRGBO(109, 117, 208, 0.8), width: 2.0)
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
                        style: const TextStyle(fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(109, 117, 208, 0.8),
                          fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${dishes[index].price.toStringAsFixed(2)}\k  ',

                              style: TextStyle(fontWeight: FontWeight.bold,

                        fontSize: 13)
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
    );
  }
}
