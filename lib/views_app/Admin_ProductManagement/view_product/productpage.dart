import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app_manager/views_app/Admin_ProductManagement/view_product/updateproductpage.dart';
import '../../../models/ingredient.dart';
import 'CreateProduct.dart';

class ProductPage extends StatefulWidget {
  // final Ingredient? ingredient;
  //
  // ProductPage({required this.ingredient});
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Ingredient> ingredients = [];
  String? _selectedType;
  // List<Ingredient>? _ingredients;
  Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:8818/api/v1/ingredient"));


  Future<List<Ingredient>> getAllIngerdient() async {
   try{
     final response = await dio.get("/all");
     if(response.statusCode == 200){
       List<dynamic> JsonResponse = response.data;
       if(JsonResponse is List){
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
  Future<List<Ingredient>> getIngredientsByLoainguyenlieu(String loainguyenlieu) async {
    final response = await dio.get("/loainguyenlieu/$loainguyenlieu");

    if (response.statusCode == 200) {
      print(response);
      List<dynamic> jsonResponse = response.data;
      return jsonResponse.map((item) => Ingredient.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load ingredients from API');
    }
  }
  Future<void> deleteIngredient(int id) async {
    try {
      final response = await dio.delete("/delete/${id}");
      if (response.statusCode == 200) {
        print('Ingredient deleted successfully');

      } else {
        throw Exception('Failed to delete Ingredient');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to connect to API');
    }
  }
  @override
  void initState() {
    super.initState();
    _fetchIngredients();
  }

  void _fetchIngredients([String? loainguyenlieu]) {
    if (loainguyenlieu != null) {
      getIngredientsByLoainguyenlieu(loainguyenlieu).then((ingredients) {
        setState(() {
          this.ingredients = ingredients;
        });
      });
    } else {
      getAllIngerdient().then((ingredients) {
        setState(() {
          this.ingredients = ingredients;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh Sách các Nguyên liệu'),
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateProductPage(), // Trang để tạo nguyên liệu mới
              ),
            );
          },
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (String result) {
              _fetchIngredients(result);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Thịt',
                child: Text('Thịt'),
              ),
              const PopupMenuItem<String>(
                value: 'Rau',
                child: Text('Rau'),
              ),
              // Thêm các loại nguyên liệu khác tại đây
            ],
          ),
        ],
      ),
      body: ingredients == null
          ? CircularProgressIndicator()
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 20,
            headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[200]!),
            columns: const <DataColumn>[
              DataColumn(label: Text('Tên nguyên liệu', style: TextStyle(fontSize: 16))),
              DataColumn(label: Text('Hình ảnh', style: TextStyle(fontSize: 16))),
              DataColumn(label: Text('Số lượng', style: TextStyle(fontSize: 16))),
              DataColumn(label: Text('Giá', style: TextStyle(fontSize: 16))),
              DataColumn(label: Text('Tổng giá', style: TextStyle(fontSize: 16))),
              DataColumn(label: Text('Xuất sứ', style: TextStyle(fontSize: 16))),
              DataColumn(label: Text('Loại nguyên liệu', style: TextStyle(fontSize: 16))),
              DataColumn(label: Text('Ngày giờ nhập', style: TextStyle(fontSize: 16))),
              DataColumn(label: Text('Chỉnh sửa', style: TextStyle(fontSize: 16))), // Thêm cột "Chỉnh sửa"
            ],
            rows: ingredients!.map<DataRow>((Ingredient ingredient) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(Text(ingredient.nameingredient)),
                  DataCell(
                    Image.network(ingredient.imagefilename, height: 70, width: 70),
                  ),
                  DataCell(Text('${ingredient.soluong}')),
                  DataCell(Text('${ingredient.price}')),
                  DataCell(Text('${ingredient.totalprice}')),
                  DataCell(Text(ingredient.xuatsu)),
                  DataCell(Text(ingredient.loainguyenlieu)),
                  DataCell(Text('${ingredient.ngaygionhap}')),
                  DataCell(
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateProductPage(ingredient: ingredient),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await deleteIngredient(ingredient.idingredient);
                            setState(() {
                              // Gọi lại hàm tải dữ liệu ở đây
                              _fetchIngredients();
                            });
                          },

                        ),

                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
