import 'package:bloc/bloc.dart';
import 'package:cinemaepulmobile/model/utilisateur.dart';
import 'package:meta/meta.dart';
import 'package:cinemaepulmobile/repository/users_repository.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final UsersRepository _usersRepository;

  UsersCubit(this._usersRepository) : super(const UsersInitial());
  UsersCubit.withCurrentUser(this._usersRepository, currentUser)
      : super(UsersSigned(currentUser));

  Future<void> signInUser(String email, password) async {
    try {
      emit(const UsersLoading());
      String? token =
          await _usersRepository.signInWithEmailPwd(email, password);
      if (token != null) {
        emit(UsersSigned(token));
      } else {
        emit(const UsersError("Connexion impossible"));
      }
    } on NetworkException {
      emit(const UsersError("Connexion impossible. Pas d'accès internet."));
    }
  }
}
