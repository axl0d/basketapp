import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecases/usecase.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/send_password_reset_usecase.dart';
import 'auth_state.dart';

// ---------------------------------------------------------------------
// Inyección de dependencias, capa por capa. Cada Provider depende SOLO
// del nivel inmediatamente inferior (presentation -> domain -> data),
// nunca al revés. Para testear, se puede sobreescribir cualquiera de
// estos providers con overrides en ProviderScope.
// ---------------------------------------------------------------------

final firebaseAuthProvider = Provider<fb.FirebaseAuth>((ref) {
  return fb.FirebaseAuth.instance;
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(firebaseAuth: ref.watch(firebaseAuthProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(remoteDataSource: ref.watch(authRemoteDataSourceProvider));
});

final loginUseCaseProvider = Provider((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final registerUseCaseProvider = Provider((ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

final getCurrentUserUseCaseProvider = Provider((ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
});

final sendPasswordResetUseCaseProvider = Provider((ref) {
  return SendPasswordResetUseCase(ref.watch(authRepositoryProvider));
});

/// Expone authStateChanges como stream provider — útil para el router
/// (redirigir según sesión) sin pasar por el StateNotifier.
final authStateChangesProvider = StreamProvider((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

// ---------------------------------------------------------------------
// StateNotifier: orquesta los use cases y expone AuthState a la UI
// ---------------------------------------------------------------------

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    loginUseCase: ref.watch(loginUseCaseProvider),
    registerUseCase: ref.watch(registerUseCaseProvider),
    logoutUseCase: ref.watch(logoutUseCaseProvider),
    getCurrentUserUseCase: ref.watch(getCurrentUserUseCaseProvider),
    sendPasswordResetUseCase: ref.watch(sendPasswordResetUseCaseProvider),
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SendPasswordResetUseCase sendPasswordResetUseCase;

  AuthNotifier({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.sendPasswordResetUseCase,
  }) : super(const AuthInitial()) {
    _checkCurrentSession();
  }

  Future<void> _checkCurrentSession() async {
    state = const AuthLoading();
    final result = await getCurrentUserUseCase(const NoParams());
    result.fold(
      (failure) => state = const AuthUnauthenticated(),
      (user) => state = user != null ? AuthAuthenticated(user) : const AuthUnauthenticated(),
    );
  }

  Future<void> login({required String email, required String password}) async {
    state = const AuthLoading();
    final result = await loginUseCase(LoginParams(email: email, password: password));
    result.fold(
      (failure) => state = AuthError(failure.message),
      (user) => state = AuthAuthenticated(user),
    );
  }

  Future<void> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = const AuthLoading();
    final result = await registerUseCase(
      RegisterParams(email: email, password: password, displayName: displayName),
    );
    result.fold(
      (failure) => state = AuthError(failure.message),
      (user) => state = AuthAuthenticated(user),
    );
  }

  Future<void> logout() async {
    state = const AuthLoading();
    final result = await logoutUseCase(const NoParams());
    result.fold(
      (failure) => state = AuthError(failure.message),
      (_) => state = const AuthUnauthenticated(),
    );
  }

  Future<bool> sendPasswordReset(String email) async {
    final result = await sendPasswordResetUseCase(PasswordResetParams(email));
    return result.fold(
      (failure) {
        state = AuthError(failure.message);
        return false;
      },
      (_) => true,
    );
  }
}
