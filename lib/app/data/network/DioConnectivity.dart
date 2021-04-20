import 'dart:async';
import 'dart:io';

import 'package:apnapp/app/app_state.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ManageDioErrorInterceptor extends Interceptor {
  final Dio dio;

  AppState _appState;

  ManageDioErrorInterceptor({@required this.dio});



  // @override
  // Future onError(DioError err,ErrorInterceptorHandler handler) async {
  //
  //   if (_appState==null)
  //     _appState = locator<AppState>();
  //
  //   if (_shouldRetry(err)) {
  //     if (!_appState.HasInternetConnection) {
  //       //No hay internet
  //       if (await Navigation.checkConnectivity(null)) {
  //         //hay internet de nuevo
  //         try {
  //           return await executeRequest(err.requestOptions);
  //         } catch (ex,s) {
  //           //TODO: Crashlytics enabled
  //           //Crashlytics.instance.recordError(ex, s);
  //           return ex;
  //         }
  //       }
  //     } else if (err.type==DioErrorType.connectTimeout) {
  //       //Hay conextion a internet
  //       int resp = await Navigation.pageError("/error/rqt-timeout",null);
  //       if (resp==-1){
  //          //reintento
  //         //hay internet de nuevo
  //         try {
  //           return await executeRequest(err.requestOptions);
  //         } catch (ex,s) {
  //           //TODO: Crashlytics enabled
  //           //Crashlytics.instance.recordError(ex, s);
  //           return ex;
  //         }
  //       }
  //     }
  //   }
  //
  //   // Let the error "pass through" if it's not the error we're looking for
  //   return err;
  // }

  bool _shouldRetry(DioError err) {

    if (err.type == DioErrorType.other || err.type==DioErrorType.connectTimeout)
      return true;

    if (err.error != null) {
      if (err.error is SocketException)
        return true;
    }

    return false;
  }

  Future<Response> executeRequest(RequestOptions requestOptions) async {

    return await dio.request(
      requestOptions.path,
      cancelToken: requestOptions.cancelToken,
      data: requestOptions.data,
      onReceiveProgress: requestOptions.onReceiveProgress,
      onSendProgress: requestOptions.onSendProgress,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        sendTimeout: requestOptions.sendTimeout,
        receiveTimeout: requestOptions.receiveTimeout,
        extra: requestOptions.extra,
        headers: requestOptions.headers,
        responseType: requestOptions.responseType,
        contentType: requestOptions.contentType,
        validateStatus: requestOptions.validateStatus,
        receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
        followRedirects: requestOptions.followRedirects,
        maxRedirects: requestOptions.maxRedirects,
        requestEncoder: requestOptions.requestEncoder,
        responseDecoder: requestOptions.responseDecoder,
        listFormat: requestOptions.listFormat,
      ),
    );
  }
}

class DioConnectivityRequestRetrier {
  final Dio dio;
  final Connectivity connectivity;

  DioConnectivityRequestRetrier({
    @required this.dio,
    @required this.connectivity,
  });

  //TODO: ERR TO MIGRATE TO DIO 4.0
 /* Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async {
    StreamSubscription streamSubscription;
    final responseCompleter = Completer<Response>();

    streamSubscription = connectivity.onConnectivityChanged.listen(
      (connectivityResult) async {
        if (connectivityResult != ConnectivityResult.none) {
          streamSubscription.cancel();
          // Complete the completer instead of returning
          responseCompleter.complete(
            dio.request(
              requestOptions.path,
              cancelToken: requestOptions.cancelToken,
              data: requestOptions.data,
              onReceiveProgress: requestOptions.onReceiveProgress,
              onSendProgress: requestOptions.onSendProgress,
              queryParameters: requestOptions.queryParameters,
              options: requestOptions,
            ),
          );
        }
      },
    );

    return responseCompleter.future;
  }*/
}

class DioErrorRequestRetrier {
  final Dio dio;

  DioErrorRequestRetrier({@required this.dio});

  Future<Response> executeRequest(RequestOptions requestOptions) async {
    return await dio.request(
      requestOptions.path,
      cancelToken: requestOptions.cancelToken,
      data: requestOptions.data,
      onReceiveProgress: requestOptions.onReceiveProgress,
      onSendProgress: requestOptions.onSendProgress,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        sendTimeout: requestOptions.sendTimeout,
        receiveTimeout: requestOptions.receiveTimeout,
        extra: requestOptions.extra,
        headers: requestOptions.headers,
        responseType: requestOptions.responseType,
        contentType: requestOptions.contentType,
        validateStatus: requestOptions.validateStatus,
        receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
        followRedirects: requestOptions.followRedirects,
        maxRedirects: requestOptions.maxRedirects,
        requestEncoder: requestOptions.requestEncoder,
        responseDecoder: requestOptions.responseDecoder,
        listFormat: requestOptions.listFormat,
      )
    );
  }
}

class DioPrettyErrors {

  static String parseError(DioError err){

    if (err.type==DioErrorType.connectTimeout) {
      return "Tiempo de espera superado";
    }

    if (err!=null && err.response!=null) {
      return '${err.response.statusCode} - ${err.response.statusMessage}\n${err.response}';
    }

    return "Algo fue mal";

  }

}
