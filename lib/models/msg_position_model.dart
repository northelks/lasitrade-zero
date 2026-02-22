import 'package:lasitrade/models/db/db_trade_message_model.dart';

class MsgPositionModel {
  final String symbol;
  final double closePrice;
  final int amount;
  final String positionId;

  final DBTradeMessageModel tradeMessage;

  MsgPositionModel({
    required this.symbol,
    required this.closePrice,
    required this.amount,
    required this.positionId,
    //
    required this.tradeMessage,
  });

  factory MsgPositionModel.fromTradeMessage(DBTradeMessageModel tradeMessage) {
    final symbolRegex = RegExp(r'(\w+):xnas');
    final closePriceRegex = RegExp(r'@ (\d+\.\d+)');
    final timeAtRegex = RegExp(r'value date (\d{2}-[A-Za-z]{3}-\d{4})');
    final positionIdRegex = RegExp(r'position id: (\d+)');
    final amountRegex = RegExp(r'You sold (\d+)');

    final symbolMatch = symbolRegex.firstMatch(tradeMessage.messageBody);
    final closePriceMatch =
        closePriceRegex.firstMatch(tradeMessage.messageBody);
    final timeAtMatch = timeAtRegex.firstMatch(tradeMessage.messageBody);
    final positionIdMatch =
        positionIdRegex.firstMatch(tradeMessage.messageBody);
    final amountMatch = amountRegex.firstMatch(tradeMessage.messageBody);

    if (symbolMatch == null ||
        closePriceMatch == null ||
        timeAtMatch == null ||
        positionIdMatch == null ||
        amountMatch == null) {
      throw FormatException('Message format is invalid');
    }

    return MsgPositionModel(
      symbol: symbolMatch.group(1)!,
      closePrice: double.parse(closePriceMatch.group(1)!),
      positionId: positionIdMatch.group(1)!,
      amount: int.parse(amountMatch.group(1)!),
      //
      tradeMessage: tradeMessage,
    );
  }
}
