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
    },
    'es': {
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
  // ... otros getters ...
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
