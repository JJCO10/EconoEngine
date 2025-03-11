import 'package:econoengine/Views/Auth/login_view.dart';
import 'package:econoengine/Views/TIR_view.dart';
import 'package:econoengine/Views/UVR_view.dart';
import 'package:econoengine/Views/alt_inv_view.dart';
import 'package:econoengine/Views/amortizacion_view.dart';
import 'package:econoengine/Views/bonos_view.dart';
import 'package:econoengine/Views/gradientes_view.dart';
import 'package:econoengine/Views/inflacion_view.dart';
import 'package:econoengine/Views/interesCompuesto_view.dart';
import 'package:econoengine/Views/interesSimple_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0; // Índice para controlar la opción seleccionada

  // Método para manejar el cambio de índice
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hola, Juan',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[800],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.white,
            onPressed: () {
              // Lógica para notificaciones
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceSection(),
            const SizedBox(height: 20),
            _buildHorizontalMenu(context),
            const SizedBox(height: 20),
            _buildTransactionHistorySection(),
          ],
        ),
      ),
      // Menú inferior
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

  Widget _buildBalanceSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saldo disponible',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '\$3.012,04',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      // Lógica para consignar
                    },
                    child: const Text(
                      'Consignar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      // Lógica para retirar
                    },
                    child: const Text(
                      'Retirar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalMenu(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildMenuButton(Icons.calculate, 'Interés Simple', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InteresSimpleView()),
            );
          }),
          _buildMenuButton(Icons.trending_up, 'Interés Compuesto', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InteresCompuestoView()),
            );
          }),
          _buildMenuButton(Icons.timeline, 'Gradientes', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GradientesView()),
            );
          }),
          _buildMenuButton(Icons.pie_chart, 'Amortización', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AmortizacionView()),
            );
          }),
          _buildMenuButton(Icons.trending_up, 'TIR', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TIRView()),
            );
          }),
          _buildMenuButton(Icons.monetization_on, 'UVR', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UVRView()),
            );
          }),
          _buildMenuButton(Icons.business, 'Alt_Inversión', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AlternativasInversionView()),
            );
          }),
          _buildMenuButton(Icons.credit_card, 'Bonos', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BonosView()),
            );
          }),
          _buildMenuButton(Icons.arrow_upward, 'Inflación', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InflacionView()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMenuButton(IconData icon, String label, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          IconButton(
            icon: Icon(icon, size: 40),
            onPressed: onPressed,
          ),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildTransactionHistorySection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Historial de Movimientos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildTransactionItem('Consignación', '\$1.000,00', Icons.arrow_downward, Colors.green),
            _buildTransactionItem('Retiro', '\$500,00', Icons.arrow_upward, Colors.red),
            _buildTransactionItem('Pago de servicios', '\$200,00', Icons.receipt, Colors.blue),
            _buildTransactionItem('Recarga celular', '\$50,00', Icons.phone_android, Colors.orange),
            TextButton(
              onPressed: () {
                // Lógica para ver todos los movimientos
              },
              child: const Text('Ver todos los movimientos'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(String title, String amount, IconData icon, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      trailing: Text(
        amount,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}