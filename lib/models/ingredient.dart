class Ingredient{
  int idingredient;
  String nameingredient;
  String imagefilename;
  int soluong;
  double price;
  double totalprice;
  String xuatsu;
  DateTime ngaygionhap;
  String loainguyenlieu;
Ingredient ({
  required this.idingredient,
    required this.nameingredient,
    required this.imagefilename,
  required this.soluong,
  required this.price,
  required this.totalprice,
  required this.xuatsu,
  required this.ngaygionhap,
  required this.loainguyenlieu
});
factory Ingredient.fromJson(Map<String, dynamic> json){
  return Ingredient(
      idingredient: json['idingredient'] as int,
      nameingredient: json['nameingredient'] ,
      imagefilename: json['imagefilename'],
      soluong: json['soluong'] as int,
      price: json['price'],
      totalprice: json['totalprice'],
      xuatsu: json['xuatsu'],
      ngaygionhap: DateTime.parse(json['ngaygionhap']) ,
      loainguyenlieu: json['loainguyenlieu'] );

}
Map<String, dynamic > toJson(){
  return {
    'idingredient':idingredient,
    'nameingredient': nameingredient,
    'imagefilename': imagefilename,
    'soluong': soluong,
    'price': price,
    'totalprice': totalprice,
    'xuatsu': xuatsu,
    'ngaygionhap': ngaygionhap.toIso8601String(),
    'loainguyenlieu': loainguyenlieu,
  };
}
}
