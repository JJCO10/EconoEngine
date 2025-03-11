import 'package:econoengine/Views/Auth/forgot_password_view.dart';
// import 'package:econoengine/Views/Auth/home_view.dart';
import 'package:econoengine/Views/Auth/register_view.dart';
import 'package:econoengine/Views/TIR_view.dart';
import 'package:econoengine/Views/UVR_view.dart';
import 'package:econoengine/Views/alt_inv_view.dart';
import 'package:econoengine/Views/amortizacion_view.dart';
import 'package:econoengine/Views/bonos_view.dart';
import 'package:econoengine/Views/gradientes_view.dart';
import 'package:econoengine/Views/inflacion_view.dart';
import 'package:econoengine/Views/interesCompuesto_view.dart';
import 'package:econoengine/Views/interesSimple_view.dart';
import 'package:econoengine/Views/navbar_view.dart';
import 'package:flutter/material.dart';
import 'views/auth/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase (comenta si aún no lo necesitas)
  //await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fintech App',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const LoginView(), // Pantalla inicial
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/home': (context) => const NavbarView(),
        '/recoverPassword': (context) => const ForgotPasswordView(),
        '/interesSimple': (context) => const InteresSimpleView(),
        '/interesCompuesto': (context) => const InteresCompuestoView(),
        '/gradientes': (context) => const GradientesView(),
        '/amortizacion': (context) => const AmortizacionView(),
        '/TIR': (context) => const TIRView(),
        '/UVR': (context) => const UVRView(),
        '/alternativasInversion': (context) => const AlternativasInversionView(),
        '/bonos': (context) => const BonosView(),
        '/inflacion': (context) => const InflacionView(),
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