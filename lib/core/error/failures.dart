import 'package:equatable/equatable.dart';

/// Clase base de errores "de negocio". Nunca exponemos excepciones
/// crudas (FirebaseAuthException, etc.) fuera de la capa data:
/// todo se traduce a un Failure con mensaje ya listo para UI.
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Error de autenticación (credenciales, usuario no existe, etc.)
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Error del lado del servidor / Firebase no relacionado a auth en sí
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Sin conexión a internet
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Cualquier otro error no anticipado
class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
