import 'package:flutter/material.dart';

class RootMenu extends StatelessWidget {
  final Widget child;

  const RootMenu({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PlatformMenuBar(
      menus: <PlatformMenuItem>[
        PlatformMenu(
          label: 'Lasitrade',
          menus: <PlatformMenuItem>[
            PlatformMenuItemGroup(
              members: <PlatformMenuItem>[
                // PlatformMenuItem(
                //   label: 'Instruments',
                //   onSelected: () {
                //     showDialog(
                //       context: context,
                //       builder: (_) => InstrumentDialog(),
                //     );
                //   },
                // ),
                // PlatformMenuItem(
                //   label: 'Watchlists',
                //   onSelected: () {
                //     showDialog(
                //       context: context,
                //       builder: (_) => WatchlistDialog(),
                //     );
                //   },
                // ),
              ],
            ),
            PlatformMenuItemGroup(
              members: <PlatformMenuItem>[
                PlatformMenuItem(
                  label: 'About',
                  onSelected: () {},
                ),
              ],
            ),
            const PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.quit,
            ),
          ],
        ),
        // PlatformMenu(
        //   label: 'Watchlist',
        //   menus: <PlatformMenuItem>[
        //     PlatformMenuItemGroup(
        //       members: <PlatformMenuItem>[
        //         PlatformMenuItem(
        //           onSelected: _showWatchlistDialog,
        //           label: 'All Watchlists',
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
      ],
      child: child,
    );
  }
}
