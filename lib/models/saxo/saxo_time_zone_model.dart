class SaxoTimeZoneModel {
  final String timeZoneId;
  final String zoneName;
  final String displayName;
  final String timeZoneAbbreviation;
  final String timeZoneOffset;

  SaxoTimeZoneModel({
    required this.timeZoneId,
    required this.zoneName,
    required this.displayName,
    required this.timeZoneAbbreviation,
    required this.timeZoneOffset,
  });

  factory SaxoTimeZoneModel.fromJson(Map<String, dynamic> json) {
    return SaxoTimeZoneModel(
      timeZoneId: json['TimeZoneId'],
      zoneName: json['ZoneName'],
      displayName: json['DisplayName'],
      timeZoneAbbreviation: json['TimeZoneAbbreviation'],
      timeZoneOffset: json['TimeZoneOffset'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TimeZoneId': timeZoneId,
      'ZoneName': zoneName,
      'DisplayName': displayName,
      'TimeZoneAbbreviation': timeZoneAbbreviation,
      'TimeZoneOffset': timeZoneOffset,
    };
  }
}
