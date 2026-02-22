import 'package:lasitrade/getit.dart';
import 'package:lasitrade/models/saxo/saxo_account_model.dart';
import 'package:lasitrade/models/saxo/saxo_balance_model.dart';
import 'package:lasitrade/models/saxo/saxo_client_model.dart';
import 'package:lasitrade/models/saxo/saxo_user_access_rights.dart';
import 'package:lasitrade/models/saxo/saxo_user_model.dart';

class UserService {
  Future<SaxoUserModel?> getUser() async {
    final res = await dioCl.get('/port/v1/users/me');
    if (res.statusCode == 200) {
      return SaxoUserModel.fromJson(res.data);
    }

    return null;
  }

  Future<bool> updateUser({
    String? language,
    String? culture,
    String? timeZoneId,
  }) async {
    assert(language != null && culture != null && timeZoneId != null);

    final res = await dioCl.patch(
      '/port/v1/users/me',
      data: {
        if (language != null) 'Language': language,
        if (culture != null) 'Culture': culture,
        if (timeZoneId != null) 'TimeZoneId': timeZoneId,
      },
    );

    return res.statusCode == 200 || res.statusCode == 204;
  }

  Future<SaxoClientModel?> getClient() async {
    final res = await dioCl.get('/port/v1/clients/me');
    if (res.statusCode == 200) {
      return SaxoClientModel.fromJson(res.data);
    }

    return null;
  }

  Future<List<SaxoAccountModel>> getAccounts() async {
    final res = await dioCl.get('/port/v1/accounts/me');
    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(res.data['Data'])
          .map((it) => SaxoAccountModel.fromJson(it))
          .toList();
    }

    return [];
  }

  Future<SaxoAccountModel> getAccount() async {
    return (await getAccounts()).first;
  }

  Future<SaxoBalanceModel> getBalance() async {
    final res = await dioCl.get(
      '/port/v1/balances?ClientKey=${appVM.clientKey}&AccountKey=${appVM.accountKey}',
    );

    return SaxoBalanceModel.fromJson(res.data);
  }

  Future<SaxoUserAccessRights?> getAccessRights() async {
    final res = await dioCl.get('/root/v1/user');
    if (res.statusCode == 200) {
      return SaxoUserAccessRights.fromJson(res.data);
    }

    return null;
  }

  //+ FullTradingAndChat

  Future<bool> reqFullTradingAndChat() async {
    final res = await dioCl.patch('/root/v1/sessions/capabilities', data: {
      'TradeLevel': 'FullTradingAndChat',
    });

    return res.statusCode == 202;
  }

  Future<bool> reqOrdersOnly() async {
    final res = await dioCl.patch('/root/v1/sessions/capabilities', data: {
      'TradeLevel': 'OrdersOnly',
    });

    return res.statusCode == 202;
  }

  Future<bool> isFullTradingAndChat() async {
    final res = await dioCl.get('/root/v1/sessions/capabilities');

    if (res.statusCode == 200) {
      return res.data['TradeLevel'] == 'FullTradingAndChat';
    }

    return false;
  }
}
