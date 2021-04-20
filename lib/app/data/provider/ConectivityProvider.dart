import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:apnapp/app/common/utils/StreamUtils.dart';

const kOfflineDebounceDuration = Duration(seconds: 3); //Tiempo que tarda en enviar el evento, permite controlar pequeños cortes en la conexion

enum ConnectivityStatus { WiFi, Cellular, Offline }

class ConnectivityService {
  final connectivityService = Connectivity();

  // Create our public controller
  StreamController<ConnectivityStatus> _connectionStatusController = StreamController<ConnectivityStatus>.broadcast();
  ConnectivityStatus _lastState = null;

  ConnectivityService() {

    Stream.fromFuture(connectivityService.checkConnectivity())
        .asyncExpand((data) => connectivityService.onConnectivityChanged.transform(startsWith(data)))
        .transform(debounce(kOfflineDebounceDuration))
        .listen((ConnectivityResult result) {
          var state =_getStatusFromResult(result);
          if (_lastState==null || state!=_lastState) {
            _lastState = state;
            _connectionStatusController.add(state);
          }
    });
  }

  Stream<ConnectivityStatus> subscribe() {
    return _connectionStatusController.stream.distinct();
  }

  // Convert from the third part enum to our own enum
  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Cellular;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.WiFi;
      case ConnectivityResult.none:
        return ConnectivityStatus.Offline;
      default:
        return ConnectivityStatus.Offline;
    }
  }
}
