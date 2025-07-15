import 'package:app/common/entity/user_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'app_cubit_state.dart';

class AppCubitCubit extends Cubit<AppCubitState> {
  AppCubitCubit() : super(AppCubitInitial());

  void getUser(User? user) {
    if (user == null) {
      emit(AppCubitInitial());
    } else {
      emit(AppUserLoggedInState(user: user));
    }
  }

  void logout() {
    emit(AppUserLoggedOutState());
  }
}
