import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:econoengine/firebase_options.dart';
// import 'package:econoengine/l10n/app_localizations_setup.dart';

// Controladores
import 'package:econoengine/Controllers/auth_controller.dart';
import 'package:econoengine/Controllers/theme_controller.dart';
import 'package:econoengine/Controllers/text_size_controller.dart';
import 'package:econoengine/Controllers/interesSimple_controller.dart';
import 'package:econoengine/Controllers/interesCompuesto_controller.dart';
import 'package:econoengine/Controllers/gradientes_controller.dart';
import 'package:econoengine/Controllers/amortizacion_controller.dart';
import 'package:econoengine/Controllers/tir_controller.dart';
import 'package:econoengine/Controllers/uvr_controller.dart';
import 'package:econoengine/Controllers/capitalizacion_controller.dart';
import 'package:econoengine/Controllers/inflacion_controller.dart';

// Vistas
import 'package:econoengine/Views/Auth/login_view.dart';
import 'package:econoengine/Views/Auth/register_view.dart';
import 'package:econoengine/Views/Auth/forgot_password_view.dart';
import 'package:econoengine/Views/navbar_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final textSizeController = TextSizeController();
  await textSizeController.init(); // Inicializa tamaño de texto

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => textSizeController),
        ChangeNotifierProvider(create: (_) => InteresSimpleController()),
        ChangeNotifierProvider(create: (_) => InteresCompuestoController()),
        ChangeNotifierProvider(create: (_) => GradienteController()),
        ChangeNotifierProvider(create: (_) => AmortizacionController()),
        ChangeNotifierProvider(create: (_) => TirController()),
        ChangeNotifierProvider(create: (_) => UvrController()),
        ChangeNotifierProvider(create: (_) => CapitalizacionController()),
        ChangeNotifierProvider(create: (_) => InflacionController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final textSizeController = Provider.of<TextSizeController>(context);

    ThemeData theme = themeController.currentTheme;
    theme = theme.copyWith(
      textTheme: textSizeController.getAdjustedTextTheme(theme.textTheme),
    );

    return MaterialApp(
      title: 'EconoEngine',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const LoginView(),
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/home': (context) => const NavbarView(),
        '/recoverPassword': (context) => const ForgotPasswordView(),
      },
    );
  }
}
