import 'package:apnapp/app/data/security/OAuth.dart';
import 'package:apnapp/app/locator.dart';
import 'package:apnapp/app/app_state.dart';
import 'package:apnapp/app/domain/model/_models.dart';
import 'package:flutter/material.dart';
import 'AuthRepository.dart';

class MockAuthRepository extends AuthRepository {

  static const String userOk="201";
  static const String passOk="1234";

  final _appState = locator<AppState>();

  String _token="";

  String get token => _token;

  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    await Future.delayed(Duration(seconds: 1));

    username = username.replaceAll(RegExp('\t'), '');
    password = password.replaceAll(RegExp('\t'), '');

    if (username==userOk && password==passOk) {
      _token='token';
      _appState.AssignLoggedUser(Usuario.createSample()); //Asignar al estado el usuario recien logado.
    } else {
      _token ="";
    }
    return _token;
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    _appState.ResetUser();
    _token="";
    return;
  }

  Future<void> persistToken(OAuthToken token) async {
    /// write to keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<bool> hasToken() async {
    /// read from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    if (_appState!=null && _appState.user!=null)
      return true;

    return _token.isNotEmpty;
  }

  String getToken(){
    return _token;
  }

  @override
  Future<bool> changepass({String username, String oldpass, String newpass}) {
    // TODO: implement changepass
    throw UnimplementedError();
  }
}