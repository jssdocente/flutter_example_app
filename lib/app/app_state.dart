import 'dart:convert';
import 'package:apnapp/app/data/provider/ConectivityProvider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/event_manager.dart';
import 'common/logger.dart';
import 'config.dart';
import 'domain/model/_models.dart';
import 'locator.dart';


class AppState {
  static const String appstateKey = 'appstate';
  static const String keyUserLogged = 'userlogged';
  static const String keyJournalStarted = 'journalStarted';
  static const String keyGeneral = 'generalState';

  Usuario _user;
  _GeneralState _generalState;

  SharedPreferences _sp;
  bool _initializedApp = false;

  //Propertys-states
  ConnectivityStatus _connectivityStatus = ConnectivityStatus.Offline;

  //internal
  VoidCallback _callGeneralStateChanged;

  AppState._() {
    _callGeneralStateChanged = _updateGeneralState;
    locator<ConnectivityService>().subscribe().listen((result) {
      _connectivityStatus = result;
      logger.d("ConnectivityStatus: ${result}");
    });
  }

  //static like-constructor allow async
  static Future<AppState> load() async {
    AppState st = new AppState._();

    logger.i("AppState.loadBasic ----- init");

    //Load GeneralState
    try {
      var data = AppState.loadObject(keyGeneral);
      if (data != null) {
        st._generalState = data;
        st._generalState._updated = st._callGeneralStateChanged;
      }
      else
        st._generalState = new _GeneralState(callback: st._callGeneralStateChanged);
    } catch (ex) {
      logger.e(ex);
    }

    //Load Usuario
    try {
      var data = AppState.loadObject(keyUserLogged);
      if (data != null)
        st._user = Usuario.fromJson(data);
      else
        st._user = null;
    } catch (ex) {
      logger.e(ex);
    }
    logger.i("AppState. User-logged ${st._user != null ? st._user.toString() : 'no-saved. return null'}");

    logger.v("AppState.loadBasic ----- end");

    return st;
  }

  void finishLoadState() async {
    logger.i("AppState.finishloadState ----- init");

    // if (_user != null) {
    //   //load notificaciones from BD ==> La BD dependen del usuario, sin usuario no se puede cargar.
    //   _ntfcState = await NotificationsState.load();
    // } else {
    //   _ntfcState = await NotificationsState.loadNoBD();
    // }

    logger.i("AppState.finishloadState ----- end");
  }

  void executeActionsAfterLogin() {}

  //Indica que la app está inicializada completamente.
  void setInitializedApp() {
    _initializedApp = true;
  }


  //PROPERTYS-GET SIMPLES
  bool get HasInternetConnection => !(_connectivityStatus == ConnectivityStatus.Offline);

  ConnectivityStatus get ConnectivityState => _connectivityStatus;

  //PROPERTYES OBJETS
  _GeneralState get general => _generalState;
  Usuario get user => _user;

  bool get hasUser => _user!=null;
  bool get isAppInitialized => _initializedApp;


  void AssignLoggedUser(Usuario user) {
    assert(user != null);
    _user = user;
    AppState.saveObject(keyUserLogged, user);
  }

  ///Borra las preferencias del usuario, y la variable de estado
  void ResetUser() {
    _user = null;
    AppState.clearKey(keyUserLogged);
    locator<EventManager>().closeChannel(EventChannel.Notificacion);

    //Tambien necesito borrar todas las notificaciones, estas son para el usuario que está logado
  }

  //Guarda el estado general cuando se produce un cambio en el mismo.
  void _updateGeneralState() {
    try {
      AppState.saveObject(keyGeneral, _generalState);
    } catch (ex) {
      logger.e("Err try save general-state",ex);
    }
  }

  static String generateKey(String key) {
    return '${PreferencesConfig.appkey}_${key}_key';
  }

  static dynamic loadObject(String objectKey, {dynamic defaultObject = null}) {
    var sp = locator<SharedPreferences>();
    String key = generateKey(objectKey);

    try {
      if (!sp.containsKey(key)) return defaultObject;

      String dataJson = sp.getString(key);
      if (dataJson.isEmpty) return defaultObject;

      return jsonDecode(dataJson);
    } catch (ex) {
      logger.e("Error AppState.loadObject", ex);
      clearKey(key);
      return null;
    }
  }

  static List<dynamic> loadObjectList(String objectKey, {List<dynamic> defaultList = null}) {
    var sp = locator<SharedPreferences>();

    try {
      String key = generateKey(objectKey);
      if (!sp.containsKey(key)) return defaultList;

      List<String> listDataJson = sp.getStringList(key);
      if (listDataJson.isEmpty) return defaultList;

      return listDataJson.map((obj) => jsonDecode(obj)).toList();
    } catch (ex) {
      logger.e("Error AppState.loadObjectList", ex);
      return null;
    }
  }

  static void saveObject(String objectKey, dynamic object) {
    var sp = locator<SharedPreferences>();

    try {
      sp.setString(generateKey(objectKey), jsonEncode(object));
    } catch (ex) {
      logger.e("Error AppState.saveObject. key=$objectKey", ex);
      return null;
    }
  }

  static void clearKey(String objectKey) {
    var sp = locator<SharedPreferences>();

    String key = generateKey(objectKey);
    try {
      if (sp.containsKey(key)) sp.setString(key, "");
    } catch (ex) {
      logger.e("Error AppState.clearKey. key=$objectKey", ex);
      return null;
    }
  }

  static void saveObjectList(String objectKey, List<dynamic> objectList) {
    var sp = locator<SharedPreferences>();

    try {
      List<String> serialized = objectList.map((obj) => jsonEncode(obj)).toList();
      sp.setStringList(generateKey(objectKey), serialized);
    } catch (ex) {
      logger.e("Error AppState.saveObject. key=$objectKey", ex);
      return null;
    }
  }

  }

class _GeneralState {

  VoidCallback _updated;

  _GeneralState({VoidCallback callback}) {
    _updated = callback;
  }

  bool _gpsPositionAllowed = false;

  bool get GpsPositionAllowed => _gpsPositionAllowed;

  set GpsPositionAllowed(bool value) {
    if (value != _gpsPositionAllowed) {
      _gpsPositionAllowed = value;
      _updated.call();
    }
  }

}
