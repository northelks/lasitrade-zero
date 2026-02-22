import 'package:audioplayers/audioplayers.dart';
import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/widgets/buttons/mouse_button.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:lasitrade/theme.dart';
import 'package:lasitrade/context.dart';

//+ toast

ToastOverlay fnShowToast({
  required String text,
  String? title,
  int duration = 5,
  VoidCallback? onTap,
}) {
  Widget buildToast(BuildContext context, ToastOverlay overlay) {
    Widget wid = Basic(
      title: title != null
          ? Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.clYellow08,
              ),
            )
          : null,
      subtitle: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          color: AppTheme.clText,
        ),
      ),
    );

    if (onTap != null) {
      wid = AppMouseButton(
        onTap: () {
          overlay.close();
          onTap();
        },
        child: wid,
      );
    }

    return SurfaceCard(
      borderColor: Colors.white,
      borderWidth: 1,
      child: wid,
    );
  }

  return showToast(
    context: appContext,
    builder: buildToast,
    showDuration: Duration(seconds: duration),
    location: ToastLocation.bottomRight,
  );
}

void fnShowInfoToast({
  required String text,
}) async {
  fnShowToast(title: 'Info', text: text);
}

//+ alert

Future<bool?> fnShowQuestion({
  required String text,
  String? title,
  Color? titleColor,
}) async {
  return await showDialog(
    context: appContext,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title ?? 'Question',
          style: TextStyle(color: titleColor),
        ),
        content: Text(text),
        actions: [
          OutlineButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          PrimaryButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}

Future<bool?> fnShowInfoDialog({
  required String title,
  required String text,
  double? width,
  double? heigt,
}) async {
  return await showDialog(
    context: appContext,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: width,
          height: heigt,
          child: Text(text),
        ),
        actions: [
          PrimaryButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}

//~

Future<void> fnYN(BuildContext context, String text) async {
  late OverlayCompleter popup;

  popup = showPopover(
    context: context,
    alignment: Alignment.center,
    builder: (_) => ModalContainer(
      child: SizedBox(
        width: 200,
        height: 100,
        child: Column(
          children: [
            Expanded(
              child: Text(text),
            ),
            Row(
              children: [
                PrimaryButton(
                  child: const Text('No'),
                  onPressed: () {
                    popup.remove();
                  },
                ),
                15.w,
                PrimaryButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    popup.remove();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

//+ sound

bool _notifSoundLock = false;
Future<void> fnNotifSound() async {
  if (!_notifSoundLock) {
    _notifSoundLock = true;
    await AudioPlayer().play(AssetSource(
      'sounds/splash-effect-229315.mp3',
    ));

    await Future.delayed(500.mlsec);
    _notifSoundLock = false;
  }
}
