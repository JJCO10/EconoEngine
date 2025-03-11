import 'package:econoengine/Views/home_view.dart';
import 'package:econoengine/Views/Profile_view.dart';
// import 'package:econoengine/Views/TIR_view.dart';
// import 'package:econoengine/Views/UVR_view.dart';
// import 'package:econoengine/Views/alt_inv_view.dart';
// import 'package:econoengine/Views/amortizacion_view.dart';
// import 'package:econoengine/Views/bonos_view.dart';
// import 'package:econoengine/Views/gradientes_view.dart';
// import 'package:econoengine/Views/inflacion_view.dart';
import 'package:econoengine/Views/settings_view.dart';
import 'package:econoengine/Views/transactions_view.dart';
import 'package:flutter/material.dart';
// import 'package:econoengine/Views/interesSimple_view.dart';
// import 'package:econoengine/Views/interesCompuesto_view.dart';

class NavbarView extends StatefulWidget {
  const NavbarView({super.key});

  @override
  State<NavbarView> createState() => _NavbarViewState();
}

class _NavbarViewState extends State<NavbarView> {
  int _selectedIndex = 0; // Índice de la pestaña seleccionada
  final List<GlobalKey<NavigatorState>> _navigatorKeys = List.generate(
    4,
    (index) => GlobalKey<NavigatorState>(),
  );

  // Maneja el cambio de pestañas
  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      // Si el usuario toca la pestaña actual, vuelve al inicio de la pila de navegación
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Construcción de rutas dentro de cada pestaña
  Widget _buildScreen(int index) {
    return [
      const HomeView(),
      const SettingsView(),
      const ProfileView(),
      const TransactionsView(),
    ][index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: List.generate(4, (index) {
          return Offstage(
            offstage: _selectedIndex != index,
            child: Navigator(
              key: _navigatorKeys[index],
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (context) => _buildScreen(index),
                );
              },
            ),
          );
        }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Principal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Movimientos',
          ),
        ],
      ),
    );
  }
}
