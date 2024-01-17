class DishInfo{

  String dishname;
  double price;

  DishInfo({required this.price,required this.dishname});

  factory DishInfo.fromJson(Map<String, dynamic> json) {
    return DishInfo(
      dishname: json['dishname'],
      price: json['price'].toDouble(),
    );
  }
  @override
  String toString() {
    return 'món ăn: ${this.dishname}, Giá: ${this.price}\k.'; // Thay đổi để phù hợp với các trường của bạn
  }}