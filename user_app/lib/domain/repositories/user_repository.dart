import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, String>> login(String email, String password);
  Future<Either<Failure, void>> register(
      String name, String email, String password, String phone, String address);
  Future<Either<Failure, List<User>>> getUsers(String token);
}
