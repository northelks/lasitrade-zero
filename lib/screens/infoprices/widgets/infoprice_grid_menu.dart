import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:lasitrade/getit.dart';
import 'package:lasitrade/models/db/db_instrument_model.dart';
import 'package:lasitrade/theme.dart';

class InfoPriceGridMenu extends StatefulWidget {
  final DBInstrumentModel instrument;
  final Function(bool value) onLoading;
  final Widget child;

  const InfoPriceGridMenu({
    super.key,
    required this.instrument,
    required this.onLoading,
    required this.child,
  });

  @override
  State<InfoPriceGridMenu> createState() => _InfoPriceGridMenuState();
}

class _InfoPriceGridMenuState extends State<InfoPriceGridMenu> {
  late String _pinWatchId;

  @override
  void initState() {
    super.initState();

    _pinWatchId = instVM.watchlistPinned().watchlistId;
  }

  @override
  Widget build(BuildContext context) {
    final pinned = widget.instrument.pinned;

    return ContextMenu(
      items: [
        MenuCheckbox(
          value: pinned,
          onChanged: (context, value) async {
            await instVM.pinInstrument(widget.instrument, !pinned);
          },
          child: Text('Pinned'),
        ),
        const MenuDivider(),
        MenuButton(
          leading: Text(
            '${widget.instrument.watchlistIds.where((e) => e != _pinWatchId).length}',
            style: TextStyle(
              fontSize: 10,
              color: AppTheme.clText05,
            ),
          ),
          subMenu: [
            for (var watchlist
                in instVM.watchlists.where((e) => e.name != 'Pinned'))
              MenuCheckbox(
                value: widget.instrument.watchlistIds
                    .contains(watchlist.watchlistId),
                onChanged: (context, value) async {
                  if (value) {
                    widget.instrument.watchlistIds.add(watchlist.watchlistId);
                  } else {
                    widget.instrument.watchlistIds
                        .remove(watchlist.watchlistId);
                  }

                  await instVM.updateInstrument(widget.instrument);
                  await instVM.reInstruments();

                  if (mounted) {
                    setState(() {});
                  }
                },
                child: Text(watchlist.name),
              ),
          ],
          child: Text('Watchlists'),
        ),
      ],
      child: widget.child,
    );
  }
}
