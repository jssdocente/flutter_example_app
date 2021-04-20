

import 'package:apnapp/app/domain/model/_models.dart';

class Constants {
  static const AppNameInternal="ApoloPlaftormNavega";
  static const LastMovementsOptions = {"LastIntervalDaysMovements": 30, "MovementsCount": 3};

  static const FormatMilesNoDecimal= "#,###,###,###";
  static const FormatMilesOneDecimal= "#,###,###,##0.0";
  static const FormatMilesTwoDecimal= "#,###,###,##0.00";

  static const AndroidChannelDefault = {
    'id': '${AppNameInternal}_channel_default',
    'name': 'Canal predeterminado',
    'description': 'Canal para el envio de notificaciones'
  };

  static const Journal_type = "emergencia";  //tipo de actividad para esta app.

  static const Notification_Topic_All="todos";

  static const Notification_Type_General = 'GEN';
  static const Notification_Type_Liquidacion = 'LQN';
  static const Notification_Type_Anticipo = 'ANT';

  static final Demo_User = Usuario.createDemo();

}

