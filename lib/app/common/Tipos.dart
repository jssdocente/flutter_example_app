
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';

enum VehicleRegisterState {unregister, inactive, active}

enum ServiceEmergencyStateEnum {undefined, eco,lima,charli,hotel,delta}

class ServiceEmergencyState {
   final ServiceEmergencyStateEnum state ;

  ServiceEmergencyState(this.state);

   @override
  String toString() {
     return EnumToString.convertToString(state,camelCase: false);
  }
}

class ServiceEmergencyStateEco extends ServiceEmergencyState {
  ServiceEmergencyStateEco() : super(ServiceEmergencyStateEnum.eco);

}

class ServiceEmergencyStateLima extends ServiceEmergencyState {
  ServiceEmergencyStateLima() : super(ServiceEmergencyStateEnum.lima);

}

class ServiceEmergencyStateCharli extends ServiceEmergencyState {
  ServiceEmergencyStateCharli() : super(ServiceEmergencyStateEnum.charli);

}

class ServiceEmergencyStateHotel extends ServiceEmergencyState {
  ServiceEmergencyStateHotel() : super(ServiceEmergencyStateEnum.hotel);

}

class ServiceEmergencyStateDelta extends ServiceEmergencyState {
  ServiceEmergencyStateDelta() : super(ServiceEmergencyStateEnum.delta);

}