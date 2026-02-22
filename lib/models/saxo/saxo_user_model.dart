class SaxoUserModel {
  final String userId;
  final String name;
  final String language;
  final String culture;
  final int timeZoneId;
  //
  final String userKey;
  final String clientKey;
  //
  final String lastLoginStatus;
  final DateTime lastLoginTime;
  //
  final List<String> legalAssetTypes;

  /* - - - 
    IF FALSE

    User didn't accept the terms for receiving Market Data yet.
    SIM users cannot do this, but if your app will request Price data on Live, make sure you ask the user to enable Market Data in SaxoTraderGO via 'Account - Other - OpenAPI data access'.
    Otherwise the user might blaim your app.. ;-)
  - - - */
  final bool marketDataViaOpenApiTermsAccepted;

  SaxoUserModel({
    required this.userId,
    required this.name,
    required this.language,
    required this.culture,
    required this.timeZoneId,
    //
    required this.userKey,
    required this.clientKey,
    //
    required this.lastLoginStatus,
    required this.lastLoginTime,
    //
    required this.legalAssetTypes,
    required this.marketDataViaOpenApiTermsAccepted,
  });

  factory SaxoUserModel.fromJson(Map<String, dynamic> json) {
    return SaxoUserModel(
      userId: json['UserId'],
      name: json['Name'],
      language: json['Language'],
      culture: json['Culture'],
      timeZoneId: json['TimeZoneId'],
      //
      userKey: json['UserKey'],
      clientKey: json['ClientKey'],
      //
      lastLoginStatus: json['LastLoginStatus'],
      lastLoginTime: DateTime.parse(json['LastLoginTime']).toLocal(),
      //
      legalAssetTypes: List<String>.from(json['LegalAssetTypes']),
      marketDataViaOpenApiTermsAccepted:
          json['MarketDataViaOpenApiTermsAccepted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserId': userId,
      'Name': name,
      'Language': language,
      'Culture': culture,
      'TimeZoneId': timeZoneId,
      //
      'UserKey': userKey,
      'ClientKey': clientKey,
      //
      'LastLoginStatus': lastLoginStatus,
      'LastLoginTime': lastLoginTime.toUtc().toIso8601String(),
      //
      'LegalAssetTypes': legalAssetTypes,
      'MarketDataViaOpenApiTermsAccepted': marketDataViaOpenApiTermsAccepted,
    };
  }
}
