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

      //Textos para home view
      'hello': 'Hello',
      'loading': 'Loading...',
      'name': 'Name',
      'confirm': 'Confirm',
      'user': 'User',
      'error': 'Error',

      // Balance Section
      'availableBalance': 'Available balance',
      'loadingBalance': 'Loading balance...',

      // Transfer Dialog
      'makeTransfer': 'Make Transfer',
      'recipientPhone': 'Recipient phone number',
      'transferAmount': 'Amount to transfer',
      'cancel': 'Cancel',
      'transfer': 'Transfer',
      'invalidData': 'Please enter valid data',
      'recipientNotFound': 'Recipient not found',
      'nameNotFound': 'Recipient name not found',

      // Transfer Confirmation
      'confirmTransfer': 'Confirm Transfer',
      'recipient': 'Recipient',
      'amount': 'Amount',
      'date': 'Date',
      'time': 'Time',
      'reference': 'Reference',
      'successfulTransfer': 'Transfer successful',
      'unauthenticatedUser': 'Unauthenticated user',
      'senderNotFound': 'Sender not found',
      'incompleteSenderData': 'Incomplete sender data',
      'incompleteRecipientData': 'Incomplete recipient data',

      // Transaction History
      'transactionHistory': 'Transaction History',
      'noRecentTransactions': 'No recent transactions',
      'viewAllTransactions': 'View all transactions',
      'sentTo': 'Sent to',
      'receivedFrom': 'Received from',
      'transferDetails': 'Transfer Details',
      'receptionDetails': 'Reception Details',

      // Menu Options
      'simpleInterest': 'Simple Interest',
      'compoundInterest': 'Compound Interest',
      'gradients': 'Gradients',
      'amortization': 'Amortization',
      'irr': 'IRR',
      'uvr': 'RVU',
      'capitalization': 'Capitalization',
      'inflation': 'Inflation',

      //Transacciones view
      'transactions': 'Transactions',
      'loadMoreTransactions': 'Load more transactions',

      //Profile view
      'editProfile': 'Edit Profile',
      'profile': 'Profile',
      'profileUpdatedSuccessfully': 'Profile updated successfully',
      'errorUpdatingProfile': 'Error updating profile',
      'saveChanges': 'Save Changes',
      'changePassword': 'Change your password',
      'email': 'Email',
      'userDataNotFound': 'User data not found',

      //navbar
      "home": "Home",

      //settings view
      "darkTheme": "Dark Theme",
      "aboutEconoEngine": "About EconoEngine",
      "aboutEconoEngineText1": "EconoEngine version 2.0.0",
      "aboutEconoEngineText2": "An app to manage your finances efficiently.",
      "aboutEconoEngineText3": "© 2025 EconoEngine",

      //interes simple
      "present_value": "Present Value (PV)",
      "future_value": "Future Value (FV)",
      "interest_rate": "Interest Rate (i)",
      "rate": "Rate",
      "rate_unit": "Rate Unit",
      "tiempo": "Time (t)",
      "time_unit": "Time Unit",
      "calculate_fv": "Calculate FV",
      "calculate_pv": "Calculate PV",
      "calculate_i": "Calculate i",
      "calculate_t": "Calculate t",
      "days": "days",
      "months": "months",
      "quarters": "quarters",
      "semesters": "semesters",
      "years": "years",
      "daily": "daily",
      "monthly": "monthly",
      "quarterly": "quarterly",
      "semiannually": "semiannually",
      "annually": "annually",

      //interes compuesto
      'initialCapital': 'Initial Capital (C)',
      'compoundAmount': 'Compound Amount (MC)',
      'interestRate': 'Interest Rate (i)',
      'tiempoInteresCompuesto': 'Time (n)',
      'semiannual': 'semiannual',
      'annual': 'annual',
      'rateUnit': 'Rate Unit',
      'timeUnit': 'Time Unit',
      'calculateMC': 'Calculate MC',
      'calculaten': 'Calculate n',
      'calculatei': 'Calculate i',
      'result': 'Result',

      'invalidCapital': 'Invalid Capital',
      'invalidAmount': 'Invalid Amount',
      'invalidRate': 'Invalid Rate',
      'invalidTime': 'Invalid Time',
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
      'CC': 'CC',
      'TI': 'TI',
      'CE': 'CE',
      'PP': 'PP',

      //textos para home view
      // General
      'hello': 'Hola',
      'name': 'Nombre',
      'confirm': 'Confirmar',
      'loading': 'Cargando...',
      'user': 'Usuario',
      'error': 'Error',

      // Balance Section
      'availableBalance': 'Saldo disponible',
      'loadingBalance': 'Cargando saldo...',

      // Transfer Dialog
      'makeTransfer': 'Realizar Transferencia',
      'recipientPhone': 'Número de teléfono del destinatario',
      'transferAmount': 'Monto a transferir',
      'cancel': 'Cancelar',
      'transfer': 'Transferir',
      'invalidData': 'Por favor ingrese datos válidos',
      'recipientNotFound': 'Destinatario no encontrado',
      'nameNotFound': 'Nombre del destinatario no encontrado',

      // Transfer Confirmation
      'confirmTransfer': 'Confirmar Transferencia',
      'recipient': 'Destinatario',
      'amount': 'Monto',
      'date': 'Fecha',
      'time': 'Hora',
      'reference': 'Referencia',
      'successfulTransfer': 'Transferencia exitosa',
      'unauthenticatedUser': 'Usuario no autenticado',
      'senderNotFound': 'Remitente no encontrado',
      'incompleteSenderData': 'Datos del remitente incompletos',
      'incompleteRecipientData': 'Datos del destinatario incompletos',

      // Transaction History
      'transactionHistory': 'Historial de Transacciones',
      'noRecentTransactions': 'No hay transacciones recientes',
      'viewAllTransactions': 'Ver todas las transacciones',
      'sentTo': 'Enviado a',
      'receivedFrom': 'Recibido de',
      'transferDetails': 'Detalles del Envío',
      'receptionDetails': 'Detalles de la Recepción',

      // Menu Options
      'simpleInterest': 'Interés Simple',
      'compoundInterest': 'Interés Compuesto',
      'gradients': 'Gradientes',
      'amortization': 'Amortización',
      'irr': 'TIR',
      'uvr': 'UVR',
      'capitalization': 'Capitalización',
      'inflation': 'Inflación',

      //Transacciones view
      'transactions': 'Movimientos',
      'loadMoreTransactions': 'Cargar más movimientos',

      //profile view
      'editProfile': 'Editar Perfil',
      'profile': 'Perfil',
      'profileUpdatedSuccessfully': 'Perfil actualizado exitosamente',
      'errorUpdatingProfile': 'Error al actualizar perfil',
      'saveChanges': 'Guardar Cambios',
      'changePassword': 'Deseas cambiar tu contraseña',
      'email': 'Correo electrónico',
      'userDataNotFound': 'No se encontraron datos del usuario',

      //navbar
      "home": "Inicio",

      //settings view
      "darkTheme": "Tema Oscuro",
      "aboutEconoEngine": "Acerca de EconoEngine",
      "aboutEconoEngineText1": "EconoEngine versión 2.0.0",
      "aboutEconoEngineText2":
          "Una aplicación para gestionar tus finanzas de manera eficiente.",
      "aboutEconoEngineText3": "© 2025 EconoEngine",

      //interes simple
      "present_value": "Valor Presente (VP)",
      "future_value": "Valor Futuro (VF)",
      "interest_rate": "Tasa de Interés (i)",
      "rate": "Tasa",
      "rate_unit": "Unidad de Tasa",
      "tiempo": "Tiempo (t)",
      "time_unit": "Unidad de Tiempo",
      "calculate_fv": "Calcular VF",
      "calculate_pv": "Calcular VP",
      "calculate_i": "Calcular i",
      "calculate_t": "Calcular t",
      "days": "días",
      "months": "meses",
      "quarters": "trimestres",
      "semesters": "semestres",
      "years": "años",
      "daily": "diaria",
      "monthly": "mensual",
      "quarterly": "trimestral",
      "semiannually": "semestral",
      "annually": "anual",

      //interes compuesto
      'initialCapital': 'Capital Inicial (C)',
      'compoundAmount': 'Monto Compuesto (MC)',
      'interestRate': 'Tasa de Interés (i)',
      'tiempoInteresCompuesto': 'Tiempo (n)',
      'semiannual': 'semestral',
      'annual': 'anual',
      'rateUnit': 'Unidad de Tasa',
      'timeUnit': 'Unidad de Tiempo',
      'calculateMC': 'Calcular MC',
      'calculaten': 'Calcular n',
      'calculatei': 'Calcular i',
      'result': 'Resultado',

      'invalidCapital': 'Capital inválido',
      'invalidAmount': 'Monto inválido',
      'invalidRate': 'Tasa inválida',
      'invalidTime': 'Tiempo inválido',
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

  // Home view
  String get hello => translate('hello');
  String get loading => translate('loading');
  String get name => translate('name');
  String get confirm => translate('confirm');
  String get user => translate('user');
  String get error => translate('error');

  // Balance Section
  String get availableBalance => translate('availableBalance');
  String get loadingBalance => translate('loadingBalance');

  // Transfer Dialog
  String get makeTransfer => translate('makeTransfer');
  String get recipientPhone => translate('recipientPhone');
  String get transferAmount => translate('transferAmount');
  String get cancel => translate('cancel');
  String get transfer => translate('transfer');
  String get invalidData => translate('invalidData');
  String get recipientNotFound => translate('recipientNotFound');
  String get nameNotFound => translate('nameNotFound');

  // Transfer Confirmation
  String get confirmTransfer => translate('confirmTransfer');
  String get recipient => translate('recipient');
  String get amount => translate('amount');
  String get date => translate('date');
  String get time => translate('time');
  String get reference => translate('reference');
  String get successfulTransfer => translate('successfulTransfer');
  String get unauthenticatedUser => translate('unauthenticatedUser');
  String get senderNotFound => translate('senderNotFound');
  String get incompleteSenderData => translate('incompleteSenderData');
  String get incompleteRecipientData => translate('incompleteRecipientData');

  // Transaction History
  String get transactionHistory => translate('transactionHistory');
  String get noRecentTransactions => translate('noRecentTransactions');
  String get viewAllTransactions => translate('viewAllTransactions');
  String get sentTo => translate('sentTo');
  String get receivedFrom => translate('receivedFrom');
  String get transferDetails => translate('transferDetails');
  String get receptionDetails => translate('receptionDetails');

  // Menu Options
  String get simpleInterest => translate('simpleInterest');
  String get compoundInterest => translate('compoundInterest');
  String get gradients => translate('gradients');
  String get amortization => translate('amortization');
  String get irr => translate('irr');
  String get uvr => translate('uvr');
  String get capitalization => translate('capitalization');
  String get inflation => translate('inflation');

  //transaccion view
  String get transactions => translate('transactions');
  String get loadMoreTransactions => translate('loadMoreTransactions');

  //profile view
  String get editProfile => translate('editProfile');
  String get profile => translate('profile');
  String get profileUpdatedSuccessfully =>
      translate('profileUpdatedSuccessfully');
  String get errorUpdatingProfile => translate('errorUpdatingProfile');
  String get saveChanges => translate('saveChanges');
  String get changePassword => translate('changePassword');
  String get userDataNotFound => translate('userDataNotFound');

  //navbar
  String get home => translate('home');

  //settigns view
  String get darkTheme => translate('darkTheme');
  String get spanish => translate('spanish');
  String get english => translate('english');
  String get aboutEconoEngine => translate('aboutEconoEngine');
  String get aboutEconoEngineText1 => translate('aboutEconoEngineText1');
  String get aboutEconoEngineText2 => translate('aboutEconoEngineText2');
  String get aboutEconoEngineText3 => translate('aboutEconoEngineText3');

  //interes simple
  String get presentValue => translate('present_value');
  String get futureValue => translate('future_value');
  String get interestRate => translate('interest_rate');
  String get rate => translate('rate');
  String get rateUnit => translate('rate_unit');
  String get tiempo => translate('tiempo');
  String get timeUnit => translate('time_unit');
  String get calculateFv => translate('calculate_fv');
  String get calculatePv => translate('calculate_pv');
  String get calculateI => translate('calculate_i');
  String get calculateT => translate('calculate_t');

  String get days => translate('days');
  String get months => translate('months');
  String get quarters => translate('quarters');
  String get semesters => translate('semesters');
  String get years => translate('years');

  String get daily => translate('daily');
  String get monthly => translate('monthly');
  String get quarterly => translate('quarterly');
  String get semiannually => translate('semiannually');
  String get annually => translate('annually');

  //Interes compuesto
  String get initialCapital => translate('initialCapital');
  String get compoundAmount => translate('compoundAmount');
  String get tiempoInteresCompuesto => translate('tiempoInteresCompuesto');
  String get semiannual => translate('semiannual');
  String get annual => translate('annual');
  String get calculateMC => translate('calculateMC');
  String get calculaten => translate('calculaten');
  String get calculatei => translate('calculatei');
  String get result => translate('result');
  String get invalidCapital => translate('invalidCapital');
  String get invalidAmount => translate('invalidAmount');
  String get invalidRate => translate('invalidRate');
  String get invalidTime => translate('invalidTime');
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
