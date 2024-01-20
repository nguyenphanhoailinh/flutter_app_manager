import 'package:flutter_app_manager/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_manager/views_app/login/loginform.dart';
import 'package:flutter_app_manager/views_app/views_home/Home_Page.dart';

import '../../models/order.dart';
import '../../models/bill.dart';
import '../../models/table.dart';

class PayMentPage extends StatefulWidget {
  final int idtable;

  PayMentPage({Key? key,required this.idtable}) : super(key: key);
  @override
  _PayMentPageState createState() => _PayMentPageState();
}


class _PayMentPageState extends State<PayMentPage> {
  List<TableB> tables = [];
  Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:8888/api/v1/orders"));
  Dio dio1 = Dio(BaseOptions(baseUrl: "http://localhost:8888/api/v1/bill"));
  Future<Bill> fetchReportOrder(int id) async{
    final reponse =await dio1.get('/$id');
    if(reponse.statusCode == 200){
      print(reponse.data);
      return Bill.fromJson(reponse.data);

    }else{
      throw Exception('Failed to load ReportOrder');
    }
  }
  Future<Order> getOrdersByTableId(int idtable) async {
    try {
      final response = await dio.get("/$idtable");
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
  Future<void> paymentOrder(int id) async {
    try {
      final response = await dio.delete("/delete/${id}");
      if (response.statusCode == 200) {

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('In hóa đơn thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('In hóa đơn không thành công'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('In hóa đơn không thành công'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState(){
    super.initState();
    // fetchReportOrder();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh Toán Và In Hóa Đơn'),
        backgroundColor: Color.fromRGBO(109, 117, 208, 0.8),
      ),
      body: FutureBuilder<Order>(
        future: getOrdersByTableId(widget.idtable),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0, top: 30.0),
                      child: Text('Các món đã gọi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Text('Ngày Đặt: ${snapshot.data!.ngaygiodat}', style: TextStyle(fontSize: 16)),
                    const Divider(color: Colors.grey),
                    ...snapshot.data!.dishes.map((dish) {
                      return Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage('${dish.imagefilename}'),
                              radius: 30.0,
                            ),
                            title: Text('${dish.namedish}', style: TextStyle(fontSize: 16)),
                            subtitle: Text('${dish.price}\k', style: TextStyle(fontSize: 14)),
                          ),
                          const Divider(color: Colors.grey),
                        ],
                      );
                    }).toList(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text('Tổng Số Tiền: ${snapshot.data!.totalAmount}\k', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(109, 117, 208, 0.8),
                        minimumSize: const Size(30, 40),
                      ),
                      onPressed: () async {
                        paymentOrder(snapshot.data!.idorder!);
                      },
                      child: const Text(
                        'In hóa đơn',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }




}
