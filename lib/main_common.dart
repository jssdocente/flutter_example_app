import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/app_state.dart';
import 'app/common/logger.dart';
import 'app/config.dart';
import 'app/data/provider/api_service.dart';
import 'app/locator.dart';

void mainCommon({@required String flavour}) async {
  FlutterError.onError = (error) {
    logger.e(error.exceptionAsString());
    //Crashlytics.instance.recordFlutterError(error);
  };

  runZoned<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    //TODO: Activate CRASHLYTICS
    //Crashlytics.instance.enableInDevMode = true;
    //analytics = FirebaseAnalytics();

    final config = await AppConfig.forEnviroment(flavour);
    await setupLocator(Env.fromFlavour(flavour), config);

    appConfig = config;
    apiService = new APIService();
    locator.registerSingleton(apiService);

    final sharedPrefs = await SharedPreferences.getInstance();
    locator.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

    //TODO: enlazar algun forma de subir los logs al cloud

    Intl.defaultLocale = 'es-ES';
    initializeDateFormatting("es-ES");

    //Realizamos la carga básica de la aplicacion, en principio obtener el usuario
    var appstate = await AppState.load();
    locator.registerSingleton(appstate);

    //finalizamos la carga restante de la app. Esto lo realizamos así, para poder tener registrado el AppState en locator, y como mínimo ya tener cargado el usuario
    appstate.finishLoadState();

    //TODO: PUSHNOTIFICATION-ENABLED
    //await PushNotificationsManager().init();

    //subcribe a notifications-topics by user-config
    //await appstate?.user?.subscribeToNotificationsTopics();

    runApp(
      MyApp(
        title: config.appTitle,
//        firebaseMessaging: firebaseMessaging,
      ),
    );
  }, onError: (error, stack) {
    logger.e(error, null, stack);
    //return Crashlytics.instance.recordError(error, stack);
    return null;
  });
}

//void initAppState(){
//
//  AppState.fromSaved();
//
//}
