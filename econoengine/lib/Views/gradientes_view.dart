import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controllers/gradientes_controller.dart';
import '../l10n/app_localizations_setup.dart';

class GradientesView extends StatefulWidget {
  const GradientesView({super.key});

  @override
  State<GradientesView> createState() => _GradientesViewState();
}

class _GradientesViewState extends State<GradientesView> {
  final TextEditingController _primerPagoController = TextEditingController();
  final TextEditingController _gradienteController = TextEditingController();
  final TextEditingController _tasaInteresController = TextEditingController();
  final TextEditingController _periodosController = TextEditingController();
  final TextEditingController _tasaCrecimientoController =
      TextEditingController();

  @override
  void dispose() {
    _primerPagoController.dispose();
    _gradienteController.dispose();
    _tasaInteresController.dispose();
    _periodosController.dispose();
    _tasaCrecimientoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GradienteController>(context);
    final loc = AppLocalizations.of(context);

    // Unidades para tasas (mostradas traducidas pero con valores internos consistentes)
    final unidadesTasa = [
      _DropdownItem(value: 'anual', display: loc.annual),
      _DropdownItem(value: 'mensual', display: loc.monthly),
      _DropdownItem(value: 'trimestral', display: loc.quarterly),
      _DropdownItem(value: 'semestral', display: loc.semiannual),
      _DropdownItem(value: 'diaria', display: loc.daily),
    ];

    // Unidades para periodos (mostradas traducidas pero con valores internos consistentes)
    final unidadesPeriodo = [
      _DropdownItem(value: 'meses', display: loc.months),
      _DropdownItem(value: 'trimestres', display: loc.quarters),
      _DropdownItem(value: 'semestres', display: loc.semesters),
      _DropdownItem(value: 'años', display: loc.years),
      _DropdownItem(value: 'días', display: loc.days),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.gradientsTitle),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSelectorTipo(controller, loc),
            const SizedBox(height: 20),
            _buildCamposEntrada(controller, unidadesTasa, unidadesPeriodo, loc),
            const SizedBox(height: 20),
            if (controller.hasError) _buildError(controller),
            _buildBotonCalcular(controller, loc),
            const SizedBox(height: 20),
            if (controller.resultados.isNotEmpty)
              _buildResultados(controller, loc),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectorTipo(
      GradienteController controller, AppLocalizations loc) {
    final opcionesGradiente = [
      _DropdownItem(value: 'Aritmético', display: loc.arithmeticGradient),
      _DropdownItem(value: 'Geométrico', display: loc.geometricGradient),
    ];

    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              loc.selectGradientType,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<_DropdownItem>(
              value: opcionesGradiente.firstWhere(
                (item) => item.value == controller.tipoGradiente,
                orElse: () => opcionesGradiente[0],
              ),
              onChanged: (_DropdownItem? newValue) {
                if (newValue != null) {
                  controller.cambiarTipoGradiente(newValue.value);
                }
              },
              items: opcionesGradiente.map((_DropdownItem item) {
                return DropdownMenuItem<_DropdownItem>(
                  value: item,
                  child: Text(item.display),
                );
              }).toList(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCamposEntrada(
    GradienteController controller,
    List<_DropdownItem> unidadesTasa,
    List<_DropdownItem> unidadesPeriodo,
    AppLocalizations loc,
  ) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInputField(
              loc.firstPayment,
              _primerPagoController,
              hintText: loc.exampleAmount,
              suffixText: "\$",
            ),
            const SizedBox(height: 10),
            if (controller.tipoGradiente == "Aritmético")
              _buildInputField(
                loc.gradient,
                _gradienteController,
                hintText: loc.exampleAmount,
                suffixText: "\$",
              ),
            if (controller.tipoGradiente == "Geométrico")
              _buildInputField(
                loc.growthRate,
                _tasaCrecimientoController,
                hintText: loc.examplePercentage,
                suffixText: "%",
              ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4, // Le damos más espacio al input
                  child: _buildInputField(
                    loc.interestRate,
                    _tasaInteresController,
                    hintText: loc.examplePercentage,
                    suffixText: "%",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3, // Le damos más espacio al dropdown
                  child: _buildDropdown(
                    loc.unit,
                    unidadesTasa,
                    unidadesTasa.firstWhere(
                      (item) => item.value == controller.unidadTasa,
                      orElse: () => unidadesTasa[0],
                    ),
                    (value) => controller.cambiarUnidadTasa(value!.value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4, // Le damos más espacio al input
                  child: _buildInputField(
                    loc.periods,
                    _periodosController,
                    hintText: loc.examplePeriods,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3, // Le damos más espacio al dropdown
                  child: _buildDropdown(
                    loc.unit,
                    unidadesPeriodo,
                    unidadesPeriodo.firstWhere(
                      (item) => item.value == controller.unidadPeriodo,
                      orElse: () => unidadesPeriodo[0],
                    ),
                    (value) => controller.cambiarUnidadPeriodo(value!.value),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    String? hintText,
    String? suffixText,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        suffixText: suffixText,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      controller: controller,
    );
  }

  Widget _buildDropdown(
    String label,
    List<_DropdownItem> items,
    _DropdownItem? value,
    ValueChanged<_DropdownItem?> onChanged,
  ) {
    return DropdownButtonFormField<_DropdownItem>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      value: value,
      items: items.map((_DropdownItem item) {
        return DropdownMenuItem<_DropdownItem>(
          value: item,
          child: Text(item.display),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildError(GradienteController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        controller.error,
        style: const TextStyle(color: Colors.red, fontSize: 16),
      ),
    );
  }

  Widget _buildBotonCalcular(
      GradienteController controller, AppLocalizations loc) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _calcular(controller),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          backgroundColor: Colors.blue[800],
          foregroundColor: Colors.white,
        ),
        child: Text(loc.calculate),
      ),
    );
  }

  Widget _buildResultados(
      GradienteController controller, AppLocalizations loc) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Concepto")),
            DataColumn(label: Text("Valor")),
          ],
          rows: controller.resultados.entries.map((entry) {
            return DataRow(cells: [
              DataCell(Text(_traducirConcepto(entry.key))),
              DataCell(Text(entry.value.toStringAsFixed(2))),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  void _calcular(GradienteController controller) {
    final primerPago = double.tryParse(_primerPagoController.text) ?? 0;
    final tasaInteres = double.tryParse(_tasaInteresController.text) ?? 0;
    final periodos = int.tryParse(_periodosController.text) ?? 0;

    if (controller.tipoGradiente == "Aritmético") {
      final gradiente = double.tryParse(_gradienteController.text) ?? 0;
      controller.calcular(
        primerPago: primerPago,
        gradienteOrTasaCrecimiento: gradiente,
        tasaInteres: tasaInteres,
        periodos: periodos,
      );
    } else {
      final tasaCrecimiento =
          double.tryParse(_tasaCrecimientoController.text) ?? 0;
      controller.calcular(
        primerPago: primerPago,
        gradienteOrTasaCrecimiento: tasaCrecimiento,
        tasaInteres: tasaInteres,
        periodos: periodos,
      );
    }
  }

  String _traducirConcepto(String key) {
    return {
          'valorPresente': 'Valor Presente',
          'valorFuturo': 'Valor Futuro',
          'serie': 'Serie',
        }[key] ??
        key;
  }
}

// Clase auxiliar para manejar los items del dropdown con valor interno y display traducido
class _DropdownItem {
  final String value;
  final String display;

  _DropdownItem({required this.value, required this.display});
}
