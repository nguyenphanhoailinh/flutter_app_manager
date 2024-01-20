import 'dart:html';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../models/ingredient.dart';

class CreateProductPage extends StatefulWidget {
  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormState>();
  Ingredient newIngredient = Ingredient(
    nameingredient: '',
    imagefilename: '',
    soluong: 0,
    price: 0.0,
    totalprice: 0.0,
    xuatsu: '',
    ngaygionhap: DateTime.now(),
    loainguyenlieu: '',
  );

  Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:8818/api/v1/ingredient"));
  FileUploadInputElement? _uploadInputElement;

  void pickImage() {
    _uploadInputElement = FileUploadInputElement()..accept = 'image/*';
    _uploadInputElement!.click();

    _uploadInputElement!.onChange.listen((event) {
      final file = _uploadInputElement!.files!.first;
      final reader = FileReader();

      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        setState(() {
          newIngredient.imagefilename = reader.result as String;
        });
      });
    });
  }

  Future<void> createIngredient() async {
    if (newIngredient.imagefilename == null) return;

    FormData formData = FormData.fromMap({
      "nameingredient": newIngredient.nameingredient,
      "soluong": newIngredient.soluong,
      "price": newIngredient.price,
      "totalprice": newIngredient.totalprice,
      "xuatsu": newIngredient.xuatsu,
      "ngaygionhap": newIngredient.ngaygionhap.toIso8601String(),
      "loainguyenlieu": newIngredient.loainguyenlieu,
      "image": newIngredient.imagefilename,
    });

    try {
      var response = await dio.post("/create", data: formData);
      if (response.statusCode == 200) {
        print("Ingredient created successfully");
      } else {
        print("Ingredient creation failed");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Ingredient'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Ingredient Name'),
              onSaved: (value) {
                newIngredient.nameingredient = value ?? '';
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                newIngredient.soluong = int.parse(value ?? '0');
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                newIngredient.price = double.parse(value ?? '0.0');
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Total Price'),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                newIngredient.totalprice = double.parse(value ?? '0.0');
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Origin'),
              onSaved: (value) {
                newIngredient.xuatsu = value ?? '';
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Type of Ingredient'),
              onSaved: (value) {
                newIngredient.loainguyenlieu = value ?? '';
              },
            ),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  createIngredient();
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
