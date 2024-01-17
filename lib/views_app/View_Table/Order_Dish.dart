import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app_manager/models/Status.dart';
import 'package:flutter_app_manager/models/order.dart';
import 'package:flutter_app_manager/models/orderdish.dart';
import 'package:flutter_app_manager/models/table.dart';
import '../../models/dish.dart';
import '../PaymentOrder/payment.dart';
import 'Menu_Table.dart';

class OrderDishPage extends StatefulWidget {
  final String tableName;
  final int idtable;
  

  final Function(String, String) updateTableStatus;
  // Order orders;

  const OrderDishPage({Key? key, required this.tableName,required this.idtable, required this.updateTableStatus}) : super(key: key);

  @override
  _OrderDishPageState createState() => _OrderDishPageState();
}

class _OrderDishPageState extends State<OrderDishPage> {
  int numberOfDishes = 0;
  List<Dish> selectedDishes = [];
  List<Dish> orderedDishes =[];
  List<TableB> tables = [];
  double totalAmount = 0.0;
  List<Order> order = [];
  // Order order;
  List<Dish> allDishes = [];
  Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:8888/api/v1/dishs"));

  Dio dio1 = Dio(BaseOptions(baseUrl: "http://localhost:8888/api/v1/orders"));


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

  Future<Order> createOrder(Order order) async {
    OrderDish orderDish = OrderDish(
      iddish: selectedDishes.map((e) => e.iddish).toList(),
      ngaygiodat: DateTime.now(),
      idtable: widget.idtable,
      totalAmount: calculateTotalAmount(
        selectedDishes,),
    );
    String jsonOrder = jsonEncode(orderDish.toJson());
    try {
      final response = await dio1.post(
        "/new", //
        data: jsonOrder,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201 && response.data != null) {
        var data = response.data as Map<String, dynamic>;
        if (data != null) {
          return Order.fromJson(data);
        } else {
          throw Exception('Failed to convert the response data');
        }
      } else {
        throw Exception('Failed to create order');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to connect to API');
    }
  }
  Future<Order> getOrdersByTableId(int idtable) async {
    try {
      final response = await dio1.get("/$idtable");
      if (response.statusCode == 200) {
        Map<String,dynamic> jsonResponse = response.data;
        try {
          return Order.fromJson(jsonResponse);
        } catch(e) {
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


  void handleSaveOrder(Order order) {
    createOrder(order).then((createOrder) {
    }).catchError((error) {
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDishes().then((dishes) {
      setState(() {
        allDishes = dishes;
        selectedTable = TableB(
          idtable: widget.idtable,
          nametable: widget.tableName,
          status: Status.dangSuDung,
        );
        
      });
    });
  }

    late TableB selectedTable;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () =>
              Navigator.pushNamed(context, '/home'),
        ),
        title: Text(widget.tableName),
        backgroundColor:Color.fromRGBO(109, 117, 208, 0.8),
      ),

      body: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Material(
              child: Column(
                children: <Widget>[
                  const ListTile(
                    leading: Icon(Icons.shopping_basket),
                    subtitle: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // children: <Widget>[
                      //   Icon(Icons.shopping_basket),
                      //   //Text('Gọi món ăn tại đây'),
                      // ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {

                      showModalBottomSheet(
                          backgroundColor: const Color.fromRGBO(109, 117, 208, 0.8),
                        context: context,
                        builder: (BuildContext context) {
                          return ListView.builder(
                            itemCount: allDishes.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(allDishes[index].imagefilename),
                                    radius: 30,
                                  ),
                                  title: Text(
                                    allDishes[index].namedish,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Giá: ${allDishes[index].price}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  onTap: () {
                                    addDish(allDishes[index]);
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(109, 117, 208, 0.8)), // Chọn màu xanh tùy ý
                    ),
                    child: const Padding(

                      padding: EdgeInsets.only(right: 0),

                      child: Text(' Gọi Món'),
                    ),
                  ),

                Expanded(
                    flex: 1,
                  child:FutureBuilder<Order>(
                    future: getOrdersByTableId(widget.idtable),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ExpansionTile(
                          title: const Padding(
                            padding: EdgeInsets.only(bottom: 8.0,top: 30.0),
                            child: Text('Các món đã gọi'),
                          ),
                          subtitle: Text('Ngày Đặt: ${snapshot.data!.ngaygiodat}'),
                          children: <Widget>[
                            ...snapshot.data!.dishes.map((dish) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage('${dish.imagefilename}'),
                                  radius: 30.0, //
                                ),
                                title: Text('${dish.namedish}'),
                                subtitle: Text('${dish.price}\k'),
                              );
                            }).toList(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Tổng Số Tiền: ${snapshot.data!.totalAmount}\k', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(109, 117, 208, 0.8),
                                minimumSize: const Size(30, 40),
                              ),
                              onPressed: () async {
                                // print(index);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PayMentPage(
                                    idtable: widget.idtable,
                                  )),
                                );
                              },
                              child: const Text(
                                'Thanh Toán',
                                style: TextStyle(fontSize: 15, color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {

                        // return Text("${snapshot.error}");
                      }
                      return CircularProgressIndicator();
                    },
                  )
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
                    title: const Text('Danh sách món ăn đã chọn'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: selectedDishes
                          .map((dish) => Padding(
                        padding: const EdgeInsets.all(8.0), // Thêm padding
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                dish.imagefilename,
                              ),
                              radius: 30,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${dish.namedish} - ${dish.price.toStringAsFixed(2)}\k',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ))
                          .toList(),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Tổng cộng'),
                    subtitle: Text('${totalAmount.toStringAsFixed(2)}\k '),
                  ),
            ElevatedButton(
              onPressed: () async {

                if (selectedTable == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng chọn một bàn trước khi tạo đơn hàng.')),
                  );
                } else {
                  try {
                    Order order = Order(
                      dishes: selectedDishes,
                      // Danh sách các món ăn đã chọn
                      ngaygiodat: DateTime.now(),
                      table: selectedTable,
                      status: Status.dangSuDung,
                      totalAmount: calculateTotalAmount(
                          selectedDishes),
                        idorder:null,// Tính tổng số tiền
                    );
                    await createOrder(order);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Đơn hàng đã được tạo thành công!')),

                    );

                  } catch (e) {
                    // // Hiển thị thông báo lỗi
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(content: Text('Không thể tạo đơn hàng: $e')),
                    // );
                  }
                  setState(() {

                  });
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(109, 117, 208, 0.8)), // Chọn màu xanh tùy ý
              ),
              child: const Text('XÁC NHẬN ĐƠN HÀNG'),
            ),

            ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  static void updateTableStatus(String tableName, String newStatus) {
  }
  void addDish(Dish dish) {
    setState(() {
      numberOfDishes++;
      selectedDishes.add(dish);
      totalAmount += dish.price;
    });
  }
  double calculateTotalAmount(List<Dish> dishes) {
    double total = 0.0;
    for (var dish in dishes) {
      total += dish.price;
    }
    return total;
  }
  void onConfirmOrder() {
    setState(() {
      orderedDishes = List.from(selectedDishes); // Lưu các món ăn đã chọn
    });
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
