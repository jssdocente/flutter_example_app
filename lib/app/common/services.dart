import 'package:flutter/foundation.dart';

abstract class StoppableService {
  bool _serviceStoped = false;
  bool get serviceStopped => _serviceStoped;

  @mustCallSuper
  void stop() {
    _serviceStoped = true;
  }

  @mustCallSuper
  void start() {
    _serviceStoped = false;
  }
}

///Ejemplo de implementacion para un servicio
//class LocationService extends StoppableService {
//  @override
//  void start() {
//    super.start();
//    // start subscription again
//  }
//
//  @override
//  void stop() {
//    super.stop();
//    // cancel stream subscription
//  }
//}