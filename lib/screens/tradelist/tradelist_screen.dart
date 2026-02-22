import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' hide Colors;

import 'package:lasitrade/screens/tradelist/widgets/trade_item.dart';
import 'package:lasitrade/screens/tradelist/widgets/empty_pre_order_item.dart';
import 'package:lasitrade/viewmodels/trade_viewmodel.dart';
import 'package:lasitrade/getit.dart';
import 'package:lasitrade/viewmodels/infoprice_viewmodel.dart';
import 'package:lasitrade/viewmodels/instrument_viewmodel.dart';

class TradeListScreen extends StatefulWidget {
  const TradeListScreen({super.key});

  @override
  State<TradeListScreen> createState() => _TradeListScreenState();
}

class _TradeListScreenState extends State<TradeListScreen> {
  late final PopoverController _ctrlTrade;

  @override
  void initState() {
    _ctrlTrade = PopoverController();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    context.watch<InstrumentViewModel>();
    context.watch<InfoPriceViewModel>();
    context.watch<TradeViewModel>();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _ctrlTrade.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int ln = tradeVM.positions.length + tradeVM.orders.length;

    final preTrade = tradeVM.buildPreTrade(instVM.currUic);
    if (preTrade != null) {
      ln += 1;
    }

    return Row(
      children: [
        for (var position in tradeVM.positions)
          TradeItem(trade: tradeVM.buildPositionTrade(position)),
        for (var order in tradeVM.orders)
          TradeItem(trade: tradeVM.buildOrderTrade(order)),
        if (preTrade != null) TradeItem(trade: preTrade),
        if (ln < 6)
          for (var _ in List.generate(6 - ln, (i) => i)) EmptyPreOrderItem(),
      ],
    );
  }
}
