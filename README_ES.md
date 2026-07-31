# BasketApp - E-Commerce en Flutter

Una aplicación e-commerce moderna construida con **Flutter**, siguiendo **Clean Architecture** y **Feature-First** organization. Incluye autenticación robusta con **Firebase** y manejo profesional de errores.

## 🎯 Características

- ✅ **Autenticación Firebase**: Login y registro seguro
- ✅ **Clean Architecture**: Separación clara de capas
- ✅ **Feature-First**: Organización escalable
- ✅ **BLoC Pattern**: State management reactivo
- ✅ **Manejo de Errores**: Either/Result pattern
- ✅ **Inyección de Dependencias**: Con GetIt
- ✅ **Validación**: Completa en capas
- ✅ **Material Design**: UI moderna y responsiva

## 📋 Requisitos Previos

```bash
# Flutter (>=3.11.5)
flutter --version

# Dart (incluido con Flutter)
dart --version

# Firebase CLI (opcional, para setup)
npm install -g firebase-tools
```

## 🚀 Inicio Rápido

### 1. Clonar y preparar
```bash
cd basketapp
flutter pub get
```

### 2. Configurar Firebase
Ver [SETUP.md](./SETUP.md) para instrucciones detalladas

### 3. Ejecutar
```bash
flutter run
```

## 📁 Estructura del Proyecto

```
basketapp/
├── lib/
│   ├── core/                    # Código compartido
│   │   ├── di/                 # Inyección de dependencias
│   │   ├── errors/             # Manejo de errores
│   │   ├── theme/              # Temas
│   │   └── utils/              # Utilidades
│   │
│   ├── features/                # Features
│   │   ├── auth/               # Autenticación
│   │   │   ├── data/          # Data layer
│   │   │   ├── domain/        # Business logic
│   │   │   └── presentation/  # UI
│   │   │
│   │   └── home/              # Home (próximamente: productos)
│   │
│   ├── routes.dart             # Rutas de la app
│   ├── firebase_options.dart   # Config de Firebase
│   └── main.dart               # Punto de entrada
│
├── test/                        # Tests
├── pubspec.yaml                # Dependencias
├── ARCHITECTURE.md             # Documentación técnica
├── SETUP.md                    # Guía de configuración
├── FAQ.md                      # Preguntas frecuentes
└── README_ES.md               # Este archivo
```

## 🏗️ Arquitectura

La aplicación está dividida en **3 capas principales**:

### Presentation Layer
- Widgets, Pages y BLoC
- Gestiona la interfaz de usuario
- Comunica eventos al BLoC

### Domain Layer
- Entities, Repositories (interfaces) y UseCases
- Contiene la lógica de negocio pura
- Independiente de frameworks

### Data Layer
- DataSources (Firebase), Models y Repository Implementations
- Obtiene datos de fuentes remotas/locales
- Convierte excepciones en Failures

## 🔐 Autenticación Firebase

### Flujo
1. **Splash Screen** → Verifica si está logueado
2. **Login/Register** → Si no hay sesión
3. **Home** → Si hay sesión activa

### Credenciales
Las credenciales de Firebase se guardan en `lib/firebase_options.dart`

```dart
// Actualiza con tus valores de Firebase Console
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'tu-api-key',
  appId: 'tu-app-id',
  projectId: 'tu-project-id',
  // ... más campos
);
```

## 🎮 Manejo de Estado

Usamos **flutter_bloc** para state management:

```dart
// Escuchar cambios de estado
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthError) {
      // Mostrar error
    }
  },
  child: ...,
);

// Reconstruir UI basado en estado
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    if (state is AuthLoading) return LoadingWidget();
    if (state is AuthAuthenticated) return HomeWidget();
    return LoginWidget();
  },
);
```

## ⚠️ Manejo de Errores

Usamos el **Either pattern** de `dartz`:

```dart
// En UseCases y Repositories
Future<Either<Failure, User>> login(String email, String password);

// Uso
final result = await loginUseCase(email, password);
result.fold(
  (failure) => print('Error: ${failure.message}'),
  (user) => print('Éxito: ${user.email}'),
);
```

## 💉 Inyección de Dependencias

Configurado en `lib/core/di/service_locator.dart`:

```dart
// En main.dart
await setupServiceLocator();

// En otros lugares
final authBloc = getIt<AuthBloc>();
```

## ✅ Validaciones

### Email
- No vacío
- Formato válido

### Contraseña
- Mínimo 6 caracteres
- Confirmación coincide

### Nombre
- No vacío
- Mínimo 3 caracteres

## 📱 Soporte de Plataformas

- ✅ Android
- ✅ iOS
- ✅ Web
- ⚠️ Windows/macOS (requiere configuración adicional)

## 🧪 Testing

```bash
# Tests unitarios
flutter test

# Con cobertura
flutter test --coverage

# Test específico
flutter test test/features/auth/domain/usecases/
```

## 📚 Documentación

- [ARCHITECTURE.md](./ARCHITECTURE.md) - Detalles de la arquitectura
- [SETUP.md](./SETUP.md) - Guía de configuración detallada
- [FAQ.md](./FAQ.md) - Preguntas frecuentes
- [CLAUDE.md](./CLAUDE.md) - Instrucciones del proyecto

## 🔧 Comandos Útiles

```bash
# Instalar dependencias
flutter pub get

# Analizar código
flutter analyze

# Formatear código
dart format lib/

# Ejecutar aplicación
flutter run                  # Debug
flutter run --release        # Producción
flutter run --profile        # Análisis de performance

# Build
flutter build apk            # Android
flutter build ios            # iOS
flutter build web            # Web

# Ver logs
flutter logs

# Limpiar
flutter clean
```

## 📦 Dependencias Principales

- **firebase_core** - Firebase
- **firebase_auth** - Autenticación
- **flutter_bloc** - State Management
- **get_it** - Service Locator
- **dartz** - Functional Programming
- **equatable** - Equality
- **connectivity_plus** - Conectividad

## 🎨 Temas

La aplicación incluye tema claro y oscuro personalizados en `lib/core/theme/app_theme.dart`

```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
);
```

## 🚀 Próximos Pasos

### Features Planeadas
1. **Productos** - Catálogo de productos
2. **Carrito** - Gestión de carrito de compras
3. **Órdenes** - Historial de compras
4. **Perfil** - Información del usuario
5. **Pagos** - Integración con Stripe/PayPal

### Mejoras Técnicas
- [ ] Tests unitarios completos
- [ ] Tests de integración
- [ ] Offline-first con Hive
- [ ] Múltiples idiomas
- [ ] Analytics con Firebase

## 🐛 Troubleshooting

### Flutter no está instalado
```bash
# Descarga desde https://flutter.dev/docs/get-started/install
flutter --version
```

### Firebase no conecta
1. Verifica credenciales en `firebase_options.dart`
2. Comprueba `google-services.json` (Android)
3. Comprueba `GoogleService-Info.plist` (iOS)
4. Habilita Email/Password en Firebase Console

### Hot Reload no funciona
```bash
# Usa Hot Restart
R  # En la terminal de Flutter
```

Ver [SETUP.md](./SETUP.md) para más soluciones.

## 📄 Licencia

Este proyecto es de código abierto. Úsalo libremente.

## 👨‍💻 Autor

Desarrollado con ❤️ usando Flutter y Firebase

---

**¿Necesitas ayuda?**
- Consulta [FAQ.md](./FAQ.md)
- Lee [ARCHITECTURE.md](./ARCHITECTURE.md)
- Revisa [SETUP.md](./SETUP.md)

Happy coding! 🚀
