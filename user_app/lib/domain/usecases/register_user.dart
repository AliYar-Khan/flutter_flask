import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../repositories/user_repository.dart';

class RegisterUser {
  final UserRepository repository;

  RegisterUser(this.repository);

  Future<Either<Failure, void>> call({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) {
    return repository.register(name, email, password, phone, address);
  }
}
