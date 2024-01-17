
class Dish {
  int iddish;
  String namedish;
  String imagefilename;
  double price;

  Dish({
    required this.iddish,
    required this.namedish,
    required this.imagefilename,
    required this.price,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      iddish: json['iddish'] as int,
      namedish: json['namedish'],
      imagefilename: json['imagefilename'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iddish': iddish,
      'namedish': namedish,
      'imagefilename': imagefilename,
      'price': price,
    };
  }

}
