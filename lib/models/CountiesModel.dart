class CountiesModel {
  final int id;
  final String counties;

  CountiesModel({
    required this.id,
    required this.counties,
  });

  factory CountiesModel.fromJson(Map<String, dynamic> json) {
    return CountiesModel(
      id: json['id'] as int,
      counties: json['counties'] as String,
    );
  }
}
