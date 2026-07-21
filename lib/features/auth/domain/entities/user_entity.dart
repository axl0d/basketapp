import 'package:equatable/equatable.dart';

/// Entidad de dominio. NO sabe nada de Firebase — así, si mañana
/// cambias de proveedor de auth, domain y presentation no se enteran.
class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String? displayName;
  final bool emailVerified;

  const UserEntity({
    required this.uid,
    required this.email,
    this.displayName,
    this.emailVerified = false,
  });

  @override
  List<Object?> get props => [uid, email, displayName, emailVerified];
}
