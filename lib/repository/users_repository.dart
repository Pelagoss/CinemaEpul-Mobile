import 'package:cinemaepulmobile/request.dart';

class UsersRepository {
  Future<String?> signInWithEmailPwd(username, password) async {
    return await fetchToken(username, password);
  }
}

class NetworkException implements Exception {}
