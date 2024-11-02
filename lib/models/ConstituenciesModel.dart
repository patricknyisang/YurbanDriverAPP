class ConstituenciesModel {
  final int id;
  final String constituency;

  ConstituenciesModel({
    required this.id,
    required this.constituency,
  });

  factory ConstituenciesModel.fromJson(Map<String, dynamic> json) {
    return ConstituenciesModel(
      id: json['id'] as int,
      constituency: json['constituency'] as String,
    );
  }
}
