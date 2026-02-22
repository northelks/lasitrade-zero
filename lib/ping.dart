import 'package:lasitrade/getit.dart';
import 'package:lasitrade/utils/pref_utils.dart';

Future<void> pingLoop() async {
  while (true) {
    final dt = await fnPrefGetRefreshTokenExpired();
    if (dt != null) {
      final mins = dt.difference(DateTime.now()).inMinutes;
      if (mins <= 5) {
        await authServ.refreshTokens();
      }
    }

    await Future.delayed(const Duration(seconds: 30));
  }
}
