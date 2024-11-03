

class GetMyrideModel {
  final int id;
  final int customerid;
  final String customerfname;
  final String customerlname;
    final String customerphone;
  final String from;
  final String to;
  final int numberofpassagers;
  final String action;

  GetMyrideModel({
       required this.id,
    required this.customerid,
    required this.customerfname,
    required this.customerlname,
     required this.customerphone,
    required this.from,
    required this.to,
    required this.numberofpassagers,
    required this.action,

 
  });

  factory GetMyrideModel.fromJson(Map<String, dynamic> json) {
    return GetMyrideModel(
       id: json['id'] as int,
     customerid: json['customerid'] as int,
      customerfname: json['customerfname'] as String,
      customerlname: json['customerlname'] as String,
          customerphone: json['customerphone'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      numberofpassagers: json['numberofpassagers'] as int,
      action: json['action'] as String,
 
    );
  }
}
