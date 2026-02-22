class SaxoExchangeModel {
  final String name;
  final String exchangeId;
  final String countryCode;
  final String currency;
  //
  final bool allDay;
  final List<ExchangeSessionModel> exchangeSessions;
  //
  final String? isoMic;
  final String? priceSourceName;
  final String mic;
  final String? operatingMic;
  final int timeZone;
  final String timeZoneAbbreviation;
  final String timeZoneOffset;

  SaxoExchangeModel({
    required this.name,
    required this.exchangeId,
    required this.countryCode,
    required this.currency,
    //
    required this.allDay,
    required this.exchangeSessions,
    //
    required this.isoMic,
    required this.priceSourceName,
    required this.mic,
    required this.operatingMic,
    required this.timeZone,
    required this.timeZoneAbbreviation,
    required this.timeZoneOffset,
  });

  factory SaxoExchangeModel.fromJson(Map<String, dynamic> json) {
    return SaxoExchangeModel(
      name: json['Name'],
      exchangeId: json['ExchangeId'],
      countryCode: json['CountryCode'],
      currency: json['Currency'],
      //
      allDay: json['AllDay'],
      exchangeSessions:
          List<Map<String, dynamic>>.from(json['ExchangeSessions'])
              .map((it) => ExchangeSessionModel.fromJson(it))
              .toList(),
      //
      isoMic: json['IsoMic'],
      priceSourceName: json['PriceSourceName'],
      mic: json['Mic'],
      operatingMic: json['OperatingMic'],
      timeZone: json['TimeZone'],
      timeZoneAbbreviation: json['TimeZoneAbbreviation'],
      timeZoneOffset: json['TimeZoneOffset'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'ExchangeId': exchangeId,
      'CountryCode': countryCode,
      'Currency': currency,
      'PriceSourceName': priceSourceName,
      //
      'AllDay': allDay,
      'ExchangeSessions': exchangeSessions.map((it) => it.toJson()).toList(),
      //
      'IsoMic': isoMic,
      'Mic': mic,
      'OperatingMic': operatingMic,
      'TimeZone': timeZone,
      'TimeZoneAbbreviation': timeZoneAbbreviation,
      'TimeZoneOffset': timeZoneOffset
    };
  }
}

class ExchangeSessionModel {
  final DateTime startTime;
  final DateTime endTime;
  final String state;

  ExchangeSessionModel({
    required this.startTime,
    required this.endTime,
    required this.state,
  });

  factory ExchangeSessionModel.fromJson(Map<String, dynamic> json) {
    return ExchangeSessionModel(
      startTime: DateTime.parse(json['StartTime']).toLocal(),
      endTime: DateTime.parse(json['EndTime']).toLocal(),
      state: json['State'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StartTime': startTime.toUtc().toIso8601String(),
      'EndTime': endTime.toUtc().toIso8601String(),
      'State': 'Closed'
    };
  }
}
