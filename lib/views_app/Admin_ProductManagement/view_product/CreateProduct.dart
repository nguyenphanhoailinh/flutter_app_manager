import 'dart:html';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/ingredient.dart';

class CreateProductPage extends StatefulWidget {
  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {

  Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:8818/api/v1/ingredient"));
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameingredientController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _soluongController = TextEditingController();
  final TextEditingController _totalpriceController = TextEditingController();
  final TextEditingController _xuatsuController = TextEditingController();
 final TextEditingController _ngaygionhapController = TextEditingController();

  final TextEditingController _loainguyenlieuController = TextEditingController();

  XFile? pickedImage;
  void _pickImage() async {
    pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageUrl = pickedImage!.path;
    });
  }
  Future<void> createIngredient() async {
    try {

      if (pickedImage != null) {
        FormData formData = FormData.fromMap({
          'image': await MultipartFile.fromBytes( await pickedImage!.readAsBytes(),filename: pickedImage!.name),
          'nameingredient': _nameingredientController.text,
          'soluong':_soluongController.text,
          'price': double.parse(_priceController.text),
          'totalprice':double.parse(_totalpriceController.text),
          'xuatsu':_xuatsuController.text,
          'loainguyenlieu':_loainguyenlieuController.text,
          'ngaygionhap': DateTime.now().toIso8601String(),
        });

        final response = await dio.post("/create", data: formData);
        if (response.statusCode == 200) {

          print("product created successfully");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tạo thành công'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          print("Failed to create dish");
        }
      } else {
        print("No image selected");
      }
    } catch (error) {
      print("Failed to connect to API + formData");
    }
  }
  void calculateTotalPrice() {
    int soluong = int.parse(_soluongController.text);
    double price = double.parse(_priceController.text);

    double totalprice = soluong * price;

    _totalpriceController.text = totalprice.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nguyên liệu mới'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(75),
                  ),
                  child: _imageUrl != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(75),
                    child: Image.network(
                      _imageUrl!,
                      fit: BoxFit.cover,
                    ),
                  )
                      : const Icon(
                    Icons.camera_enhance,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
              ),
              TextField(
                controller: _nameingredientController,
                decoration: InputDecoration(labelText: 'Tên nguyên liệu'),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Giá'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  calculateTotalPrice();
                },
              ),
              TextField(
                controller: _soluongController,
                decoration: InputDecoration(labelText: 'Số lượng'),
                onChanged: (value) {
                  calculateTotalPrice();
                },
              ),
              TextField(
                controller: _totalpriceController,
                decoration: InputDecoration(labelText: 'Tổng giá'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _xuatsuController,
                decoration: InputDecoration(labelText: 'Xuất sứ'),
              ),
              TextField(
                controller: _loainguyenlieuController,
                decoration: InputDecoration(labelText: 'Loại nguyên liệu'),
              ),
              // TextField(
              //   controller: _ngaygionhapController,
              //   decoration: InputDecoration(labelText: 'Ngày giờ nhập'),
              // ),

              ElevatedButton(
                onPressed: createIngredient,
                child: Text('Tạo nguyên liệu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
