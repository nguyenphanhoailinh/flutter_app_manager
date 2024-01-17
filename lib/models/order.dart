//
// import 'package:flutter_app_manager/models/table.dart';
// import 'package:flutter_app_manager/models/user.dart';
//
// import 'dish.dart';
//
// class Order {
//   List<Dish> dishes;
//   //User user;
//   DateTime ngaygiodat;
//   TableB table;
//   String status;
//   double totalAmount;
//
//   Order({
//     required this.dishes,
//    // required this.user,
//     required this.ngaygiodat,
//     required this.table,
//     required this.status,
//     required this.totalAmount
//   });
//
//   // Add a factory constructor for creating Order objects from JSON
//   factory Order.fromJson(Map<String, dynamic> json) {
//     return Order(
//       dishes: (json['dishes'] as List? ?? []).map((e) => Dish.fromJson(e)).toList(),
//       //user: User.fromJson(json['user'] ?? {}),
//       ngaygiodat: json['ngaygiodat'] != null ? DateTime.parse(json['ngaygiodat']) : DateTime.now(),
//       table: TableB.fromJson(json['table'] ?? {}),
//       status: json['status'] ?? '',
//       totalAmount: json['totalAmount']
//     );
//   }
//
//   // Add a toJson method for converting Order objects to JSON
//   Map<String, dynamic> toJson() {
//     return {
//         'dishes': dishes.map((e) => e.toJson()).toList(),
//       'ngaygiodat': ngaygiodat.toString(),
//       'table': table.toJson(),
//       'status': status,
//       'totalAmount':totalAmount
//     };
//   }
//
// }
import 'package:flutter_app_manager/models/Status.dart';
import 'package:flutter_app_manager/models/table.dart';

import 'dish.dart';

class Order {
  final int? idorder;
  final List<Dish> dishes;
  final DateTime ngaygiodat;
  final TableB table;
  final Status status;
  final double totalAmount;

  Order({
     required this.idorder,
    required this.dishes,
    required this.ngaygiodat,
    required this.table,
    required this.status,
    required this.totalAmount,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var list = json['dishes'] as List;
    List<Dish> dishesList = list.map((i) => Dish.fromJson(i)).toList();
    return Order(
      idorder: json['idorder'],
      dishes: dishesList,
      ngaygiodat: DateTime.parse(json['ngaygiodat']),
      table: TableB.fromJson(json['table']),
      status: Status.values.firstWhere((e) => e.toString() == 'Status.${json['status']}'),
      totalAmount: json['totalAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idorder':idorder,
      'dishes': dishes.map((dish) => dish.toJson()).toList(),
      'ngaygiodat': ngaygiodat.toIso8601String(),
      'table': table.toJson(),
      'status': status.toString().split('.').last,
      'totalAmount': totalAmount,
    };
  }
}
