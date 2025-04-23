import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econoengine/Models/transferencia.dart';
import 'package:econoengine/Views/Auth/login_view.dart';
import 'package:econoengine/Views/TIR_view.dart';
import 'package:econoengine/Views/UVR_view.dart';
import 'package:econoengine/Views/capitalizacion_view.dart';
import 'package:econoengine/Views/amortizacion_view.dart';
//import 'package:econoengine/Views/bonos_view.dart';
//import 'package:econoengine/Views/detalles_transfer_view.dart';
import 'package:econoengine/Views/gradientes_view.dart';
import 'package:econoengine/Views/inflacion_view.dart';
import 'package:econoengine/Views/interesCompuesto_view.dart';
import 'package:econoengine/Views/interesSimple_view.dart';
import 'package:econoengine/Views/settings_view.dart';
import 'package:econoengine/Views/transactions_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:econoengine/Controllers/auth_controller.dart'; // Asegúrate de importar el AuthController
import 'package:provider/provider.dart'; // Para usar Provider
import 'package:intl/intl.dart';
import 'package:econoengine/l10n/app_localizations_setup.dart';

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
    final loc = AppLocalizations.of(context);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(loc.makeTransfer),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: telefonoDestinatarioController,
                  decoration: InputDecoration(
                    labelText: loc.recipientPhone,
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: montoController,
                  decoration: InputDecoration(
                    labelText: loc.transferAmount,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(loc.cancel),
            ),
            TextButton(
              onPressed: () async {
                final telefonoDestinatario =
                    telefonoDestinatarioController.text;
                final monto = double.tryParse(montoController.text) ?? 0.0;

                if (telefonoDestinatario.isEmpty || monto <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.invalidData)),
                  );
                  return;
                }

                try {
                  final destinatarioSnapshot = await FirebaseFirestore.instance
                      .collection('usuarios')
                      .where('Telefono', isEqualTo: telefonoDestinatario)
                      .limit(1)
                      .get();

                  if (destinatarioSnapshot.docs.isEmpty) {
                    throw (loc.recipientNotFound);
                  }

                  final destinatarioData =
                      destinatarioSnapshot.docs.first.data();
                  final nombreDestinatario =
                      destinatarioData['Nombre'] as String?;

                  if (nombreDestinatario == null) {
                    throw (loc.nameNotFound);
                  }

                  final referenciaTransferencia =
                      _generarReferenciaTransferencia();

                  await _mostrarConfirmacionTransferencia(
                    context,
                    nombreDestinatario,
                    telefonoDestinatario,
                    monto,
                    referenciaTransferencia,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${loc.error}: $e')),
                  );
                }
              },
              child: Text(loc.transfer),
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
    final loc = AppLocalizations.of(context);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(loc.confirmTransfer),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(loc.recipient, nombreDestinatario),
                _buildDetailRow(loc.phone, telefonoDestinatario),
                _buildDetailRow(loc.amount, '\$${_formatearSaldo(monto)}'),
                _buildDetailRow(loc.date, formattedDate),
                _buildDetailRow(loc.time, formattedTime),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(loc.cancel),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final authController =
                      Provider.of<AuthController>(context, listen: false);
                  final user = FirebaseAuth.instance.currentUser;

                  if (user == null) throw Exception(loc.unauthenticatedUser);

                  final remitenteSnapshot = await FirebaseFirestore.instance
                      .collection('usuarios')
                      .doc(user.uid)
                      .get();

                  if (!remitenteSnapshot.exists) {
                    throw Exception(loc.senderNotFound);
                  }

                  final remitenteData = remitenteSnapshot.data();
                  if (remitenteData?['Nombre'] == null ||
                      remitenteData?['Telefono'] == null ||
                      remitenteData?['Numero Documento'] == null) {
                    throw Exception(loc.incompleteSenderData);
                  }

                  final destinatarioSnapshot = await FirebaseFirestore.instance
                      .collection('usuarios')
                      .where('Telefono', isEqualTo: telefonoDestinatario)
                      .limit(1)
                      .get();

                  if (destinatarioSnapshot.docs.isEmpty) {
                    throw Exception(loc.recipientNotFound);
                  }

                  final destinatarioData =
                      destinatarioSnapshot.docs.first.data();
                  if (destinatarioData['Nombre'] == null ||
                      destinatarioData['Numero Documento'] == null) {
                    throw Exception(loc.incompleteRecipientData);
                  }

                  await authController.transferirDinero(
                    remitenteNombre: remitenteData!['Nombre'],
                    remitenteCelular: remitenteData['Telefono'],
                    remitenteCedula: remitenteData['Numero Documento'],
                    destinatarioNombre: destinatarioData['Nombre'],
                    destinatarioCelular: telefonoDestinatario,
                    destinatarioCedula: destinatarioData['Numero Documento'],
                    monto: monto,
                  );

                  await _loadUserData();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.successfulTransfer)),
                  );

                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${loc.error}: $e')),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Text(loc.confirm),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
                text: '$label: ',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Future<List<Transferencia>> _obtenerUltimosMovimientos() async {
    final authController = Provider.of<AuthController>(context, listen: false);

    // Obtener transferencias enviadas y recibidas
    final transferenciasEnviadas =
        await authController.obtenerTransferenciasEnviadas();
    final transferenciasRecibidas =
        await authController.obtenerTransferenciasRecibidas();

    // Combinar y ordenar por fecha
    final movimientos = [...transferenciasEnviadas, ...transferenciasRecibidas];
    movimientos.sort((a, b) => b.fechaHora.compareTo(a.fechaHora));

    // Tomar los últimos 4 movimientos
    return movimientos.take(2).toList();
  }

  // Método para cargar los datos del usuario
  Future<void> _loadUserData() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final savedUserId = await authController.getAuthState(); // Obtener el UID
    print("UID recuperado: $savedUserId"); // Depuración

    if (savedUserId != null) {
      try {
        final userData = await authController
            .getUserData(savedUserId); // Obtener los datos del usuario
        print("Datos del usuario: $userData"); // Depuración
        setState(() {
          userName = userData['Nombre'] as String?;
          saldo = userData['Saldo'] as double?;
          isLoading = false; // Indicar que la carga ha terminado
        });
      } catch (e) {
        print("Error al cargar los datos del usuario: $e");
        setState(() {
          isLoading =
              false; // Indicar que la carga ha terminado (incluso si hay un error)
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
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: isLoading
            ? Text(loc.loading,
                style: TextStyle(color: Colors.white)) // Indicador de carga
            : Text(
                userName != null
                    ? '${loc.hello}, ${userName!.split(" ")[0]}'
                    : '${loc.hello}, ${loc.user}',
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsView()),
              );
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
    final loc = AppLocalizations.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.availableBalance,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              saldo != null
                  ? '\$${_formatearSaldo(saldo!)}'
                  : loc.loadingBalance,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
                    onPressed: () => _mostrarDialogoTransferencia(context),
                    child: Text(
                      loc.transfer,
                      style: const TextStyle(color: Colors.white),
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
    final loc = AppLocalizations.of(context);

    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildMenuButton(Icons.calculate, loc.simpleInterest, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const InteresSimpleView()));
          }),
          _buildMenuButton(Icons.trending_up, loc.compoundInterest, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const InteresCompuestoView()));
          }),
          _buildMenuButton(Icons.timeline, loc.gradients, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const GradientesView()));
          }),
          _buildMenuButton(Icons.pie_chart, loc.amortization, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AmortizacionView()));
          }),
          _buildMenuButton(Icons.trending_up, loc.irr, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const TirView()));
          }),
          _buildMenuButton(Icons.monetization_on, loc.uvr, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const UvrView()));
          }),
          _buildMenuButton(Icons.business, loc.capitalization, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CapitalizacionView()));
          }),
          _buildMenuButton(Icons.arrow_upward, loc.inflation, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const InflacionView()));
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
    final loc = AppLocalizations.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.transactionHistory,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            FutureBuilder<List<Transferencia>>(
              future: _obtenerUltimosMovimientos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('${loc.error}: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text(loc.noRecentTransactions);
                } else {
                  return Column(
                    children: snapshot.data!
                        .map((movimiento) => _buildTransactionItem(movimiento))
                        .toList(),
                  );
                }
              },
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TransactionsView()),
              ),
              child: Text(loc.viewAllTransactions),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Transferencia transferencia) {
    final loc = AppLocalizations.of(context);
    final esEnvio =
        transferencia.userId == FirebaseAuth.instance.currentUser?.uid;
    final nombre = esEnvio
        ? transferencia.destinatarioNombre
        : transferencia.remitenteNombre;
    final color = esEnvio ? Colors.red : Colors.green;
    final icono = esEnvio ? Icons.arrow_downward : Icons.arrow_upward;

    return ListTile(
      leading: Icon(icono, color: color),
      title: Text(
        esEnvio ? '${loc.sentTo} $nombre' : '${loc.receivedFrom} $nombre',
        style: TextStyle(color: color),
      ),
      subtitle: Text(
        '\$${_formatearSaldo(transferencia.monto)} - ${DateFormat('dd/MM/yyyy HH:mm').format(transferencia.fechaHora)}',
      ),
      onTap: () => _mostrarDetallesTransferencia(context, transferencia),
    );
  }

  void _mostrarDetallesTransferencia(
      BuildContext context, Transferencia transferencia) {
    final loc = AppLocalizations.of(context);
    final esEnvio =
        transferencia.userId == FirebaseAuth.instance.currentUser?.uid;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(esEnvio ? loc.transferDetails : loc.receptionDetails),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(
                  loc.name,
                  esEnvio
                      ? transferencia.destinatarioNombre
                      : transferencia.remitenteNombre),
              _buildDetailRow(
                  loc.phone,
                  esEnvio
                      ? transferencia.destinatarioCelular
                      : transferencia.remitenteCelular),
              _buildDetailRow(
                  loc.amount, '\$${_formatearSaldo(transferencia.monto)}'),
              _buildDetailRow(
                  loc.date,
                  DateFormat('dd/MM/yyyy HH:mm')
                      .format(transferencia.fechaHora)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(loc.close),
            ),
          ],
        );
      },
    );
  }
}
