import 'dart:async';

import 'package:apnapp/app/app_state.dart';
import 'package:apnapp/app/common/event_manager.dart';
import 'package:apnapp/app/common/logger.dart';
import 'package:apnapp/app/data/provider/api_service.dart';
import 'package:apnapp/app/data/repository/_repositorys.dart';
import 'package:apnapp/app/locator.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository authRepository;
  final AppState appState;
  final apiservice = locator<APIService>();

  AuthenticationBloc({@required this.authRepository,@required this.appState})
      : assert(authRepository != null), super(AuthenticationUninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {

    if (event is AppStarted) {
      final bool hasToken = await authRepository.hasToken();
      if (hasToken) {
        var token = authRepository.getToken();
        //logger.i('AuthBloc. Token saved exist [${token}]. User Authenticated');
        apiservice.token = token;
        //analytics.logEvent(name: 'AuthBloc.AppStarted_HasToken');
        yield AuthenticationAuthenticated();

      } else {
        logger.i('AuthBloc. No token exist. No authenticated');
        //analytics.logEvent(name: 'AuthBloc.AppStarted_NoToken');
        yield AuthenticationUnauthenticated();
        apiservice.token = "";
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      //analytics.logEvent(name: 'AuthBloc.Loggout', parameters: {'userId': appState.user?.socioId});
      logger.i('AuthBloc. Logout. Clean tokens');
      await authRepository.deleteToken();

      locator<EventManager>().closeChannel(EventChannel.Notificacion);

      //entityCache.Clear(); //Borramos la cache

      //un-subcribe a notifications-topics by user-config
      //await appState.user?.unSubscribeToNotificationsTopics();

      //cuando me logo, el usuario no se elimina, para tener constancia del mismo.
      yield AuthenticationUnauthenticated();

      locator<EventManager>().sendEvent(EventChannel.Autentication, AuthLogoutEvent());
    }
  }

  @override
  String toString() => 'AutenticationBloc';
}

//EVENTS
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';
}

class LoggedIn extends AuthenticationEvent {
  LoggedIn(this.token);

  final String token;

  @override
  String toString() => 'LoggedIn { token: $token }';
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';
}

//STATES

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}
