  import 'package:flutter_app_manager/models/Status.dart';

class TableB{
      int idtable;
     String nametable;
     Status status;

     TableB({  required this.nametable,required this.idtable,required this.status});

     factory TableB.fromJson(Map<String, dynamic> json) {
       return TableB(
         idtable: json['idtable'],
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
