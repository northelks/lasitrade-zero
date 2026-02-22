class SaxoLanguageModel {
  final String languageCode;
  final String languageName;
  final String nativeName;

  SaxoLanguageModel({
    required this.languageCode,
    required this.languageName,
    required this.nativeName,
  });

  factory SaxoLanguageModel.fromJson(Map<String, dynamic> json) {
    return SaxoLanguageModel(
      languageCode: json['LanguageCode'],
      languageName: json['LanguageName'],
      nativeName: json['NativeName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'LanguageCode': languageCode,
      'LanguageName': languageName,
      'NativeName': nativeName,
    };
  }
}
