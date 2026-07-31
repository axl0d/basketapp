# Arquitectura BasketApp

## Descripción General

BasketApp está construida siguiendo una arquitectura **feature-first** con **separación de capas clara** y **manejo robusto de errores**. Utiliza Firebase para autenticación.

## Estructura del Proyecto

```
lib/
├── core/
│   ├── di/
│   │   └── service_locator.dart          # Inyección de dependencias (GetIt)
│   ├── errors/
│   │   ├── exceptions.dart               # Excepciones específicas
│   │   └── failure.dart                  # Representación de fallos (Either)
│   └── theme/
│       └── app_theme.dart                # Temas de la aplicación
│
├── features/
│   ├── auth/                             # Feature de Autenticación
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_data_source.dart   # Fuente de datos remota
│   │   │   ├── models/
│   │   │   │   └── user_model.dart               # Modelo de Usuario
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart     # Implementación del repositorio
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart                     # Entidad Usuario
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart          # Interfaz del repositorio
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart            # Caso de uso: Login
│   │   │       ├── register_usecase.dart         # Caso de uso: Registro
│   │   │       ├── logout_usecase.dart           # Caso de uso: Logout
│   │   │       └── get_current_user_usecase.dart # Caso de uso: Obtener usuario
│   │   │
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart        # Lógica de estado
│   │       │   ├── auth_event.dart       # Eventos
│   │       │   └── auth_state.dart       # Estados
│   │       ├── pages/
│   │       │   ├── login_page.dart       # Pantalla de login
│   │       │   ├── register_page.dart    # Pantalla de registro
│   │       │   └── splash_page.dart      # Pantalla de inicio
│   │       └── widgets/
│   │           ├── auth_input_field.dart # Campo de entrada personalizado
│   │           └── auth_button.dart      # Botón personalizado
│   │
│   └── home/
│       └── presentation/
│           └── pages/
│               └── home_page.dart        # Pantalla principal
│
└── main.dart                             # Punto de entrada
```

## Capas de la Arquitectura

### 1. **Presentation Layer** (Presentación)
- Contiene BLoCs, Pages y Widgets
- **BLoC**: Gestiona el estado de la UI usando flutter_bloc
- **Pages**: Vistas principales
- **Widgets**: Componentes reutilizables
- Solo conoce sobre la capa Domain

### 2. **Domain Layer** (Dominio)
- Contiene Entities, Repositories (abstracciones) y UseCases
- **Entities**: Objetos de negocio puros (sin dependencias)
- **Repositories**: Interfaces que definen los contratos
- **UseCases**: Casos de uso de negocio independientes
- No depende de ninguna otra capa

### 3. **Data Layer** (Datos)
- Contiene DataSources, Models y Repository Implementations
- **DataSources**: Fuentes de datos (Firebase, APIs, bases de datos locales)
- **Models**: Representación de datos (extienden Entities)
- **Repositories**: Implementaciones concretas
- Convierte excepciones en Failures

## Patrones y Conceptos

### Either/Result Pattern
Usamos `dartz` para manejar resultados que pueden ser éxito o fallo:

```dart
Future<Either<Failure, User>> login(String email, String password);
// Left = Failure
// Right = User
```

### Manejo de Errores
- **Exceptions**: Se lanzan en la capa de datos
- **Failures**: Representan fallos en el dominio
- La capa de datos convierte excepciones en failures

### Inyección de Dependencias
Usando `get_it` para un localizador de servicios centralizado:

```dart
// En service_locator.dart
getIt.registerSingleton<AuthBloc>(...);

// En otros lugares
final authBloc = getIt<AuthBloc>();
```

### State Management
Usamos `flutter_bloc` para gestionar el estado de la aplicación:

```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) { ... },
);

BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) { ... },
);
```

## Configuración de Firebase

### Paso 1: Crear proyecto en Firebase Console
1. Ve a https://console.firebase.google.com
2. Crea un nuevo proyecto
3. Activa autenticación por Email/Password

### Paso 2: Configurar credenciales
Edita `lib/firebase_options.dart` con tus credenciales:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'tu-api-key',
  appId: 'tu-app-id',
  messagingSenderId: 'tu-messaging-sender-id',
  projectId: 'tu-project-id',
  authDomain: 'tu-auth-domain',
  storageBucket: 'tu-storage-bucket',
);
```

### Paso 3: Para Android
Descarga el archivo `google-services.json` y colócalo en `android/app/`:
- Obtén el archivo desde Firebase Console
- Colócalo en `android/app/google-services.json`

### Paso 4: Para iOS
1. Descarga el archivo `GoogleService-Info.plist` desde Firebase Console
2. Abre `ios/Runner.xcworkspace` en Xcode
3. Arrastra el archivo a Xcode (selecciona "Copy if needed")

## Flujo de Autenticación

1. **Splash Page** → Verifica si hay usuario autenticado
2. **Si hay usuario** → Navega a Home Page
3. **Si no hay usuario** → Navega a Login Page
4. Usuario puede hacer login o ir a Register Page
5. Después de autenticación exitosa → Home Page

## Validación de Datos

### Email
- No vacío
- Formato válido de email

### Contraseña
- Mínimo 6 caracteres
- Login requiere coincidir con la registrada

### Nombre
- No vacío
- Mínimo 3 caracteres

## Extensiones Futuras

Para agregar nuevas features:

1. Crear nueva carpeta en `features/`
2. Seguir la misma estructura (data/domain/presentation)
3. Crear nuevas excepciones/failures si es necesario
4. Registrar en `service_locator.dart`

## Testing

Para crear tests unitarios/de integración:

```bash
# Tests unitarios
flutter test test/features/auth/domain/usecases/login_usecase_test.dart

# Tests de widgets
flutter test test/features/auth/presentation/pages/login_page_test.dart
```

## Buenas Prácticas Aplicadas

✅ Clean Architecture con separación clara de capas
✅ Feature-first organization
✅ Inyección de dependencias con GetIt
✅ Manejo de errores con Either pattern
✅ BLoC para state management
✅ Validación de entradas del usuario
✅ Uso de Equatable para comparación de objetos
✅ Widgets reutilizables
✅ Comentarios solo cuando es necesario
✅ Naming conventions claros
