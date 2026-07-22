# Configuración Inicial del Proyecto

## Requisitos Previos

1. **Flutter SDK** (>=3.11.5)
   - Descarga desde: https://flutter.dev/docs/get-started/install
   - Verifica la instalación: `flutter --version`

2. **Dart** (incluido con Flutter)

3. **Git**

4. **IDE** (VS Code, Android Studio o IntelliJ)

5. **Firebase CLI** (para generar google-services.json)
   ```bash
   npm install -g firebase-tools
   firebase login
   ```

## Pasos de Instalación

### 1. Obtener dependencias
```bash
flutter pub get
```

### 2. Configurar Firebase

#### a) Crear proyecto en Firebase Console
1. Ve a https://console.firebase.google.com
2. Crea un nuevo proyecto llamado "basketapp"
3. Activa autenticación por Email/Password:
   - Ve a Authentication → Sign-in method
   - Activa Email/Password

#### b) Registrar app en Firebase

**Para Web:**
1. Ve a Project Settings → General
2. Agrega una nueva app → Web
3. Copia las credenciales y actualiza `lib/firebase_options.dart`

**Para Android:**
1. En Firebase Console: Agrega Android app
2. Nombre del paquete: `com.example.basketapp`
3. SHA-1: Obtén con `./gradlew signingReport` en `android/`
4. Descarga `google-services.json`
5. Coloca en `android/app/google-services.json`

**Para iOS:**
1. En Firebase Console: Agrega iOS app
2. Bundle ID: `com.example.basketapp`
3. Descarga `GoogleService-Info.plist`
4. Abre `ios/Runner.xcworkspace` en Xcode
5. Arrastra el archivo a Xcode (marcar "Copy if needed")

### 3. Actualizar firebase_options.dart

Edita `lib/firebase_options.dart` con tus credenciales de Firebase:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR_API_KEY_FROM_FIREBASE',
  appId: 'YOUR_APP_ID_FROM_FIREBASE',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'basketapp', // Tu project ID
  authDomain: 'basketapp.firebaseapp.com',
  storageBucket: 'basketapp.appspot.com',
  measurementId: 'YOUR_MEASUREMENT_ID',
);
```

## Ejecutar la Aplicación

### En emulador/dispositivo Android
```bash
flutter run -d android
```

### En emulador/simulador iOS
```bash
flutter run -d ios
```

### En web (preview)
```bash
flutter run -d chrome
```

### Modos de ejecución
```bash
flutter run                    # Debug (hot reload)
flutter run --release          # Release optimizado
flutter run --profile          # Para análisis de performance
```

## Verificar la Configuración

```bash
# Analizar el código
flutter analyze

# Ejecutar tests
flutter test

# Ver información del proyecto
flutter doctor
```

## Estructura de Carpetas Esperada

Después de completar la configuración, la estructura debería ser:

```
basketapp/
├── lib/                                    # Código de la app
│   ├── core/                              # Código compartido
│   ├── features/                          # Features
│   ├── firebase_options.dart              # Configuración de Firebase
│   └── main.dart
├── android/
│   └── app/
│       └── google-services.json           # (Agregar después)
├── ios/
│   └── Runner/
│       └── GoogleService-Info.plist       # (Agregar después)
├── test/                                  # Tests
├── pubspec.yaml                           # Dependencias
├── ARCHITECTURE.md                        # Documentación de arquitectura
└── SETUP.md                              # Este archivo
```

## Solución de Problemas

### Error: "Gradle project detected"
```bash
cd android
./gradlew clean
cd ..
flutter pub get
```

### Error: "CocoaPods could not find compatible versions"
```bash
cd ios
rm -rf Pods Podfile.lock
cd ..
flutter pub get
```

### Firebase no conecta
- Verifica que `firebase_options.dart` tenga credenciales correctas
- Comprueba que `google-services.json` esté en la ubicación correcta
- Verifica que la autenticación por email esté habilitada en Firebase Console

### Hot Reload no funciona
Usa hot restart:
```bash
# En la terminal ejecutando Flutter
r  # Hot reload
R  # Hot restart
```

## Próximos Pasos

1. **Agregar Productos Feature**
   - Crear estructura similar a `features/auth`
   - DataSource con Firebase Firestore
   - Modelos, Entities y Repositories
   - BLoC para state management

2. **Carrito de Compras**
   - Feature con persistencia local
   - Usar SharedPreferences o Hive

3. **Ordenes**
   - Guardar historial en Firebase
   - Estado de órdenes

4. **Perfil de Usuario**
   - Actualizar información
   - Direcciones de entrega

## Recursos Útiles

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase for Flutter](https://firebase.flutter.dev)
- [BLoC Pattern](https://bloclibrary.dev)
- [Clean Architecture](https://resocoder.com/flutter-clean-architecture)

## Contacto y Soporte

Para preguntas sobre la arquitectura o implementación, revisa:
- `ARCHITECTURE.md` - Detalles de la arquitectura
- `CLAUDE.md` - Instrucciones del proyecto
