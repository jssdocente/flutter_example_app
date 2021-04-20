import 'dart:convert';
import 'dart:io';

import 'package:apnapp/app/common/logger.dart';
import 'package:apnapp/app/config.dart';
import 'package:apnapp/app/domain/commands/_commands.dart';
import 'package:apnapp/app/domain/fails/_fails.dart';
import 'package:apnapp/app/domain/model/_models.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api.dart';

class APIService {
  APIService() {
    _apiAuth = API(hostUrl: appConfig.baseUrlAuth);
    _apiResource = API(hostUrl: appConfig.baseUrlResource);
    _httpAuthDio = _configHttpAuthDio(_apiAuth);
    _httpDio = _configHttpDio(_apiResource);
  }

  API _apiAuth, _apiResource;
  Dio _httpAuthDio;
  Dio _httpDio;

  String _token;

  set token(String token) {
    _token = token;
  }

  String get token => _token;

  Dio get httpDio => _httpDio;

  Dio get httpAuthDio => _httpAuthDio;

    Future<dynamic> getTokenAccess(data) async {
    try {
      final resp = await _httpDio.post('token/', data: json.encode(data));

      if (resp.statusCode == 200) {
        return json.decode(resp.data);
      }
    } on DioError catch (e) {
      _logError(e);
      rethrow;
    }
  }

  Future<dynamic> signIn(String username, String pass) async {
    try {
      var data = {'EmailOrUserName': username, 'password': pass};
      final Response resp = await _httpAuthDio.post('account/login', data: json.encode(data));

      if (resp.statusCode == 200) {
        return resp.data;
      } else if (resp.statusCode == 500) {
        logger.e('Request USUARIO/CONTRASEÑA NO VÁLIDO. [${resp.requestOptions } status-code:${resp.statusCode}]');
        throw SignInUserPassNoValidException();
      // ignore: lines_longer_than_80_chars
      } else {
        logger.e('Request status-code no-valid. [${resp.requestOptions} status-code:${resp.statusCode}]');
        throw SignInNoValidException();
      }
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response.statusCode == 500) throw SignInUserPassNoValidException();
      }
      //_logError(e);
      throw e;
    }
  }

  Future<bool> changePass(String username, String oldpass, String newpass) async {
    try {
      var data = {'UserId': username, 'OldPassword': oldpass, 'NewPassword': newpass};

      final options = Options()
      ..headers = {'Authorization': 'Bearer $_token'};

      await _httpAuthDio.post('account/UpdateUserPassword', data: json.encode(data),options: options);

      return true;

    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response.statusCode >= 400 && e.response.statusCode<500) {
          throw const ChangeUserPasswordFail('No autorizado');
        }

        if (e.response.toString().toUpperCase().contains('INCORRECT PASSWORD')) {
          throw const ChangeUserPasswordFail('Contraseña actual incorrecta');
        }

        throw ChangeUserPasswordFail(e.response?.toString());
      }

      //_logError(e);
      throw ChangeUserPasswordFail(e.response?.statusMessage);
    }
  }


  ///Este metodo no se usa. Logout es simplemente borrar los tokets del Storage.
  Future<dynamic> signOut(String userId) async {
    throw UnimplementedError();
  }



  Future<dynamic> requestPost(Endpoint endpoint, CommandBase command) async {
    try {
      final uri = _apiResource.endpointUriCommand(endpoint,cmd: command);

      var data = command.toJson();

      final options = Options()
        ..headers = {'Authorization': 'Bearer $_token'};

      var resp = await _httpAuthDio.post(uri.toString(), data: json.encode(data),options: options);

      return resp.data;

    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response.statusCode >= 400 && e.response.statusCode<500) {
          throw const HttpRequestError('No autorizado');
        }

        if (e.response.toString().toUpperCase().contains('INCORRECT PASSWORD')) {
          throw const HttpRequestError('Contraseña actual incorrecta');
        }

        throw HttpRequestError(e.response?.toString());
      }

      //_logError(e);
      throw HttpRequestError(e.response?.statusMessage ?? "Timeout");
    }
  }



  /*Future<dynamic> callGetLastMovements(Endpoint endpoint,
      {int socioId = null, Map<String, dynamic> params = null}) async {
    int socId = socioId;

    if (_appState==null) {
      _appState = locator<AppState>();
    }

    if (socId == null && _appState.user != null) {
      socioId = _appState.user.personalId;
    }

    if (socioId == null) {
      logger.e('Assert-validations: PersonalId or EjercicioId are nulls');
      throw EjercioOrSocioNotEspecifiedException();
    }

    if (params == null) {
      params = Constants.LastMovementsOptions;
    }

    final uri = _apiResource.endpointUriSocio(endpoint, socioId);

    Options options = Options();
    options.headers = {"Authorization": "Bearer $_token"};
    options.method = "GET";

    try {
      Response resp = await _httpDio.request(uri.toString(), queryParameters: params, options: options);

      return resp.data;
    } on DioError catch (e) {
      //Logica para Token-expired
      //_logError(e);
      throw e;
    }
  }*/

  Future<dynamic> callGetMaster(Endpoint endpoint, {String id = null, Map<String, dynamic> data = null}) async {

    final uri = _apiResource.endpointUriMaster(endpoint,id:id);

    Options options = Options();
    options.headers = {"Authorization": "Bearer $_token"};
    options.method = "GET";

    try {
      Response resp = await _httpDio.request(uri.toString(), data: data, options: options);

      return resp.data;
    } on DioError catch (e) {
      //Logica para Token-expired
      //_logError(e);
      throw e;
    }
  }

  Future<dynamic> callPersonalInfo(String personalId) async {
    try {
      if (personalId == 0 || personalId.isEmpty) throw Exception("callPersonalInfo. PersonalId is null/emtpy");

      if (_token == null || _token.isEmpty) throw Exception("callPersonalInfo. token is null/emtpy");

      final uri = _apiResource.endpointUriMaster(Endpoint.MasterPersonal,id:personalId);

      Options options = Options();
      options.headers = {"Authorization": "Bearer $_token"};

      Response resp = await _httpDio.get(uri.toString(), options: options);

      return resp.data;
    } on DioError catch (e) {
      throw e;
    }
  }

  Future<dynamic> postNotificationInfo({Map<String, dynamic> data = null}) async {

    if (data==null) {
      logger.w('Notification.sendstate. No se puede enviar sin información');
      return false;
    }

    final uri = _apiResource.endpointUriMaster(Endpoint.notificacion);

    Options options = Options();
    options.headers = {"Authorization": "Bearer $_token"};

    try {
      await _httpDio.post(uri.toString(), data: json.encode(data), options: options);

      return true;

    } on DioError catch (e) {
      //Logica para Token-expired
      //_logError(e);
      throw e;
    }
  }

  Future<dynamic> callNotificationGet({@required Usuario user, Map<String, dynamic> data = null}) async {

    // final uri = _apiResource.endpointUriSocio(Endpoint.notificacion, user.personalId);
    //
    // var params = {
    //   'undeliver': 'valor',
    //   if (user.deBodega==1) ... {
    //     'bodega': 1,
    //   },
    //   if (user.deAceituna==1) ... {
    //     'aceituna': 1,
    //   },
    // };
    //
    // if (data!=null) {
    //   params.addAll(data);
    // }
    //
    // Options options = Options();
    // options.headers = {"Authorization": "Bearer $_token"};
    // options.method = "GET";
    //
    // try {
    //   Response resp = await _httpDio.get(uri.toString(), queryParameters: params, options: options);
    //
    //   return resp.data;
    // } on DioError catch (e) {
    //   //Logica para Token-expired
    //   //_logError(e);
    //   throw e;
    // }
  }


  static Dio _configHttpAuthDio(API api) {
    Dio dio = new Dio();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };

    dio.options.baseUrl = api.hostUrl;
    dio.options.connectTimeout = appConfig.timeout;
    dio.options.receiveTimeout = appConfig.timeout;
    dio.options.headers['Content-type']='application/json;charset=UTF-8';
    dio.options.headers['Accept']='application/json';

    /*dio.interceptors.add(
      ManageDioErrorInterceptor(dio: dio)
    );*/

//    dio.interceptors.add(
//        InterceptorsWrapper(onRequest: (RequestOptions options) async {
//          options.headers['Content-type']='application/json;charset=UTF-8';
//        })
//    );

    //Log
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 120));

    return dio;
  }

  static Dio _configHttpDio(API api) {
    Dio dio = new Dio();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };

    dio.options.baseUrl = api.hostUrl;
    dio.options.connectTimeout = appConfig.timeout;
    dio.options.receiveTimeout = appConfig.timeout;
    dio.options.headers['Content-type']='application/json';
    dio.options.headers['Accept']='application/json';

   /* dio.interceptors.add(
        ManageDioErrorInterceptor(dio: dio)
    );*/

//    dio.interceptors.add(
//        InterceptorsWrapper(onRequest: (RequestOptions options) async {
//          options.headers['Content-type']='application/json;charset=UTF-8';
//        })
//    );

    //Log
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 120));

    return dio;
  }

  void _logError(DioError e) {
    if (e.response != null) {
      logger.e(
          'Request error. status-code:${e.response.statusCode} response.data: ${e.response.data} response.header: ${e.response.headers}');
    } else {
      logger.e('Request error. error-type:${e.type} message:${e.error}');
    }
  }

}

class HttpRequestError implements Exception {
  /// Constructs the [HttpRequestError]
  const HttpRequestError(this.message);

  /// A [message] describing more details on the update exception
  final String message;

  @override
  String toString() {
    return message;
  }
}

APIService apiService;
