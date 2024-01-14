// import 'package:flutter/material.dart';
//
// import '../../models/order.dart';
//
// class OrderPage extends StatelessWidget {
//   final Order order;
//
//   OrderPage({required this.order});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chi tiết đơn hàng'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Ngày và giờ đặt: ${order.ngaygiodat.toString()}',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Danh sách món ăn:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: order.dishes
//                   .map((dish) => Text(
//                 '${dish.namedish} - \$${dish.price.toStringAsFixed(2)}',
//                 style: TextStyle(fontSize: 16),
//               ))
//                   .toList(),
//             ),
//             // SizedBox(height: 20),
//             // Text(
//             //   'Người đặt: ${order.user.fullname}',
//             //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             // ),
//             SizedBox(height: 20),
//             Text(
//               'Bàn số: ${order.table.nametable}',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Trạng thái: ${order.status.toString().split('.').last}',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
