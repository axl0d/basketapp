import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:basketapp/core/errors/exceptions.dart';
import 'package:basketapp/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password, String displayName);
  Future<void> logout();
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl(this.firebaseAuth);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        throw AuthenticationException('Usuario no encontrado');
      }
      return UserModel.fromFirebaseUser(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthenticationException(_handleFirebaseException(e));
    } catch (e) {
      throw ServerException('Error al iniciar sesión: $e');
    }
  }

  @override
  Future<UserModel> register(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        throw AuthenticationException('Error al crear usuario');
      }
      await user.updateDisplayName(displayName);
      await user.reload();
      return UserModel.fromFirebaseUser(firebaseAuth.currentUser!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthenticationException(_handleFirebaseException(e));
    } catch (e) {
      throw ServerException('Error al registrar: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw ServerException('Error al cerrar sesión: $e');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        throw AuthenticationException('No hay usuario autenticado');
      }
      return UserModel.fromFirebaseUser(user);
    } catch (e) {
      throw ServerException('Error al obtener usuario: $e');
    }
  }

  String _handleFirebaseException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Usuario no encontrado';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'email-already-in-use':
        return 'El email ya está registrado';
      case 'weak-password':
        return 'La contraseña es muy débil';
      case 'invalid-email':
        return 'Email inválido';
      case 'operation-not-allowed':
        return 'Operación no permitida';
      case 'user-disabled':
        return 'Usuario deshabilitado';
      default:
        return e.message ?? 'Error de autenticación';
    }
  }
}
