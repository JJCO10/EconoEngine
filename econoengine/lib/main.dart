import 'package:econoengine/Views/Auth/forgot_password_view.dart';
import 'package:econoengine/Views/Auth/home_view.dart';
import 'package:econoengine/Views/Auth/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart'; // Importa el paquete
import 'views/auth/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // Inicializa el binding de Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Preserva el splash screen nativo
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());

  // Inicializa Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Ejecuta la aplicación
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Retraso artificial para ver el splash screen (opcional)
    Future.delayed(const Duration(seconds: 3), () {
      FlutterNativeSplash.remove(); // Remueve el splash screen nativo
    });

    return MaterialApp(
      title: 'Fintech App',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const LoginView(), // Pantalla inicial
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/home': (context) => const HomeView(),
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