import 'package:bloc/bloc.dart';

class MyBlocObserver extends BlocObserver {

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('onTransition => bloc:${bloc} - transition:${transition}');
    super.onTransition(bloc, transition);
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    print('onEvent => bloc:${bloc} - even:${event}');
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase cubit, Object error, StackTrace stackTrace) {
    super.onError(cubit, error, stackTrace);
  }
}