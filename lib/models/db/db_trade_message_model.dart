import 'package:postgres/postgres.dart';

class DBTradeMessageModel {
  final String tradeMessageId;
  final String messageHeader;
  final String messageId;
  final String messageType;
  final String? orderId;
  final String? positionId;
  final String? sourceOrderId;
  final String messageBody;
  final bool seen;
  final DateTime dateTime;

  DBTradeMessageModel({
    required this.tradeMessageId,
    required this.messageHeader,
    required this.messageId,
    required this.messageType,
    required this.orderId,
    required this.positionId,
    required this.sourceOrderId,
    required this.messageBody,
    required this.seen,
    required this.dateTime,
  });

  factory DBTradeMessageModel.fromRowResult(ResultRow row) {
    return DBTradeMessageModel(
      tradeMessageId: row.elementAt(0) as String,
      messageHeader: row.elementAt(1) as String,
      messageId: row.elementAt(2) as String,
      messageType: row.elementAt(3) as String,
      orderId: row.elementAt(4) as String?,
      positionId: row.elementAt(5) as String?,
      sourceOrderId: row.elementAt(6) as String?,
      messageBody: row.elementAt(7) as String,
      seen: row.elementAt(8) as bool,
      dateTime: (row.elementAt(9) as DateTime).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tradeMessageId': tradeMessageId,
      'messageHeader': messageHeader,
      'messageId': messageId,
      'messageType': messageType,
      'orderId': orderId,
      'positionId': positionId,
      'sourceOrderId': sourceOrderId,
      'messageBody': messageBody,
      'seen': seen,
      'dateTime': dateTime.toUtc().toIso8601String(),
    };
  }
}
