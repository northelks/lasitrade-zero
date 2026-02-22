@Deprecated('since 0.1.18+18')
class SaxoMessageModel {
  final String accountId;
  final DateTime dateTime;
  final bool isDiscardable;
  final String messageBody;
  final String messageHeader;
  final String messageId;
  final String messageType;

  final String? orderId;
  final String? positionId;
  final String? sourceOrderId;

  SaxoMessageModel({
    required this.accountId,
    required this.dateTime,
    required this.isDiscardable,
    required this.messageBody,
    required this.messageHeader,
    required this.messageId,
    required this.messageType,
    //
    required this.orderId,
    required this.positionId,
    required this.sourceOrderId,
  });

  factory SaxoMessageModel.fromJson(Map<String, dynamic> json) {
    return SaxoMessageModel(
      accountId: json['AccountId'],
      dateTime: DateTime.parse(json['DateTime']).toLocal(),
      isDiscardable: json['IsDiscardable'],
      messageBody: json['MessageBody'],
      messageHeader: json['MessageHeader'],
      messageId: json['MessageId'],
      messageType: json['MessageType'],
      //
      orderId: json['OrderId'],
      positionId: json['PositionId'],
      sourceOrderId: json['SourceOrderId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AccountId': accountId,
      'DateTime': dateTime.toUtc().toIso8601String(),
      'IsDiscardable': isDiscardable,
      'MessageBody': messageBody,
      'MessageHeader': messageHeader,
      'MessageId': messageId,
      'MessageType': messageType,
      'OrderId': orderId,
    };
  }
}
