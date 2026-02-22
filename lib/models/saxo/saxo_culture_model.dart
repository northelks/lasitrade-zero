class SaxoCultureModel {
  final String cultureCode;
  final String name;

  SaxoCultureModel({
    required this.cultureCode,
    required this.name,
  });

  factory SaxoCultureModel.fromJson(Map<String, dynamic> json) {
    return SaxoCultureModel(
      cultureCode: json['CultureCode'],
      name: json['Name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CultureCode': cultureCode,
      'Name': name,
    };
  }
}
