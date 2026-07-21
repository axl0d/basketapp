import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

/// Domain define QUÉ se puede hacer, no CÓMO. La implementación
/// concreta (con Firebase) vive en la capa data.
abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    String? displayName,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Future<Either<Failure, void>> sendPasswordResetEmail(String email);

  /// Stream para reaccionar a cambios de sesión en tiempo real
  /// (login/logout desde cualquier parte de la app).
  Stream<UserEntity?> get authStateChanges;
}
