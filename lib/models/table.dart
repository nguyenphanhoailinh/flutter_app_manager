class TableB{

   String nametable;
   String status;

   TableB({  required this.nametable,required this.status});

   factory TableB.fromJson(Map<String, dynamic> json) {
     return TableB(
       nametable: json['nametable'],
       status: json['status'],
     );
   }

  Map<String, dynamic> toJson() {
    return {
      'nametable': nametable,
      'status': status,
    };
  }
}
