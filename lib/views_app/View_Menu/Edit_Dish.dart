import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app_manager/models/dish.dart';
import 'package:flutter_app_manager/views_app/View_Menu/menu_dish.dart';
import 'package:image_picker/image_picker.dart';

class EditDishPage extends StatefulWidget {
  final Dish dish;

  EditDishPage({required this.dish});

  @override
  _EditDishPageState createState() => _EditDishPageState();
}

class _EditDishPageState extends State<EditDishPage> {
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();
  late TextEditingController _dishNameController;
  late TextEditingController _priceController;
  Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:8888/api/v1/dishs"));
  XFile? pickedImage;

  @override
  void initState() {
    super.initState();
    _dishNameController = TextEditingController(text: widget.dish.namedish);
    _priceController = TextEditingController(text: widget.dish.price.toString());
  }

  void _pickImage() async {
    pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageUrl = null;
    });
  }

  Future<void> _updateDish() async {
    try {
      Map<String, dynamic> fields = {
        'namedish': _dishNameController.text,
        'price': double.parse(_priceController.text),
      };

      FormData formData = FormData();
      if (pickedImage != null) {
        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(pickedImage!.path, filename: pickedImage!.name),
        ));
      }

      formData.fields.addAll(fields.entries.map((entry) => MapEntry(entry.key, entry.value.toString())));

      final response = await dio.put("/update/${widget.dish.iddish}", data: formData);

      if (response.statusCode == 200) {
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (context) => Menu_Dish()));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Món ăn đã được cập nhật thành công"),
            backgroundColor: Colors.green,
          ),
        );
        print("Món ăn đã được cập nhật thành công");
        print('Data received from API: ${response.data}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể cập nhật món ăn'),
            backgroundColor: Colors.red,
          ),
        );
        print("Không thể cập nhật món ăn");
      }
    } catch (error) {
      print("Không thể kết nối với API: $error");
      throw Exception('Failed to connect to API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () {
            setState(() {});
            Navigator.pushNamed(context, '/menudish');

          },
        ),
        title: Text('Sửa món'),
        backgroundColor: Color.fromRGBO(109, 117, 208, 0.8),
      ),
      body: Form(

        child: Column(
          children: <Widget>[
            if (_imageUrl != null)
              Image.network(_imageUrl!)
            else
              Image.network(widget.dish.imagefilename),
            TextFormField(
              controller: _dishNameController,
              decoration: InputDecoration(labelText: 'Tên món',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên món';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Giá'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập giá';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(109, 117, 208, 0.8),
                minimumSize: const Size(50, 50),
              ),
              onPressed: _pickImage,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt),
                  SizedBox(width: 8), // Add some space between the icon and text
                  Text('Chọn hình ảnh mới'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(109, 117, 208, 0.8),
                minimumSize: const Size(double.infinity, 50),
              ),

              onPressed: () {
                _updateDish();
                setState(() {});
              },

              child: const Text('Cập nhật món ăn',
                  style: TextStyle( fontSize:15,color: Colors.white),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}