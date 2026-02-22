import 'package:get_it/get_it.dart';
import 'package:lasitrade/services/crash_service.dart';
import 'package:lasitrade/services/saxo/realtime_service.dart';

import 'package:lasitrade/utils/net_utils.dart';
import 'package:lasitrade/services/auth_service.dart';
import 'package:lasitrade/services/psql_service.dart';
import 'package:lasitrade/services/saxo/basic_service.dart';
import 'package:lasitrade/services/saxo/instrument_service.dart';
import 'package:lasitrade/services/saxo/report_service.dart';
import 'package:lasitrade/services/saxo/trade_service.dart';
import 'package:lasitrade/services/saxo/user_service.dart';
import 'package:lasitrade/services/web_service.dart';
import 'package:lasitrade/viewmodels/app_viewmodel.dart';
import 'package:lasitrade/viewmodels/hist_viewmodel.dart';
import 'package:lasitrade/viewmodels/infoprice_viewmodel.dart';
import 'package:lasitrade/viewmodels/instrument_viewmodel.dart';
import 'package:lasitrade/viewmodels/report_viewmodel.dart';
import 'package:lasitrade/viewmodels/search_viewmodel.dart';
import 'package:lasitrade/viewmodels/trade_viewmodel.dart';

final GetIt _getIt = GetIt.instance;

Future<void> setupGetIt() async {
  //+ vms
  _getIt.registerLazySingleton<AppViewModel>(() => AppViewModel());
  _getIt
      .registerLazySingleton<InstrumentViewModel>(() => InstrumentViewModel());
  _getIt.registerLazySingleton<InfoPriceViewModel>(() => InfoPriceViewModel());
  _getIt.registerLazySingleton<ReportViewModel>(() => ReportViewModel());
  _getIt.registerLazySingleton<SearchViewModel>(() => SearchViewModel());
  _getIt.registerLazySingleton<TradeViewModel>(() => TradeViewModel());
  _getIt.registerLazySingleton<HistViewModel>(() => HistViewModel());

  //+ services
  _getIt.registerLazySingleton<BasicService>(() => BasicService());
  _getIt.registerLazySingleton<AuthService>(() => AuthService());
  _getIt.registerLazySingleton<PsqlService>(() => PsqlService());
  _getIt.registerLazySingleton<WebService>(() => WebService());
  _getIt.registerLazySingleton<CrashService>(() => CrashService());
  _getIt.registerLazySingleton<RealtimeService>(() => RealtimeService());

  //+ saxo
  _getIt.registerLazySingleton<UserService>(() => UserService());
  _getIt.registerLazySingleton<InstrumentService>(() => InstrumentService());
  _getIt.registerLazySingleton<TradeService>(() => TradeService());
  _getIt.registerLazySingleton<ReportService>(() => ReportService());

  //+ utils
  _getIt.registerLazySingleton<DioClient>(() => DioClient());
}

final DioClient dioCl = _getIt<DioClient>();

final AppViewModel appVM = _getIt<AppViewModel>();
final InstrumentViewModel instVM = _getIt<InstrumentViewModel>();
final InfoPriceViewModel infoPriceVM = _getIt<InfoPriceViewModel>();
final ReportViewModel reportVM = _getIt<ReportViewModel>();
final SearchViewModel searchVM = _getIt<SearchViewModel>();
final TradeViewModel tradeVM = _getIt<TradeViewModel>();
final HistViewModel histVM = _getIt<HistViewModel>();

final BasicService basicServ = _getIt<BasicService>();
final AuthService authServ = _getIt<AuthService>();
final PsqlService psqlServ = _getIt<PsqlService>();
final WebService webServ = _getIt<WebService>();
final CrashService crashServ = _getIt<CrashService>();

final UserService userServ = _getIt<UserService>();
final InstrumentService instServ = _getIt<InstrumentService>();
final TradeService tradeServ = _getIt<TradeService>();
final ReportService reportServ = _getIt<ReportService>();

final RealtimeService rtServ = _getIt<RealtimeService>();
