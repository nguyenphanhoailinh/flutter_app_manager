import 'dart:html';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/ingredient.dart';

class UpdateProductPage extends StatefulWidget {
  final Ingredient ingredient;
  UpdateProductPage({required this.ingredient});
  @override
  _UpdateProductPageState createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {

  Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:8818/api/v1/ingredient"));
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();
  late TextEditingController _nameingredientController ;
  late TextEditingController _priceController;
  late TextEditingController _soluongController ;
  late TextEditingController _totalpriceController ;
  late TextEditingController _xuatsuController ;
  late TextEditingController _ngaygionhapController ;

  late TextEditingController _loainguyenlieuController ;

  XFile? pickedImage;
  @override
  void initState() {
    super.initState();
    _nameingredientController = TextEditingController(text: widget.ingredient.nameingredient);
    _priceController = TextEditingController(text: widget.ingredient.price.toString());
    _soluongController = TextEditingController(text: widget.ingredient.soluong.toString());
    _totalpriceController = TextEditingController(text: widget.ingredient.totalprice.toString());
    _xuatsuController = TextEditingController(text: widget.ingredient.xuatsu);
    _ngaygionhapController = TextEditingController(text: widget.ingredient.ngaygionhap.toIso8601String());
    _loainguyenlieuController = TextEditingController(text: widget.ingredient.loainguyenlieu);
  }
  void _pickImage() async {
    pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageUrl = null;
    });
  }
  Future<void> updateIngredient() async {
    try {
      Map<String, dynamic> fields ={
          'nameingredient': _nameingredientController.text,
          'soluong':int.parse(_soluongController.text),
          'price': double.parse(_priceController.text),
          'totalprice':double.parse(_totalpriceController.text),
          'xuatsu':_xuatsuController.text,
          'loainguyenlieu':_loainguyenlieuController.text,
          'ngaygionhap': DateTime.now().toIso8601String(),
        };
        FormData formData = FormData();
        if (pickedImage != null) {
          formData.files.add(MapEntry(
            'image',
            await MultipartFile.fromFile(pickedImage!.path, filename: pickedImage!.name),
          ));
        }
      formData.fields.addAll(fields.entries.map((entry) => MapEntry(entry.key, entry.value.toString())));
      final response = await dio.put("/update/${widget.ingredient.idingredient}", data: formData);
      if (response.statusCode == 200) {
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (context) => Menu_Dish()));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("nguyên liêu đã được cập nhật thành công"),
            backgroundColor: Colors.green,
          ),
        );
        print("nguyên liêu đã được cập nhật thành công");
        print('Data received from API: ${response.data}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể cập nhật nguyên liêu'),
            backgroundColor: Colors.red,
          ),
        );
        print("Không thể cập nhật nguyên liêu");
      }
    } catch (error) {
      print("Không thể kết nối với API: $error");
      throw Exception('Failed to connect to API');
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
        title: Text('Cập nhật nguyên liệu'),
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () {
            setState(() {});
            Navigator.pushNamed(context, '/ingredients');

          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // Hiển thị ảnh hiện tại hoặc ảnh mới được chọn
              ClipOval(
                child: Container(
                  width: 300, // Điều chỉnh kích thước ảnh theo ý muốn
                  height: 300, // Điều chỉnh kích thước ảnh theo ý muốn
                  child: Image.network(
                    _imageUrl ?? widget.ingredient.imagefilename,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Nút để chọn ảnh mới
              // Các trường nhập liệu
              TextField(
                controller: _nameingredientController,
                decoration: InputDecoration(labelText: 'Tên nguyên liệu'),
              ),
              TextField(
                controller: _soluongController,
                decoration: InputDecoration(labelText: 'Số lượng'),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Giá'),
              ),
              TextField(
                controller: _totalpriceController,
                decoration: InputDecoration(labelText: 'Tổng giá'),
              ),
              TextField(
                controller: _xuatsuController,
                decoration: InputDecoration(labelText: 'Xuất sứ'),
              ),
              TextField(
                controller: _loainguyenlieuController,
                decoration: InputDecoration(labelText: 'Loại nguyên liệu'),
              ),
              ElevatedButton(
                child: Text('Chọn ảnh mới'),
                onPressed: _pickImage,
              ),
              // Nút để cập nhật nguyên liệu
              ElevatedButton(
                child: Text('Cập nhật nguyên liệu'),
                onPressed: updateIngredient,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
