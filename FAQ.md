# Preguntas Frecuentes (FAQ)

## Arquitectura y Estructura

### ¿Por qué usar Feature-First?
La organización feature-first agrupa todo lo relacionado a una feature en una carpeta. Ventajas:
- Fácil de navegar y entender qué código es responsable de cada feature
- Fácil de eliminar o reutilizar una feature completa
- Mejor escalabilidad a medida que crece la app

### ¿Qué diferencia hay entre Entity, Model y DTO?
- **Entity**: Objeto de negocio puro en la capa Domain (sin dependencias)
- **Model**: Objeto de datos en la capa Data que extiende Entity
- **DTO**: Usado para transferir datos entre capas (aquí los Models actúan como DTO)

### ¿Por qué usar Equatable?
Equatable genera automáticamente `==` y `hashCode` basados en las propiedades. Sin él, dos objetos con iguales valores serían considerados distintos.

## Manejo de Errores

### ¿Cómo agregar un nuevo tipo de error?
1. En `lib/core/errors/exceptions.dart`:
   ```dart
   class MyCustomException extends AppException {
     MyCustomException(String message) : super(message);
   }
   ```

2. En `lib/core/errors/failure.dart`:
   ```dart
   class MyCustomFailure extends Failure {
     const MyCustomFailure(String message) : super(message);
   }
   ```

3. En el datasource, lanzar la excepción
4. En el repositorio, capturar y convertir a Failure

### ¿Cuándo lanzar una excepción vs retornar un Failure?
- **Excepciones**: Se lanzan en datasources cuando ocurre un error
- **Failures**: Se retornan desde repositorios y usecases como parte de Either
- La conversión ocurre en el repositorio

## Firebase

### ¿Por qué no funciona la autenticación?
Checklist:
- [ ] google-services.json está en android/app/
- [ ] GoogleService-Info.plist está en iOS (Xcode)
- [ ] firebase_options.dart tiene credenciales correctas
- [ ] Autenticación por email está habilitada en Firebase Console
- [ ] El email/password son válidos según las reglas de Firebase

### ¿Cómo cambiar de proveedor de autenticación (ej: Google)?
1. Agregar dependencia: `google_sign_in`
2. Crear nuevo método en `AuthRemoteDataSource`:
   ```dart
   Future<UserModel> loginWithGoogle() async { ... }
   ```
3. Agregar método al repositorio y usecase
4. Agregar evento al BLoC
5. Agregar botón en la UI

### ¿Cómo verificar email en Firebase?
Después de registrarse, el usuario debe verificar su email:
```dart
final user = firebaseAuth.currentUser;
if (user != null && !user.emailVerified) {
  await user.sendEmailVerification();
}
```

## State Management con BLoC

### ¿Cómo agregar un nuevo evento?
1. Crear clase en `auth_event.dart`
2. Crear handler `_onMyEvent` en `auth_bloc.dart`
3. Registrar en el constructor: `on<MyEvent>(_onMyEvent)`

### ¿Cuándo usar BlocListener vs BlocBuilder?
- **BlocBuilder**: Para reconstruir la UI basado en el estado
- **BlocListener**: Para ejecutar código (navegación, diálogos, snackbars)

### ¿Puedo combinar BlocListener y BlocBuilder?
Sí, generalmente así:
```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) { /* efectos secundarios */ },
  child: BlocBuilder<AuthBloc, AuthState>(
    builder: (context, state) { /* reconstruir UI */ },
  ),
)
```

## Inyección de Dependencias

### ¿Por qué usar GetIt?
GetIt es un service locator que:
- Centraliza la creación de instancias
- Facilita testing (se pueden registrar mocks)
- Reduce acoplamiento entre capas
- Hace el código más testeable

### ¿Cómo registrar una dependencia?
En `service_locator.dart`:
```dart
getIt.registerSingleton<MyService>(MyService());  // Una instancia
getIt.registerFactory<MyService>(() => MyService()); // Nueva cada vez
```

### ¿Cómo acceder a una dependencia?
```dart
final service = getIt<MyService>();
```

## Testing

### ¿Cómo testear un UseCase?
```dart
test('login should return User on success', () async {
  // Arrange
  when(mockAuthRepository.login(email, password))
      .thenAnswer((_) async => Right(User(...)));
  
  // Act
  final result = await loginUseCase(email, password);
  
  // Assert
  expect(result, Right(User(...)));
});
```

### ¿Cómo mockear Firebase?
Usa `firebase_auth_mocks`:
```dart
final auth = MockFirebaseAuth();
final userCredential = await auth.createUserWithEmailAndPassword(
  email: 'test@test.com',
  password: 'password',
);
```

## Validaciones

### ¿Dónde se valida la entrada del usuario?
- **Presentation Layer**: Validación de formato en widgets
- **Domain Layer**: Validaciones de negocio en usecases
- **Data Layer**: Validaciones de respuesta de servidor

### ¿Cómo agregar una validación personalizada?
En el campo `validator` del `AuthInputField`:
```dart
String? _customValidator(String? value) {
  if (value == null || value.isEmpty) return 'Campo requerido';
  if (!value.contains('@')) return 'Debe contener @';
  return null;
}
```

## Performance

### ¿Cómo mejorar el performance?
- Usar `const` constructores
- Usar `SingleChildScrollView` en listas pequeñas
- Evitar rebuilds innecesarios (usa BlocBuilder bien)
- Usa `flutter run --profile` para medir

### ¿Qué es el hot reload?
Recarga el código sin perder el estado de la app. Útil para desarrollo rápido.
Si no funciona, usa `R` para hot restart (reinicia completamente).

## Versionado y Deploy

### ¿Cómo cambiar la versión de la app?
En `pubspec.yaml`:
```yaml
version: 1.0.0+1  # versionName+versionCode (Android)
```

### ¿Cómo buildear para producción?
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## Preguntas de Negocios

### ¿Cuál es el siguiente paso después de autenticación?
Típicamente:
1. **Home/Dashboard**: Mostrar productos
2. **Catalogo**: Buscar y filtrar productos
3. **Carrito**: Agregar/eliminar productos
4. **Checkout**: Procesar pagos
5. **Ordenes**: Ver historial

### ¿Cómo manejar múltiples idiomas?
Usa `flutter_localization`:
```dart
MaterialApp(
  localizationsDelegates: [...],
  supportedLocales: [Locale('es'), Locale('en')],
)
```

### ¿Cómo agregar un tema oscuro?
Ya está incluido en `AppTheme.darkTheme`. Personaliza según necesites.

## Dudas de Implementación

### ¿Puedo cambiar de BLoC a Provider?
Sí, la arquitectura es agnóstica al state management. Solo necesitarías reemplazar la capa de presentation.

### ¿Puedo agregar más datasources (local + remote)?
Sí, es lo recomendado para offline-first apps:
```dart
AuthRepositoryImpl(
  remoteDataSource: firebaseDataSource,
  localDataSource: sqliteDataSource,
)
```

### ¿Cómo hacer la app offline-first?
1. Agregar `sqflite` o `Hive` para storage local
2. Verificar conectividad con `connectivity_plus`
3. En el repositorio, priorizar datos locales
4. Sincronizar cuando hay conexión

## Contacto y Recursos

- **Documentación Flutter**: https://flutter.dev/docs
- **Firebase Documentation**: https://firebase.flutter.dev
- **BLoC Documentation**: https://bloclibrary.dev
- **Clean Architecture**: https://resocoder.com/flutter-clean-architecture

¿No encontraste la respuesta que buscas? 
Revisa los comentarios en el código o los tests para ver ejemplos adicionales.
