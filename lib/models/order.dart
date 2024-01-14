
import 'package:flutter_app_manager/models/table.dart';
import 'package:flutter_app_manager/models/user.dart';

import 'dish.dart';

class Order {
  List<Dish> dishes;
  User user;
  DateTime ngaygiodat;
  TableB table;
  String status;

  Order({
    required this.dishes,
    required this.user,
    required this.ngaygiodat,
    required this.table,
    required this.status,
  });

  // Add a factory constructor for creating Order objects from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      dishes: (json['dishes'] as List? ?? []).map((e) => Dish.fromJson(e)).toList(),
      user: User.fromJson(json['user'] ?? {}),
      ngaygiodat: json['ngaygiodat'] != null ? DateTime.parse(json['ngaygiodat']) : DateTime.now(),
      table: TableB.fromJson(json['table'] ?? {}),
      status: json['status'] ?? '',
    );
  }

  // Add a toJson method for converting Order objects to JSON
  Map<String, dynamic> toJson() {
    return {
        'dishes': dishes.map((e) => e.toJson()).toList(),
      'user': user.toJson(),
      'ngaygiodat': ngaygiodat.toString(),
      'table': table.toJson(),
      'status': status,
    };
  }
}
