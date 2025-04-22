// lib/l10n/app_localizations_setup.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('es', 'ES'),
    Locale('en', 'US'),
  ];

  // Diccionario simple de traducciones
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Textos generales
      'settings': 'Settings',
      'theme': 'Theme',
      'darkMode': 'Dark Mode',
      'notifications': 'Notifications',
      'enableNotifications': 'Enable Notifications',
      'language': 'Language',
      'accessibility': 'Accessibility',
      'highContrast': 'High Contrast',
      'textSize': 'Text Size',
      'appInfo': 'App Information',
      'version': 'Version',
      'about': 'About',
      'close': 'Close',
      'spanish': 'Spanish',
      'english': 'English',

      // Textos para Login
      'login': 'Login',
      'documentNumber': 'Document Number',
      'password': 'Password',
      'loginWithFingerprint': 'Login with Fingerprint',
      'forgotPassword': 'Forgot your password?',
      'dontHaveAccount': 'Don\'t have an account?',
      'register': 'Register',
      'incorrectPassword': 'Incorrect password',
      'loginError': 'Login error',
      'biometricAuthFailed': 'Biometric authentication failed',
      'biometricError': 'Biometric error',
      'fieldRequired': 'is required',
      'pleaseEnter': 'Please enter',

      // Textos para Reset Password
      'resetPassword': 'Reset Password',
      'enterEmailForReset': 'Enter your email to receive a password reset link',
      'sendResetLink': 'Send Reset Link',
      'resetEmailSent': 'A password reset email has been sent',
      'enterValidEmail': 'Please enter a valid email',
      'emailRequired': 'Email is required',
      'backToLogin': 'Back to Login',

      // Textos para Register
      'fullName': 'Full Name',
      'documentType': 'Document Type',
      'phone': 'Phone',
      'confirmPassword': 'Confirm Password',
      'createAccount': 'Create Account',
      'alreadyHaveAccount': 'Already have an account? Sign in',
      'selectDocumentType': 'Select a document type',
      'enterDocumentNumber': 'Please enter document number',
      'invalidEmailFormat': 'Invalid email format',
      'enterPassword': 'Please enter your password',
      'passwordLength': 'Password must be at least 6 characters',
      'confirmYourPassword': 'Confirm your password',
      'passwordsDontMatch': 'Passwords do not match',
      'registerError': 'Error registering user. Please try again.',
      'CC': 'CC',
      'TI': 'IC',
      'CE': 'FID',
      'PP': 'PP',
    },
    'es': {
      // Textos generales
      'settings': 'Configuración',
      'theme': 'Tema',
      'darkMode': 'Tema Oscuro',
      'notifications': 'Notificaciones',
      'enableNotifications': 'Habilitar Notificaciones',
      'language': 'Idioma',
      'accessibility': 'Accesibilidad',
      'highContrast': 'Alto Contraste',
      'textSize': 'Tamaño del Texto',
      'appInfo': 'Información de la Aplicación',
      'version': 'Versión',
      'about': 'Acerca de',
      'close': 'Cerrar',
      'spanish': 'Español',
      'english': 'Inglés',

      // Textos para Login
      'login': 'Iniciar sesión',
      'documentNumber': 'Número de Documento',
      'password': 'Contraseña',
      'loginWithFingerprint': 'Iniciar sesión con huella',
      'forgotPassword': '¿Olvidaste tu contraseña?',
      'dontHaveAccount': '¿No tienes cuenta?',
      'register': 'Regístrate',
      'incorrectPassword': 'Contraseña incorrecta',
      'loginError': 'Error al iniciar sesión',
      'biometricAuthFailed': 'Autenticación biométrica fallida',
      'biometricError': 'Error en la autenticación biométrica',
      'fieldRequired': 'es requerido',
      'pleaseEnter': 'Por favor ingresa',

      // Textos para Reset Password
      'resetPassword': 'Cambiar Contraseña',
      'enterEmailForReset':
          'Ingresa tu correo para recibir un enlace de recuperación de contraseña',
      'sendResetLink': 'Enviar Correo de Recuperación',
      'resetEmailSent':
          'Se ha enviado un correo para restablecer tu contraseña',
      'enterValidEmail': 'Ingresa un correo válido',
      'emailRequired': 'Por favor ingresa tu correo electrónico',
      'backToLogin': 'Volver al Inicio de Sesión',

      // Textos para Register
      'fullName': 'Nombre completo',
      'documentType': 'Tipo de documento',
      'phone': 'Teléfono',
      'confirmPassword': 'Confirmar contraseña',
      'createAccount': 'Crear cuenta',
      'alreadyHaveAccount': '¿Ya tienes una cuenta? Inicia sesión',
      'selectDocumentType': 'Selecciona un tipo de documento',
      'enterDocumentNumber': 'Por favor ingresa el número de documento',
      'invalidEmailFormat': 'Formato de correo inválido',
      'enterPassword': 'Por favor ingresa tu contraseña',
      'passwordLength': 'La contraseña debe tener al menos 6 caracteres',
      'confirmYourPassword': 'Confirma tu contraseña',
      'passwordsDontMatch': 'Las contraseñas no coinciden',
      'registerError': 'Error al registrar usuario. Inténtalo de nuevo.',
      'CC': 'Cédula de Ciudadanía',
      'TI': 'Tarjeta de Identidad',
      'CE': 'Cédula de Extranjería',
      'PP': 'Pasaporte',
    },
  };

  // Accesores de traducciones
  String translate(String key) {
    try {
      return _localizedValues[locale.languageCode]?[key] ??
          _localizedValues['es']?[key] ??
          key;
    } catch (e) {
      debugPrint('Translation error for key "$key": $e');
      return key;
    }
  }

  // Métodos de acceso directo (opcionales pero útiles)
  static String getSettings(BuildContext context) =>
      of(context).translate('settings');
  static String getDarkMode(BuildContext context) =>
      of(context).translate('darkMode');
  // Añade todos los que necesites...

  String get settings => translate('settings');
  String get theme => translate('theme');
  String get darkMode => translate('darkMode');
  String get notifications => translate('notifications');
  String get enableNotifications => translate('enableNotifications');
  String get language => translate('language');
  String get accessibility => translate('accessibility');
  String get highContrast => translate('highContrast');
  String get textSize => translate('textSize');
  String get appInfo => translate('appInfo');
  String get version => translate('version');
  String get about => translate('about');
  String get close => translate('close');
  // Textos para LoginView
  String get login => translate('login');
  String get documentNumber => translate('documentNumber');
  String get password => translate('password');
  String get loginWithFingerprint => translate('loginWithFingerprint');
  String get forgotPassword => translate('forgotPassword');
  String get dontHaveAccount => translate('dontHaveAccount');
  String get register => translate('register');
  String get incorrectPassword => translate('incorrectPassword');
  String get loginError => translate('loginError');
  String get biometricAuthFailed => translate('biometricAuthFailed');
  String get biometricError => translate('biometricError');
  String get fieldRequired => translate('fieldRequired');
  String get pleaseEnter => translate('pleaseEnter');
  // Mensajes de validación
  String get pleaseEnterDocument => translate('pleaseEnterDocument');
  String get pleaseEnterPassword => translate('pleaseEnterPassword');
  // Textos para Forgot password
  String get resetPassword => translate('resetPassword');
  String get enterEmailForReset => translate('enterEmailForReset');
  String get email => translate('email');
  String get sendResetLink => translate('sendResetLink');
  String get resetEmailSent => translate('resetEmailSent');
  String get enterValidEmail => translate('enterValidEmail');
  String get emailRequired => translate('emailRequired');
  String get backToLogin => translate('backToLogin');
  // Textos para Registrar usuario
  String get fullName => translate('fullName');
  String get documentType => translate('documentType');
  String get phone => translate('phone');
  String get confirmPassword => translate('confirmPassword');
  String get createAccount => translate('createAccount');
  String get alreadyHaveAccount => translate('alreadyHaveAccount');
  String get selectDocumentType => translate('selectDocumentType');
  String get enterDocumentNumber => translate('enterDocumentNumber');
  String get invalidEmailFormat => translate('invalidEmailFormat');
  String get enterPassword => translate('enterPassword');
  String get passwordLength => translate('passwordLength');
  String get confirmYourPassword => translate('confirmYourPassword');
  String get passwordsDontMatch => translate('passwordsDontMatch');
  String get registerError => translate('registerError');
  String get cc => translate('CC');
  String get ti => translate('TI');
  String get ce => translate('CE');
  String get pp => translate('PP');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['es', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
