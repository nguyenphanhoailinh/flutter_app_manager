import 'dishinfo.dart';

class Bill{

  int idbill;
  int idorder;
  List<DishInfo> dishes;
  DateTime ngaygiodat;
  int idtable;
  String tablename;
  double totalAmount;
  DateTime deletedAt;
  Bill({required this.idbill,required this.idorder,required this.dishes,required this.ngaygiodat,required this.idtable,required this.tablename,required this.totalAmount,required this.deletedAt});

  Bill.fromJson(Map<String, dynamic> json)
      : idbill = json['idbill'] ?? 0,
        idorder = json['idorder'] ?? 0,
        dishes = (json['dishes'] as List).map((i) => DishInfo.fromJson(i)).toList() ?? [],
        ngaygiodat = DateTime.parse(json['ngaygiodat']) ?? DateTime.now(),
        idtable = json['tableid'] ?? 0,
        tablename =json['tablename'],
        totalAmount = json['totalAmount'] ?? 0.0,
        deletedAt = DateTime.parse(json['deletedAt']) ?? DateTime.now();

    // return Bill(
    //   idbill: json['idreport'],
    //   idorder: json['idorder'],
    //   dishes: dishesList,
    //   ngaygiodat: DateTime.parse(json['ngaygiodat']),
    //   idtable: json['idtable'],
    //   totalAmount: json['total_amount'],
    //   deletedAt: DateTime.parse(json['deleted_at']),
    // );
  }
