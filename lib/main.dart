import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'infracture/models/dolar.dart';

void main() {
  runApp(const TabBarDemo());
}

class TabBarDemo extends StatefulWidget {
  const TabBarDemo({Key? key}) : super(key: key);

  @override
  _TabBarDemoState createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<TabBarDemo> {
  TextEditingController _dateController = TextEditingController();
  List<Dolar> _filteredDepartamentos = [];
  String _selectedDate = '2023-09-01'; // Fecha de vigencia predeterminada
  bool _showData = false;

  @override
  void initState() {
    super.initState();
    fetchData(_selectedDate);
  }

  Future<void> fetchData(String selectedDate) async {
    final response = await http.get(
      Uri.parse(
          'https://www.datos.gov.co/resource/ceyp-9c7c.json?vigenciadesde=$selectedDate'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      final List<Dolar> departamentos =
          jsonList.map((e) => Dolar.fromJson(e)).toList();
      setState(() {
        _filteredDepartamentos = departamentos;
        _showData = true; // Mostrar datos una vez que se hayan cargado
      });
    } else {
      throw Exception('Failed to load departamentos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.currency_exchange)),
                Tab(icon: Icon(Icons.currency_exchange_outlined)),
                Tab(icon: Icon(Icons.currency_exchange_rounded)),
              ],
            ),
            title: const Text('Cambio de Moneda'),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Fecha de Vigencia (AAAA-MM-DD)',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedDate = _dateController.text;
                          _showData = false; // Ocultar datos antes de buscar
                        });
                        fetchData(_selectedDate);
                      },
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _showData
                    ? SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text('Valor'),
                            ),
                            DataColumn(
                              label: Text('Desde'),
                            ),
                            DataColumn(
                              label: Text('Hasta'),
                            ),
                          ],
                          rows: _filteredDepartamentos.map((departamento) {
                            return DataRow(
                              cells: <DataCell>[
                                DataCell(Text(departamento.valor)),
                                DataCell(Text(departamento.vigenciadesde)),
                                DataCell(Text(departamento.vigenciahasta)),
                              ],
                            );
                          }).toList(),
                        ),
                      )
                    : CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
