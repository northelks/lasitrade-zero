class SaxoCurrencyModel {
  final String currencyCode;
  final int decimals;
  final String name;
  final String? symbol;

  SaxoCurrencyModel({
    required this.currencyCode,
    required this.decimals,
    required this.name,
    required this.symbol,
  });

  factory SaxoCurrencyModel.fromJson(Map<String, dynamic> json) {
    return SaxoCurrencyModel(
      currencyCode: json['CurrencyCode'],
      decimals: json['Decimals'],
      name: json['Name'],
      symbol: json['Symbol'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CurrencyCode': currencyCode,
      'Decimals': decimals,
      'Name': name,
      'Symbol': symbol,
    };
  }
}
