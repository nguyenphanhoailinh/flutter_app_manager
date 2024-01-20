import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../models/ingredient.dart';

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
      body: ListView.builder(
        itemCount: ingredients.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(
              ingredients[index].imagefilename
            ),
            title: Text(ingredients[index].nameingredient),
            // Thêm các thông tin khác của Ingredient nếu muốn
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProductPage()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );

  }
}