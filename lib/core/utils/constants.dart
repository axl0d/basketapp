// Validación
const String emailRegex =
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

const int minPasswordLength = 6;
const int minNameLength = 3;

// Timeouts
const Duration apiTimeout = Duration(seconds: 30);
const Duration defaultAnimationDuration = Duration(milliseconds: 300);

// Error Messages
class ErrorMessages {
  static const String unknownError = 'Ha ocurrido un error inesperado';
  static const String networkError = 'Error de conexión. Verifica tu internet';
  static const String serverError = 'Error del servidor. Intenta más tarde';
  static const String invalidEmail = 'Email inválido';
  static const String weakPassword = 'Contraseña muy débil';
  static const String emailAlreadyExists = 'El email ya está registrado';
  static const String userNotFound = 'Usuario no encontrado';
  static const String wrongPassword = 'Contraseña incorrecta';
  static const String userDisabled = 'El usuario ha sido deshabilitado';
  static const String operationNotAllowed = 'Operación no permitida';
}

// Validation Messages
class ValidationMessages {
  static const String emailRequired = 'Por favor ingresa tu email';
  static const String passwordRequired = 'Por favor ingresa tu contraseña';
  static const String nameRequired = 'Por favor ingresa tu nombre';
  static const String confirmPasswordRequired = 'Por favor confirma tu contraseña';

  static const String invalidEmailFormat = 'Email inválido';
  static const String passwordTooShort =
      'La contraseña debe tener al menos $minPasswordLength caracteres';
  static const String nameTooShort =
      'El nombre debe tener al menos $minNameLength caracteres';
  static const String passwordsDoNotMatch = 'Las contraseñas no coinciden';
}
