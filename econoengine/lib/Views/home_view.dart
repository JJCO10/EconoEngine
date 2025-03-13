import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econoengine/Models/transferencia.dart';
import 'package:econoengine/Views/Auth/login_view.dart';
import 'package:econoengine/Views/TIR_view.dart';
import 'package:econoengine/Views/UVR_view.dart';
import 'package:econoengine/Views/alt_inv_view.dart';
import 'package:econoengine/Views/amortizacion_view.dart';
import 'package:econoengine/Views/bonos_view.dart';
import 'package:econoengine/Views/detalles_transfer_view.dart';
import 'package:econoengine/Views/gradientes_view.dart';
import 'package:econoengine/Views/inflacion_view.dart';
import 'package:econoengine/Views/interesCompuesto_view.dart';
import 'package:econoengine/Views/interesSimple_view.dart';
import 'package:econoengine/Views/transactions_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> _mostrarDialogoTransferencia(BuildContext context) async {
    final telefonoDestinatarioController = TextEditingController();
    final montoController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Realizar Transferencia'),
          content: SizedBox(
            width: double.maxFinite, // Hacer el diálogo más grande
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: telefonoDestinatarioController,
                  decoration: const InputDecoration(
                    labelText: 'Número de celular del destinatario',
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: montoController,
                  decoration: const InputDecoration(
                    labelText: 'Monto a transferir',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final telefonoDestinatario = telefonoDestinatarioController.text;
                final monto = double.tryParse(montoController.text) ?? 0.0;

                if (telefonoDestinatario.isEmpty || monto <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor, ingresa datos válidos')),
                  );
                  return;
                }

                try {
                  // final authController = Provider.of<AuthController>(context, listen: false);

                  // Obtener los datos del destinatario
                  final destinatarioSnapshot = await FirebaseFirestore.instance
                      .collection('usuarios')
                      .where('Telefono', isEqualTo: telefonoDestinatario)
                      .limit(1)
                      .get();

                  if (destinatarioSnapshot.docs.isEmpty) {
                    throw ('No se encontró el destinatario');
                  }

                  final destinatarioData = destinatarioSnapshot.docs.first.data();
                  final nombreDestinatario = destinatarioData['Nombre'] as String?;

                  if (nombreDestinatario == null) {
                    throw ('No se encontró el nombre del destinatario');
                  }

                  // Generar la referencia de transferencia
                  final referenciaTransferencia = _generarReferenciaTransferencia();

                  // Mostrar el cuadro de confirmación
                  await _mostrarConfirmacionTransferencia(
                    context,
                    nombreDestinatario,
                    telefonoDestinatario,
                    monto,
                    referenciaTransferencia,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: const Text('Transferir'),
            ),
          ],
        );
      },
    );
  }

  String _generarReferenciaTransferencia() {
    final now = DateTime.now();
    final random = Random().nextInt(9999); // Número aleatorio entre 0 y 9999
    return 'REF-${DateFormat('yyyyMMdd').format(now)}-$random';
  }

  Future<void> _mostrarConfirmacionTransferencia(
    BuildContext context,
    String nombreDestinatario,
    String telefonoDestinatario,
    double monto,
    String referenciaTransferencia,
  ) async {
    final now = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy').format(now);
    final formattedTime = DateFormat('HH:mm').format(now);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar Transferencia'),
          content: SizedBox(
            width: double.maxFinite, // Hacer el diálogo más grande
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      const TextSpan(
                        text: 'Destinatario: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: nombreDestinatario),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      const TextSpan(
                        text: 'Teléfono: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: telefonoDestinatario),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      const TextSpan(
                        text: 'Monto: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '\$${_formatearSaldo(monto)}'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      const TextSpan(
                        text: 'Fecha: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: formattedDate),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      const TextSpan(
                        text: 'Hora: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: formattedTime),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      const TextSpan(
                        text: 'Referencia: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: referenciaTransferencia),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo sin hacer la transferencia
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final authController = Provider.of<AuthController>(context, listen: false);

                  // Obtener los datos del remitente (usuario actual)
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) throw Exception('Usuario no autenticado');

                  final remitenteSnapshot = await FirebaseFirestore.instance
                      .collection('usuarios')
                      .doc(user.uid)
                      .get();

                  if (!remitenteSnapshot.exists) {
                    throw Exception('No se encontró el remitente');
                  }

                  final remitenteData = remitenteSnapshot.data();
                  final remitenteNombre = remitenteData?['Nombre'] as String?;
                  final remitenteCelular = remitenteData?['Telefono'] as String?;
                  final remitenteCedula = remitenteData?['Numero Documento'] as String?;

                  if (remitenteNombre == null || remitenteCelular == null || remitenteCedula == null) {
                    throw Exception('Datos del remitente incompletos');
                  }

                  // Obtener los datos del destinatario
                  final destinatarioSnapshot = await FirebaseFirestore.instance
                      .collection('usuarios')
                      .where('Telefono', isEqualTo: telefonoDestinatario)
                      .limit(1)
                      .get();

                  if (destinatarioSnapshot.docs.isEmpty) {
                    throw Exception('No se encontró el destinatario');
                  }

                  final destinatarioData = destinatarioSnapshot.docs.first.data();
                  final destinatarioNombre = destinatarioData['Nombre'] as String?;
                  final destinatarioCedula = destinatarioData['Numero Documento'] as String?;

                  if (destinatarioNombre == null || destinatarioCedula == null) {
                    throw Exception('Datos del destinatario incompletos');
                  }

                  // Realizar la transferencia
                  await authController.transferirDinero(
                    remitenteNombre: remitenteNombre,
                    remitenteCelular: remitenteCelular,
                    remitenteCedula: remitenteCedula,
                    destinatarioNombre: destinatarioNombre,
                    destinatarioCelular: telefonoDestinatario,
                    destinatarioCedula: destinatarioCedula,
                    monto: monto,
                  );

                  // Actualizar el saldo después de la transferencia
                  await _loadUserData();

                  // Mostrar mensaje de éxito
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Transferencia exitosa')),
                  );

                  // Cerrar el cuadro de confirmación
                  Navigator.of(context).pop();

                  // Cerrar el cuadro de diálogo de transferencia
                  Navigator.of(context).pop();
                } catch (e) {
                  // Mostrar mensaje de error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );

                  // Cerrar el cuadro de confirmación en caso de error
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  Future<List<Transferencia>> _obtenerUltimosMovimientos() async {
    final authController = Provider.of<AuthController>(context, listen: false);

    // Obtener transferencias enviadas y recibidas
    final transferenciasEnviadas = await authController.obtenerTransferenciasEnviadas();
    final transferenciasRecibidas = await authController.obtenerTransferenciasRecibidas();

    // Combinar y ordenar por fecha
    final movimientos = [...transferenciasEnviadas, ...transferenciasRecibidas];
    movimientos.sort((a, b) => b.fechaHora.compareTo(a.fechaHora));

    // Tomar los últimos 4 movimientos
    return movimientos.take(4).toList();
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
            icon: const Icon(Icons.settings),
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
                      _mostrarDialogoTransferencia(context);
                    },
                    child: const Text(
                      'Transferir',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10)
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
            FutureBuilder<List<Transferencia>>(
              future: _obtenerUltimosMovimientos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No hay movimientos recientes');
                } else {
                  final movimientos = snapshot.data!;
                  return Column(
                    children: movimientos.map((movimiento) {
                      return _buildTransactionItem(
                        movimiento,
                      );
                    }).toList(),
                  );
                }
              },
            ),
            TextButton(
              onPressed: () {
                // Navegar a la vista de transacciones
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TransactionsView()),
                );
              },
              child: const Text('Ver todos los movimientos'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Transferencia transferencia) {
    final esEnvio = transferencia.userId == FirebaseAuth.instance.currentUser?.uid;
    final nombre = esEnvio ? transferencia.destinatarioNombre : transferencia.remitenteNombre;
    final color = esEnvio ? Colors.red : Colors.green;
    final icono = esEnvio ? Icons.arrow_downward : Icons.arrow_upward;

    return ListTile(
      leading: Icon(icono, color: color),
      title: Text(
        esEnvio ? 'Enviado a $nombre' : 'Recibido de $nombre',
        style: TextStyle(color: color),
      ),
      subtitle: Text(
        '\$${transferencia.monto.toStringAsFixed(2)} - ${DateFormat('dd/MM/yyyy HH:mm').format(transferencia.fechaHora)}',
      ),
      onTap: () {
        // Navegar a la vista de detalles
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetallesTransferenciaView(transferencia: transferencia),
          ),
        );
      },
    );
  }
}