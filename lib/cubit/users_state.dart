part of 'users_cubit.dart';

@immutable
abstract class UsersState {
  const UsersState();
}

class UsersInitial extends UsersState {
  const UsersInitial();
}

class UsersLoading extends UsersState {
  const UsersLoading();
}

class UsersSigned extends UsersState {
  final String users;
  const UsersSigned(this.users);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UsersSigned && o.users == users;
  }

  @override
  int get hashCode => users.hashCode;
}

class UsersError extends UsersState {
  final String message;
  const UsersError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UsersError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
