/// Excepciones que solo circulan dentro de la capa `data`.
/// El repositorio (data) las captura y las traduce a `Failure`
/// antes de que lleguen a domain/presentation.

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}
