import 'package:apnapp/app/domain/vo/_vos.dart';

import '_models.dart';
import 'package:sqflite/sqlite_api.dart';

//TODO: SE MEZCLAN DATOS DE USUARIO Y SOCIO. SEPARAR 2 CLASES (USUARIO Y SOCIOS. UN SOCIO ESTÁ VINCULADO A UN USUARIO)
// ignore: must_be_immutable
class Usuario extends ModelDb {
  static final tbl="Usuario";
  static final dbId= "id";
  static final dbCode= "code";
  static final dbLastNames= "lastNames";
  static final dbFullName= "fullName";
  static final dbEmail= "email";
  static final dbMobileNumber= "mobileNumber";
  static final dbAdress= "Address";
  static final dbDriverId= "DriverId";
  static final dbNif= "Nif";
  static final dbPersonalId= "personalId";
  static final dbUserId= "UserId";
  static final dbUserName= "userName";
  static final dbComment= "commnet";


  final String id;
  final String code;
  final String name;
  final String lastNames;
  final String fullName;
  final String email;
  final String mobileNumber;
  final String address;
  final String driverId;
  final String nif;
  final String comment;
  String personalId;
  String userId;
  String userName;

  Usuario._({this.id,
    this.code,
    this.name,
    this.lastNames,
    this.fullName,
    this.email,
    this.mobileNumber,
    this.address,
    this.driverId,
    this.nif,
    this.personalId,
    this.userId,
    this.userName,
    this.comment,})
      : super(tbl,dbId, id.toString());

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario._(
    id: json["id"].toString(),
    code: json["code"],
    name: json["name"],
    lastNames: json["lastNames"],
    fullName: json["fullName"],
    email: json["email"],
    mobileNumber: json["mobileNumber"],
    address: json["address"],
    driverId: json["driverId"].toString(),
    nif: json["nif"],
    personalId: json["id"],
    userId: json["userId"],
    userName: json["userName"],
    comment: json["comment"],
  );

  factory Usuario.createSample() {
    return Usuario._(
      id: "1",
      code: '1',
      userId: '201',
      address: '',
      personalId: "238239509753",
      userName: "201",
      driverId: "53570156",
      email: 'personal@gmail.com',
      name: "Manuel",
      lastNames: "Guzman",
      mobileNumber: '654677432',
      nif: '08965444A',
      fullName: 'Manuel Guzman',
      comment: '',
    );

  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "name": name,
    "lastNames": lastNames,
    "fullName": fullName,
    "email": email,
    "mobileNumber": mobileNumber,
    "address": address,
    "driverId": driverId,
    "nif": nif,
    "personalId": id,
    "userId": userId,
    "userName": userName,
    "comment": comment,
  };

  factory Usuario.createEmpty() {
    return Usuario._(
      id: "0",
      code: '',
      userId:"",
      personalId: "0",
      name: '',
      lastNames: '',
      userName: '',
      fullName: '',
      nif: '',
      mobileNumber: '',
      email: '',
      driverId: '',
      address: '',
      comment: '',
    );
  }

  factory Usuario.createDemo() {
    return Usuario._(
      id: "99999",
      code: "99999",
      userId:"99999999",
      userName: "99999999",
      lastNames: "demostración",
      name: "Usuario",
      address: 'dirección',
      driverId: "99999",
      email: "usuario@gmail.com",
      mobileNumber: "+34 666958478",
      personalId: "99999",
      fullName: 'Usuario demostración',
      comment: '692351',
    );
  }

  String getAvatarInitials() => PersonalNameVO(fullName).getAvatarInitials;

  @override
  List<Object> get props => [
    id,
    code,
    name,
    lastNames,
    fullName,
    email,
    mobileNumber,
    address,
    driverId,
    nif,
    comment,
    personalId,
    userId,
    userName,
  ];

  // void subscribeToNotificationsTopics() async {
  //   await PushNotificationsManager().subcribeToTopic(socioId.toString());
  //   await PushNotificationsManager().subcribeToTopic(Constants.Notification_Topic_All);
  //
  //   if (deAceituna==1) {
  //       await PushNotificationsManager().subcribeToTopic("aceituna");
  //   }
  //   if (deBodega==1) {
  //     await PushNotificationsManager().subcribeToTopic("bodega");
  //   }
  // }
  //
  // void unSubscribeToNotificationsTopics() async {
  //   await PushNotificationsManager().unSubcribeToTopic(socioId.toString());
  //   await PushNotificationsManager().unSubcribeToTopic(Constants.Notification_Topic_All);
  //
  //   if (deAceituna==1) {
  //     await PushNotificationsManager().unSubcribeToTopic("aceituna");
  //   }
  //   if (deBodega==1) {
  //     await PushNotificationsManager().unSubcribeToTopic("bodega");
  //   }
  // }

  //DATABASE SELECT
  static Future<List<Usuario>> DbSelectAll(Database db) async {
    final result = await db.rawQuery('SELECT FROM ${Usuario.tbl}');

    return result.isNotEmpty
        ? result.map((c) => Usuario.fromJson(c)).toList()
        : [];
  }
}
