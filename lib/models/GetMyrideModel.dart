class GetMyrideModel {
  final int id;
  final String from;
  final String to;
    final String action;



  GetMyrideModel({
    required this.id,
    required this.from,
    required this.to,
     required this.action,

 
  });

  factory GetMyrideModel.fromJson(Map<String, dynamic> json) {
    return GetMyrideModel(
      id: json['id'] as int,
      from: json['from'] as String,
      to: json['to'] as String,
      action: json['action'] as String,
 
    );
  }
}
