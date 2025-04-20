import 'package:econoengine/Controllers/auth_controller.dart';
import 'package:econoengine/Controllers/tir_controller.dart';
import 'package:econoengine/Views/Auth/forgot_password_view.dart';
// import 'package:econoengine/Views/Auth/home_view.dart';
import 'package:econoengine/Views/Auth/register_view.dart';
import 'package:econoengine/Views/navbar_view.dart';
import 'package:econoengine/controllers/capitalizacion_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Controllers/amortizacion_controller.dart';
import 'Controllers/gradientes_controller.dart';
import 'Controllers/interesCompuesto_controller.dart';
import 'Controllers/interesSimple_controller.dart';
import 'Controllers/uvr_controller.dart';
import 'Views/Auth/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Controllers/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()), // Proveer AuthController
        ChangeNotifierProvider(create: (_) => ThemeController()), // Proveer ThemeController
        ChangeNotifierProvider(create: (_) => InteresSimpleController()), // Proveer InteresSimpleController
        ChangeNotifierProvider(create: (_) => InteresCompuestoController()), // Proveer InteresCompuestoController
        ChangeNotifierProvider(create: (_) => GradienteController()), // Proveer GradienteController
        ChangeNotifierProvider(create: (_) => AmortizacionController()), // Proveer AmortizacionController
        ChangeNotifierProvider(create: (_) => TirController()), // Proveer TirController
        ChangeNotifierProvider(create: (_) => UvrController()), // Proveer UvrController
        ChangeNotifierProvider(create: (_) => CapitalizacionController()), // Proveer CapitalizacionController
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
    return MaterialApp(
      title: 'EconoEngine',
      debugShowCheckedModeBanner: false,
      theme: themeController.currentTheme,
      home: const LoginView(), // Pantalla inicial
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/home': (context) =>
            const NavbarView(), // Usa el Navbar como página principal
        '/recoverPassword': (context) => const ForgotPasswordView(),
      },
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1A237E),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 15,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A237E),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 16),
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
