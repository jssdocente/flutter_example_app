import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AppConfig {
  final String flavor;
  final String baseUrlAuth;
  final String baseUrlResource;
  final String appTitle;
  final int timeout;

  AppConfig._(
      {
      @required this.baseUrlAuth,
      @required this.baseUrlResource,
       this.flavor = 'dev',
      this.timeout = 10000,
      this.appTitle = 'Apolo Emergencias'});

  static Future<AppConfig> forEnviroment(String env) async {
    final contents = await rootBundle.loadString(
      'assets/config/$env.json',
    );

    final json = jsonDecode(contents);

    final String baseUrlAuth = json['baseUrlAuth'] ?? "";
    final String baseUrlResource = json['baseUrlResource'] ?? "";
    final int timeout = json['timeout'] ?? 10000;
    String appTitle = json['appTitle'] ?? '';
    if (appTitle.trim().isEmpty) appTitle = 'Apolo Navega';

    return AppConfig._(
        flavor: env, baseUrlAuth: baseUrlAuth, baseUrlResource: baseUrlResource, timeout: timeout, appTitle: appTitle);
  }
}

class PreferencesConfig {
  static const String appkey = 'aenapp';
}

AppConfig appConfig;
