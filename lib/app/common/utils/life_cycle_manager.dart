import 'package:flutter/material.dart';

import '../logger.dart';
import '../services.dart';

class LifeCycleManager extends StatefulWidget {
  final Widget child;
  LifeCycleManager({Key key, this.child}) : super(key: key);

  @override
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager> with WidgetsBindingObserver {

  AppLifecycleState _appLifecycleState;

  List<StoppableService> services = [
    //Agregar la lista de servicios que queremos que se detengan o pasen a background cuando el terminal entre en cierto estado
//    locator<LocationService>(),
  ];

  @override
  void initState() {
    super.initState();
    logger.i("App-initState");
    WidgetsBinding.instance.addObserver(this);
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    logger.i("App-didChangeAppLifecycleState: ${state}");

    services.forEach((service) {
      if (state == AppLifecycleState.resumed) {
        service.start();
      } else {
        service.stop();
      }
    });

    //if (state==AppLif)

  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

}