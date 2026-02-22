import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:lasitrade/constants.dart';

import 'package:lasitrade/getit.dart';
import 'package:lasitrade/mouse_handler.dart';
import 'package:lasitrade/route.dart';

Future<void> setupHotKeys() async {
  Map<LogicalKeyboardKey, VoidCallback> hotkeys = {
    //~
    LogicalKeyboardKey.contextMenu: () {
      tradeVM.doPushTrade?.call();
    },

    // ESC
    LogicalKeyboardKey.escape: () {
      for (var popover in tradeVM.ctrlTradePopovers) {
        popover.close(true);
      }

      if (AppMouseHandlerStatus.isRightBtn) {
        AppMouseHandlerStatus.isRightBtn = false;
        return;
      }

      AppRoute.goPopupBack();

      return;
    },
  };

  Map<LogicalKeyboardKey, VoidCallback> ctrlHotkeys = {
    // CTRL + \
    LogicalKeyboardKey.backslash: () {
      instVM.pinInstrument(
        instVM.currInstrument,
        !instVM.currInstrument.pinned,
      );

      return;
    },
  };

  Map<LogicalKeyboardKey, VoidCallback> metaHotkeys = {
    // META + P
    LogicalKeyboardKey.keyP: () {
      if (AppRoute.currPopup == AppRoute.ppSearch) {
        if (searchVM.searchTab == 1) {
          if (searchVM.fWatch == 0) {
            searchVM.fWatch = 1;
          } else if (searchVM.fWatch == 1 && searchVM.fScreen == 0) {
            searchVM.fWatch = 1;
            searchVM.fScreen = 1;
          } else {
            searchVM.fWatch = 0;
            searchVM.searchTab = 0;
            searchVM.fScreen = 0;
          }
        } else {
          searchVM.searchTab = 1;
        }

        searchVM.notify();

        return;
      }

      if (AppRoute.currPopup != AppRoute.ppSearch) {
        searchVM.searchTab = 0;

        AppRoute.goPopupTo(
          AppRoute.ppSearch,
          alignment: Alignment.topCenter,
          offset: Offset(0, 0),
        );

        return;
      }
    },

    // META + ARROW_LEFT
    LogicalKeyboardKey.arrowLeft: () {
      if (AppRoute.currPopup == AppRoute.ppSearch) {
        if (!searchVM.searchFocusNode.hasFocus) {
          searchVM.searchFocusNode.requestFocus();

          return;
        }

        return;
      }
    },

    // META + \
    LogicalKeyboardKey.backslash: () {
      instVM.currWatchlist =
          instVM.currWatchlist == 'Pinned' ? 'On Desk' : 'Pinned';
      instVM.currWatchlistLimit = instVM.currWatchlist == 'On Desk' ? 50 : 0;

      instVM.notify();

      return;
    },

    // META + 1
    LogicalKeyboardKey.digit1: () async {
      if (appVM.tab != cstTabs['home']) {
        appVM.tab = cstTabs['home']!;
        appVM.notify();
      }
    },

    // META + 2
    LogicalKeyboardKey.digit2: () async {
      if (appVM.tab != cstTabs['reports']) {
        appVM.tab = cstTabs['reports']!;
        appVM.notify();
      }
    },

    // META + 3
    LogicalKeyboardKey.digit3: () async {
      if (appVM.tab != cstTabs['watchlists']) {
        appVM.tab = cstTabs['watchlists']!;
        appVM.notify();
      }
    },

    // META + 4
    LogicalKeyboardKey.digit4: () async {
      if (appVM.tab != cstTabs['messages']) {
        appVM.tab = cstTabs['messages']!;
        appVM.notify();
      }
    },

    // META + 0
    LogicalKeyboardKey.digit0: () async {
      if (appVM.tab != cstTabs['settings']) {
        appVM.tab = cstTabs['settings']!;
        appVM.notify();
      }
    },
  };

  // IMPL

  await hotKeyManager.unregisterAll();

  for (var hotkey in hotkeys.entries) {
    await hotKeyManager.register(
      HotKey(
        key: hotkey.key,
        modifiers: [],
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => hotkey.value.call(),
    );
  }

  for (var ctrlHotkey in ctrlHotkeys.entries) {
    await hotKeyManager.register(
      HotKey(
        key: ctrlHotkey.key,
        modifiers: [HotKeyModifier.control],
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => ctrlHotkey.value.call(),
    );
  }

  for (var metaHotkey in metaHotkeys.entries) {
    await hotKeyManager.register(
      HotKey(
        key: metaHotkey.key,
        modifiers: [HotKeyModifier.meta],
        scope: HotKeyScope.inapp,
      ),
      keyDownHandler: (_) => metaHotkey.value.call(),
    );
  }
}
