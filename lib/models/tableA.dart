import 'package:flutter_app_manager/models/Status.dart';

class TableA{
  String nametable;
  Status status;

  TableA({  required this.nametable,required this.status});

  factory TableA.fromJson(Map<String, dynamic> json) {
    return TableA(
        nametable: json['nametable'],
        status:  Status.values.firstWhere(
              (e) => e.toString() == 'Status.${json['status']}',
          orElse: () => Status.conTrong,  // Giá trị mặc định
        )
    );
  }
  String statusToString(Status status) {
    return status.toString().split('.').last;
  }

  Map<String, dynamic> toJson() {
    return {
      //'idtable':idtable,
      'nametable': nametable,
      'status': statusToString(status),
    };
  }
}