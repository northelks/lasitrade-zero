import 'package:lasitrade/models/saxo/saxo_order_model.dart';
import 'package:lasitrade/models/saxo/saxo_position_model.dart';

class TradeModel {
  final int uic;

  final int amount;
  double op;
  double sl;
  final double sltl;

  SaxoOrderModel? order;
  SaxoPositionModel? position;

  // bool get isPlGood =>
  //     ((position?.profitLossOnTrade ?? 0.0) +
  //         (position?.tradeCostsTotal ?? 0.0)) >
  //     0;

  TradeModel({
    required this.uic,
    required this.amount,
    required this.op,
    required this.sl,
    required this.sltl,
    //
    this.order,
    this.position,
  });
}
