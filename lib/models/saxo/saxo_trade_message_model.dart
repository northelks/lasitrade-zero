class SaxoTradeMessageModel {
  final DateTime dateTime;
  final String displayType;
  final String messageBody;
  final String messageHeader;
  final String messageId;
  final String messageType;

  SaxoTradeMessageModel({
    required this.dateTime,
    required this.displayType,
    required this.messageBody,
    required this.messageHeader,
    required this.messageId,
    required this.messageType,
  });

  // ---- TradeMessageType
  //+ Notification

  //+ PositionDepreciation
  // - Message to indicate that a position has depreciated beyond a limit as specified by MIFID II regulations. Only sent for configured client segments.

  //+ TradeConfirmation
  // 	- A very broad set of notifications related to orders and positions. For example: * An order has been placed * An order has expired *
  //  - An order has been (partially) filled * An order was cancelled * A position was stopped out (due to insufficient margin) * A position was placed

  factory SaxoTradeMessageModel.fromJson(Map<String, dynamic> json) {
    return SaxoTradeMessageModel(
      dateTime: DateTime.parse(json['LanguageCode']).toLocal(),
      displayType: json['DisplayType'],
      messageBody: json['MessageBody'],
      messageHeader: json['MessageHeader'],
      messageId: json['MessageId'],
      messageType: json['MessageType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DateTime': dateTime.toUtc().toIso8601String(),
      'DisplayType': displayType,
      'MessageBody': messageBody,
      'MessageHeader': messageHeader,
      'MessageId': messageId,
      'MessageType': messageType,
    };
  }
}
