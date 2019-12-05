import 'package:bloc/bloc.dart';
import 'package:face_app/bloc/app_bloc_states.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  @override
  AppState get initialState => AppState();

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    yield AppState();
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    print([error, stacktrace]);
  }
}
