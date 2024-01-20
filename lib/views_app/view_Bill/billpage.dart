import 'package:flutter_app_manager/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_manager/views_app/login/loginform.dart';
import 'package:flutter_app_manager/views_app/views_home/Home_Page.dart';

import '../../models/order.dart';
import '../../models/bill.dart';
import '../../models/table.dart';

class BillPage extends StatefulWidget {
  @override
  _BillPageState createState() => _BillPageState();
}


class _BillPageState extends State<BillPage> {
  List<TableB> tables = [];
  List<Bill> bills=[];
  Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:8888/api/v1/bill"));

  Future<List<Bill>> fetchBill() async {
    try {
      final response = await dio.get("/all");

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = response.data;
        if (jsonResponse is List) {

          return jsonResponse.map((item) => Bill.fromJson(item)).toList();
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
  void initState(){
    super.initState();
    // fetchReportOrder();
  }
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách Đã Thanh Toán', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(109, 117, 208, 0.8),
      ),
      body: FutureBuilder<List<Bill>>(
        future: fetchBill(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (context, index) => Divider(color: Colors.grey),
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: index % 2 == 0 ? Colors.white : Colors.grey[200],
                  title: Text(' ${snapshot.data![index].tablename}', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Thời gian đặt: ${snapshot.data![index].ngaygiodat}'),
                      for (var dish in snapshot.data![index].dishes)
                        Text('$dish'),
                      Text('Thời gian thanh toán :${snapshot.data![index].deletedAt}'),
                      Text('Tổng tiền: ${snapshot.data![index].totalAmount}k'),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}", style: TextStyle(color: Colors.red)));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
