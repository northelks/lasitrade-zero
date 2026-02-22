import 'package:tray_manager/tray_manager.dart';

class AppTray extends TrayListener {
  Future<void> init() async {
    trayManager.addListener(this);

    await trayManager.setIcon('assets/images/icon_tray2.png');

    await reMenu();
  }

  @override
  void onTrayIconMouseDown() {
    trayManager.popUpContextMenu();
  }

  Future<void> reMenu() async {
    // final yaml = loadYaml(await rootBundle.loadString('pubspec.yaml'));

    await trayManager.setContextMenu(Menu(
      items: [
        // MenuItem(
        //   key: 'show_window',
        //   label: 'Show Window',
        //   toolTip: 'test333',
        //   onClick: (menuItem) {
        //     print(1);
        //   },
        // ),
        // MenuItem.separator(),
        // MenuItem(
        //   key: 'version',
        //   label: 'v${yaml!['version']}',
        //   disabled: true,
        // ),
        // MenuItem.separator(),
        MenuItem(
          key: 'exit_app',
          label: 'Exit App',
          // onClick: (menuItem) async {
          //   await trayManager.setIcon('assets/images/icon_tray.png');
          // },
        ),
      ],
    ));
  }
}

final appTray = AppTray();
