import 'package:econoengine/Views/Profile_view.dart';
import 'package:econoengine/Views/settings_view.dart';
import 'package:econoengine/Views/transactions_view.dart';
import 'package:flutter/material.dart';
import 'package:econoengine/Views/home_view.dart'; // Asegúrate de importar las vistas correctas

class NavbarView extends StatefulWidget {
  const NavbarView({super.key});

  @override
  _NavbarViewState createState() => _NavbarViewState();
}

class _NavbarViewState extends State<NavbarView> {
  int _currentIndex = 0;

  // Lista de páginas
  final List<Widget> _pages = [
    const HomeView(),
    const TransactionsView(),
    const SettingsView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Muestra la página actual
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Cambia la página al seleccionar un ícono
          });
        },
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Principal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Movimientos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}