class OrderDish{

  final List<int> iddish;
  final DateTime ngaygiodat;
  final int idtable;
  final double totalAmount;

  OrderDish({
    //required this.idorder,
    required this.iddish,
    required this.ngaygiodat,
    required this.idtable,
    required this.totalAmount,
  });
  Map<String, dynamic> toJson() {
    return {
      //'idorder':idorder,
      'iddish':iddish.toList() ,
      'ngaygiodat': ngaygiodat.toIso8601String(),
      'idtable': idtable.toString(),
      'totalAmount': totalAmount.toString(),
    };
  }

}