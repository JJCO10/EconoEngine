import 'package:econoengine/Views/profile_view.dart';
import 'package:econoengine/Views/transactions_view.dart';
import 'package:flutter/material.dart';
import 'package:econoengine/Views/home_view.dart';
import 'package:econoengine/l10n/app_localizations_setup.dart';

class NavbarView extends StatefulWidget {
  const NavbarView({super.key});

  @override
  _NavbarViewState createState() => _NavbarViewState();
}

class _NavbarViewState extends State<NavbarView> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeView(),
    const TransactionsView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context); // Accede a traducciones

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: loc.home, // Principal
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: loc.transactions, // Movimientos
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: loc.profile, // Perfil
          ),
        ],
      ),
    );
  }
}
