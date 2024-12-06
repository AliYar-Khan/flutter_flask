import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../repositories/user_repository.dart';

class LoginUser {
  final UserRepository repository;

  LoginUser(this.repository);

  Future<Either<Failure, String>> call(String email, String password) {
    return repository.login(email, password);
  }
}
