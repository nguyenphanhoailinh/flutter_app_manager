class Dish {
  String namedish;
  String imagefilename;
  double price;

  Dish({required this.namedish, required this.imagefilename ,required this.price });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      namedish: json['namedish'],
      imagefilename: json['imagefilename'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'namedish': namedish,
      'imagefilename': imagefilename,
      'price': price,
    };
  }
}
