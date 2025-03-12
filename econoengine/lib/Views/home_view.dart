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
import 'package:econoengine/Controllers/auth_controller.dart'; // Asegúrate de importar el AuthController
import 'package:provider/provider.dart'; // Para usar Provider
import 'package:intl/intl.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? userName;
  bool isLoading = true;
  double? saldo;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Método para cargar los datos del usuario
  Future<void> _loadUserData() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final savedUserId = await authController.getAuthState(); // Obtener el UID
    print("UID recuperado: $savedUserId"); // Depuración

    if (savedUserId != null) {
      try {
        final userData = await authController.getUserData(savedUserId); // Obtener los datos del usuario
        print("Datos del usuario: $userData"); // Depuración
        setState(() {
          userName = userData['Nombre'] as String?;
          saldo = userData['Saldo'] as double?;
          isLoading = false; // Indicar que la carga ha terminado
        });
      } catch (e) {
        print("Error al cargar los datos del usuario: $e");
        setState(() {
          isLoading = false; // Indicar que la carga ha terminado (incluso si hay un error)
        });
      }
    } else {
      print("No se encontró un UID guardado"); // Depuración
      setState(() {
        isLoading = false; // Indicar que la carga ha terminado
      });
    }
  }

  // Método para formatear el saldo
  String _formatearSaldo(double saldo) {
    final formatter = NumberFormat("#,##0.00", "es_ES"); // Formateador
    return formatter.format(saldo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isLoading
            ? const Text("Cargando...", style: TextStyle(color: Colors.white)) // Indicador de carga
            : Text(
                userName != null ? 'Hola, ${userName!.split(" ")[0]}' : 'Hola, Usuario',
          style: const TextStyle(
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
            Text(
              saldo != null ? '\$${_formatearSaldo(saldo!)}' : 'Cargando saldo...',
              style: const TextStyle(
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
              MaterialPageRoute(builder: (context) => const InteresSimpleView()),
            );
          }),
          _buildMenuButton(Icons.trending_up, 'Interés Compuesto', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InteresCompuestoView()),
            );
          }),
          _buildMenuButton(Icons.timeline, 'Gradientes', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GradientesView()),
            );
          }),
          _buildMenuButton(Icons.pie_chart, 'Amortización', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AmortizacionView()),
            );
          }),
          _buildMenuButton(Icons.trending_up, 'TIR', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TIRView()),
            );
          }),
          _buildMenuButton(Icons.monetization_on, 'UVR', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UVRView()),
            );
          }),
          _buildMenuButton(Icons.business, 'Alt_Inversión', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AlternativasInversionView()),
            );
          }),
          _buildMenuButton(Icons.credit_card, 'Bonos', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BonosView()),
            );
          }),
          _buildMenuButton(Icons.arrow_upward, 'Inflación', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InflacionView()),
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