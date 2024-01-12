import 'package:flutter/material.dart';

class OrderDishPage extends StatefulWidget {
  final String tableName;

  const OrderDishPage({Key? key, required this.tableName}) : super(key: key);

  @override
  _OrderDishPageState createState() => _OrderDishPageState();
}

class _OrderDishPageState extends State<OrderDishPage>{
  int numberOfDishes = 0;

  void addDish() {
    setState(() {
      numberOfDishes++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tableName),
      ),
      body: Material(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.food_bank),

              subtitle: Text('$numberOfDishes món ăn'),
            ),
            ElevatedButton(
              onPressed: addDish,
              child: Text('GỌI MÓN'),
            ),
            // Thêm các widget khác theo nhu cầu
          ],
        ),
      ),
    );
  }
}
