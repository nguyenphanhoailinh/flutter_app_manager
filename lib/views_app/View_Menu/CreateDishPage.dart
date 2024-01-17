import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateDishPage extends StatefulWidget {
  const CreateDishPage({Key? key}) : super(key: key);

  @override
  _CreateDishPageState createState() => _CreateDishPageState();
}

class _CreateDishPageState extends State<CreateDishPage> {
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _dishNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:8888/api/v1/dishs"));
  XFile? pickedImage;
  void _pickImage() async {
     pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageUrl = pickedImage!.path;
    });
  }

  Future<void> _saveDish() async {
    try {

      if (pickedImage != null) {
        FormData formData = FormData.fromMap({
          'image': await MultipartFile.fromBytes( await pickedImage!.readAsBytes(),filename: pickedImage!.name),
          'dishName': _dishNameController.text,
          'price': double.parse(_priceController.text),
        });

        final response = await dio.post("/create", data: formData);
        if (response.statusCode == 200) {

          print("Dish created successfully");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tạo món ăn thành công'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm món ăn'),
        backgroundColor: Color.fromRGBO(109, 117, 208, 0.8),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(75),
                  border: Border.all(color: Colors.blue, width: 2.0),
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
            const SizedBox(height: 20),
            TextFormField(
              controller: _dishNameController,
              decoration: const InputDecoration(
                labelText: 'Tên Món',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Giá tiền',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Color.fromRGBO(109, 117, 208, 0.8)
              ),
              onPressed: _saveDish,
              child: Text('Tạo'),
            ),
          ],
        ),
      ),
    );
  }
}