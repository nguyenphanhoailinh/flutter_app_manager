import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../models/ingredient.dart';
import 'CreateProduct.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Ingredient> ingredients = [];
  Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:8818/api/v1/ingredient"));


  Future<List<Ingredient>> getAllIngerdient() async {
   try{
     final response = await dio.get("/all");
     if(response.statusCode == 200){
       print(response);
       print('chay');
       List<dynamic> JsonResponse = response.data;
       if(JsonResponse is List){
         print(response);
         return JsonResponse.map((item) => Ingredient.fromJson(item)).toList();

       }
       else{
       throw Exception('Failed to load list  from API');
     }

     }else{
       throw Exception('Failed to load dishes from API');
     }


   }catch(e){
     print('error:$e');
     throw Exception('failse');
   }
  }

  @override
  void initState() {
    super.initState();
    getAllIngerdient().then((ingredients) {
      setState(() {
         this.ingredients = ingredients;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingredients'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text('Name'),
            ),
            DataColumn(
              label: Text('Image'),
            ),
            DataColumn(
              label: Text('Quantity'),
            ),
            DataColumn(
              label: Text('Price'),
            ),
            DataColumn(
              label: Text('Total Price'),
            ),
            DataColumn(
              label: Text('Origin'),
            ),
            DataColumn(
              label: Text('Date of Entry'),
            ),
            DataColumn(
              label: Text('Type of Ingredient'),
            ),
          ],
          rows: ingredients.map((Ingredient ingredient) => DataRow(
            cells: <DataCell>[
              DataCell(Text(ingredient.nameingredient)),
              DataCell(Image.network(ingredient.imagefilename, width: 50, height: 50)),
              DataCell(Text(ingredient.soluong.toString())),
              DataCell(Text(ingredient.price.toString())),
              DataCell(Text(ingredient.totalprice.toString())),
              DataCell(Text(ingredient.xuatsu)),
              DataCell(Text(ingredient.ngaygionhap.toString())),
              DataCell(Text(ingredient.loainguyenlieu)),
            ],
          )).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProductPage()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}