import 'package:apnapp/app/data/repository/_repositorys.dart';
import 'package:apnapp/app/domain/fails/_fails.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'AuthenticationBloc.dart';

import '_blocs.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null), super(LoginInitialSt());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {

    if (event is LoginButtonPressedEvt) {
      yield LoginLoadingSt();

      try {
        final token = await userRepository.authenticate(
          username: event.username,
          password: event.password,
        );

        if (token.isNotEmpty) {
//          analytics.logEvent(name: 'login', parameters: {'user': event.username});
            authenticationBloc.add(LoggedIn(token));
        } else {
          yield LoginFailureSt(error: "Usuario / contraseña no válidos");
        }

      } catch (error,stack) {
        //TODO: Crashlytics enabled
        // Crashlytics.instance.recordError(error, stack);
        yield LoginFailureSt(error: error.toString().replaceAll('Exception:', ''));

      }
    }

    if (event is ChangePassButtonPressedEvt) {
      yield LoginLoadingSt();

      try {
         await userRepository.changepass(
          username: event.username,
          oldpass: event.oldpass,
          newpass: event.newpass
        );

         yield ChangePassChangedSt();

      } on ChangeUserPasswordFail catch (chex,stack) {
        yield ChangepassFailureSt(error: chex.toString().replaceAll('Exception:', ''));

      } catch (error,stack) {
        //TODO: Crashlytics enabled
        // Crashlytics.instance.recordError(error, stack);
        yield ChangepassFailureSt(error: error.toString().replaceAll('Exception:', ''));

      }
    }

  }

  @override
  String toString() => 'LoginBloc';
}

//EVENTS
abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressedEvt extends LoginEvent {
  final String username;
  final String password;

  const LoginButtonPressedEvt({
    @required this.username,
    @required this.password,
  });

  @override
  List<Object> get props => [username, password];

  @override
  String toString() =>  'LoginButtonPressed { username: $username, password: $password }';
}

class ChangePassButtonPressedEvt extends LoginEvent {
  final String username;
  final String oldpass;
  final String newpass;

  const ChangePassButtonPressedEvt({
    @required this.username,
    @required this.oldpass,
    @required this.newpass,
  });

  @override
  List<Object> get props => [username,oldpass, newpass];

  @override
  String toString() =>  'ChangePassButtonPressed {username: $username, oldpass: $oldpass, password: $newpass }';
}


//STATES
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitialSt extends LoginState {}

class LoginLoadingSt extends LoginState {}

class ChangePassChangedSt extends LoginState {}

class LoginFailureSt extends LoginState {
  final String error;

  const LoginFailureSt({@required this.error});
}

class ChangepassFailureSt extends LoginState {
  final String error;

  const ChangepassFailureSt({@required this.error});
}