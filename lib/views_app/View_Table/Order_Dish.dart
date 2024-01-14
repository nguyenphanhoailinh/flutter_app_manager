import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../models/dish.dart';
import 'Menu_Table.dart';

class OrderDishPage extends StatefulWidget {
  final String tableName;
  final Function(String, String) updateTableStatus;


  const OrderDishPage({Key? key, required this.tableName, required this.updateTableStatus}) : super(key: key);

  @override
  _OrderDishPageState createState() => _OrderDishPageState();
}

class _OrderDishPageState extends State<OrderDishPage> {
  int numberOfDishes = 0;
  List<Dish> selectedDishes = [];
  double totalAmount = 0.0;

  List<Dish> allDishes = [];
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

  @override
  void initState() {
    super.initState();
    fetchDishes().then((dishes) {
      setState(() {
        allDishes = dishes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tableName),
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Material(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.food_bank),
                    subtitle: Text('$numberOfDishes món ăn'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return ListView.builder(
                            itemCount: allDishes.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(allDishes[index].namedish),
                                onTap: () {
                                  addDish(allDishes[index]);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Text('GỌI MÓN'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Material(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ListTile(
                    title: Text('Danh sách món ăn đã chọn'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: selectedDishes
                          .map((dish) => Text(
                        '${dish.namedish} - \$${dish.price.toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                          .toList(),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Tổng cộng'),
                    subtitle: Text('\$${totalAmount.toStringAsFixed(2)}'),
                  ),
                  ElevatedButton(
                    onPressed: confirmOrder,
                    child: Text('XÁC NHẬN ĐƠN HÀNG'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addDish(Dish dish) {
    setState(() {
      numberOfDishes++;
      selectedDishes.add(dish);
      totalAmount += dish.price;
    });
  }

  void confirmOrder() async {
    try {
      List<int> dishIds = selectedDishes.map((dish) => dish.iddish!).toList();


      final response = await dio.post("/api/v1/orders/create", data: {
        "dishes": dishIds,
        "user": getCurrentUsername,
        "table": widget.nametable,
        "ngaygiodat": DateTime.now().toIso8601String(),
        "status": "ĐANG_SỬ_DỤNG",
      });

      if (response.statusCode == 200) {
        print('Confirmed Order');
        print(
            'Selected Dishes: ${selectedDishes.map((dish) => '${dish.namedish} - \$${dish.price.toStringAsFixed(2)}').toList()}');
        print('Total Amount: \$${totalAmount.toStringAsFixed(2)}');
        clearSelectedDishes();

        // Gọi phương thức để cập nhật trạng thái trang danh sách bàn
        widget.updateTableStatus(widget.tableName, 'ĐANG_SỬ_DỤNG');

        // Pop về trang trước đó (Menu_Table)
        Navigator.pop(context);
      } else {
        print('Failed to confirm order. ${response.data}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }


  void clearSelectedDishes() {
    setState(() {
      numberOfDishes = 0;
      selectedDishes = [];
      totalAmount = 0.0;
    });
  }
  String getCurrentUsername() {
    // Replace this with your actual logic to retrieve the current user's username
    return "thinh"; // Example placeholder
  }
}
