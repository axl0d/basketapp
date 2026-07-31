import 'package:dartz/dartz.dart';
import 'package:basketapp/core/errors/failure.dart';
import 'package:basketapp/features/auth/domain/entities/user.dart';
import 'package:basketapp/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, User>> call(
    String email,
    String password,
    String displayName,
  ) async {
    return await repository.register(email, password, displayName);
  }
}
