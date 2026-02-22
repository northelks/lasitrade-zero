class SaxoCountryModel {
  final String countryCode;
  final String displayName;
  final String name;
  final String? a3;
  final int? numeric;

  SaxoCountryModel({
    required this.countryCode,
    required this.displayName,
    required this.name,
    required this.a3,
    required this.numeric,
  });

  factory SaxoCountryModel.fromJson(Map<String, dynamic> json) {
    return SaxoCountryModel(
      countryCode: json['CountryCode'],
      displayName: json['DisplayName'],
      name: json['Name'],
      a3: json['A3'],
      numeric: json['Numeric'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CountryCode': countryCode,
      'DisplayName': displayName,
      'Name': name,
      'A3': a3,
      'Numeric': numeric,
    };
  }
}
