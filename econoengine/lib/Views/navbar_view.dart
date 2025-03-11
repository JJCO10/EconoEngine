import 'package:econoengine/Views/Auth/home_view.dart';
import 'package:econoengine/Views/Profile_view.dart';
import 'package:econoengine/Views/TIR_view.dart';
import 'package:econoengine/Views/UVR_view.dart';
import 'package:econoengine/Views/alt_inv_view.dart';
import 'package:econoengine/Views/amortizacion_view.dart';
import 'package:econoengine/Views/bonos_view.dart';
import 'package:econoengine/Views/gradientes_view.dart';
import 'package:econoengine/Views/inflacion_view.dart';
import 'package:econoengine/Views/settings_view.dart';
import 'package:econoengine/Views/transactions_view.dart';
import 'package:flutter/material.dart';
import 'package:econoengine/Views/interesSimple_view.dart';
import 'package:econoengine/Views/interesCompuesto_view.dart';

class NavbarView extends StatefulWidget {
  const NavbarView({super.key});

  @override
  State<NavbarView> createState() => _NavbarViewState();
}

class _NavbarViewState extends State<NavbarView> {
  int _selectedIndex = 0; // Índice para controlar la opción seleccionada
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  // Método para manejar el cambio de índice desde el BottomNavigationBar
  void _onItemTapped(int index) {
  // Restablece la navegación dentro de la pestaña seleccionada
  _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);

  setState(() {
    _selectedIndex = index;
  });
}

  // Método para construir las rutas de cada pestaña
  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          const HomeView(), // Vista principal
          const SettingsView(), // Vista de ajustes
          const ProfileView(), // Vista de perfil
          const TransactionsView(), // Vista de movimientos
        ][index];
      },
      '/interes-simple': (context) => const InteresSimpleView(),
      '/interes-compuesto': (context) => const InteresCompuestoView(),
      '/gradientes': (context) => const GradientesView(),
      '/amortizacion': (context) => const AmortizacionView(),
      '/TIR': (context) => const TIRView(),
      '/UVR': (context) => const UVRView(),
      '/alternativasInversion': (context) => const AlternativasInversionView(),
      '/bonos': (context) => const BonosView(),
      '/inflacion': (context) => const InflacionView(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildOffstageNavigator(0),
          _buildOffstageNavigator(1),
          _buildOffstageNavigator(2),
          _buildOffstageNavigator(3),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Índice seleccionado
        onTap: _onItemTapped, // Método para manejar el cambio de índice
        selectedItemColor: Colors.blue[800], // Color del ícono seleccionado
        unselectedItemColor: Colors.grey, // Color del ícono no seleccionado
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

  // Método para construir un Navigator offstage para cada pestaña
  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              return _routeBuilders(context, index)[settings.name]!(context);
            },
          );
        },
      ),
    );
  }
}