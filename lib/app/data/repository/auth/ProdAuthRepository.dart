import 'dart:convert';

// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:apnapp/app/app_state.dart';
import 'package:apnapp/app/common/Constants.dart';
import 'package:apnapp/app/common/OAuthSecureStorage.dart';
import 'package:apnapp/app/common/event_manager.dart';
import 'package:apnapp/app/data/provider/api_service.dart';
import 'package:apnapp/app/data/security/OAuth.dart';
import 'package:apnapp/app/domain/fails/_fails.dart';
import 'package:apnapp/app/domain/model/_models.dart';
import 'package:apnapp/app/locator.dart';
import 'package:flutter/material.dart';
import 'AuthRepository.dart';

class ServerAuthRepository extends AuthRepository {

  final oauthStorage = new OAuthSecureStorage();
  final _appState = locator<AppState>();

  //LOGIN ==> obtiene token y refreshToken.
  //LOGOUT ==> solo borramos los tokens y obligamos al usuario a logarse de nuevo.

  ServerAuthRepository() {
    oauthStorage.fetch().then((value) {
      _token = value.accessToken;
      _refreshToken = value.refreshToken;
    });
  }

  bool isDemoUser=false;
  String _token = "";
  String _refreshToken = "";

  String get token => _token;

  String get refreshToken => _refreshToken;

  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {

    username = username.replaceAll(RegExp('\t'), '');
    password = password.replaceAll(RegExp('\t'), '');

    try {

      var data = {};
      var resp;

      if (username.toLowerCase()==Constants.Demo_User.userId && password.toLowerCase()==Constants.Demo_User.comment) {

        data['accessToken'] = "Be4nhbvfzl...";
        data['refreshToken'] = "Be4nhbvfzlZI1N79R6q/Bx4lPlyafKQwQxAxfrloXSw=";
        data['socioId'] = Constants.Demo_User.personalId.toString();

        isDemoUser=true;

      } else {
        resp = data = await apiService.signIn(username, password);
      }

        _token = resp['accessToken'];
        _refreshToken = resp['refreshToken'];

        String personalId = resp['personalId'];
        String userId = resp['userId'];

        apiService.token = _token;

        if (!isDemoUser) {
          var personalInfo = await apiService.callPersonalInfo(personalId);

          var user = Usuario.fromJson(personalInfo);

          user.userName = username; //actualizo con el username
          user.userId = userId; //actualizo con el username

          _appState.AssignLoggedUser(user); //Asignar al estado el usuario recien logado.

          //subcribe a notifications-topics by user-config
          //TODO: Noitifications-subscribe enabled
          // await user.subscribeToNotificationsTopics();

          await persistToken(new OAuthToken(accessToken: _token, refreshToken: _refreshToken));

        } else {
          _appState.AssignLoggedUser(Constants.Demo_User);
        }

        //Envio notificacion de login, una vez obtenido el usuario
        locator<EventManager>().sendEvent(EventChannel.Autentication, AuthLoggedEvent());
        _appState.executeActionsAfterLogin();

    } on SignInUserPassNoValidException {
      _setEmtpyTokens();
      throw Exception('Usuario/contraseña no válidos');
    } on Exception catch (ex,s) {
      //TODO: Activate CRASHLYTICS
      // Crashlytics.instance.recordError(ex, s);
      _setEmtpyTokens();
      throw Exception('Error proceso validación.\n${ex.toString()}');
    }

    return _token;
  }

  @override
  Future<bool> changepass({String username, String oldpass, String newpass}) async {

    oldpass = oldpass.replaceAll(RegExp('\t'), '');
    newpass = newpass.replaceAll(RegExp('\t'), '');

    try {
      await apiService.changePass(username, oldpass, newpass);

      return true;

    } on ChangeUserPasswordFail catch(chex) {
      throw ChangeUserPasswordFail('${chex}');

    } on Exception catch (ex,s) {
      // Crashlytics.instance.recordError(ex, s);
      // Crashlytics.instance.recordError(ex, s);
      throw Exception('Error actualizar contraseña');
    }

  }

  _setEmtpyTokens() {
    _token = "";
    _refreshToken = "";
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await oauthStorage.clear();
    _token = "";
    _refreshToken = "";
    return;
  }

  Future<void> persistToken(OAuthToken token) async {
    await oauthStorage.save(OAuthToken(accessToken: _token, refreshToken: _refreshToken));
    return;
  }

  Future<bool> hasToken() async {
    //return false;
    if (_token == null || _token.isEmpty) {
      var oauthToken = await oauthStorage.fetch();
      _token = oauthToken.accessToken ?? "";
      _refreshToken = oauthToken.accessToken ?? "";
    }
    return _token.isNotEmpty;
  }

  String getToken() {
    return _token;
  }


}
