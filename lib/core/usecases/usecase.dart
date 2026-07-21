import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

/// Contrato que deben cumplir TODOS los use cases de TODAS las
/// features (no solo auth). Esto estandariza cómo se invocan desde
/// providers/controllers: siempre `Either<Failure, Type>`.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Para use cases que no requieren parámetros (ej. logout, getCurrentUser)
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object> get props => [];
}
