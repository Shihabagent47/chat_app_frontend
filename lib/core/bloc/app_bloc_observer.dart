import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/services/logger/app_logger.dart'; // your existing logger

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    AppLogger.logBlocEvent(bloc.runtimeType.toString(), event.toString());
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    AppLogger.logBlocState(
      bloc.runtimeType.toString(),
      transition.nextState.toString(),
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    AppLogger.logException(
      error is Exception ? error : Exception(error.toString()),
      stackTrace,
      context: bloc.runtimeType.toString(),
    );
  }
}
