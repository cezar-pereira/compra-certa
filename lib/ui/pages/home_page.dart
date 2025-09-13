import 'package:compra_certa/data/repositories/selic_repository.dart';
import 'package:compra_certa/data/services/selic_database_service.dart';

import 'package:compra_certa/ui/pages/investment_calculator_page.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/investment_result_entity.dart';
import '../../domain/usecases/calculate_investment_returns_usecase.dart';
import '../../services/selic_rate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  final _valorAVistaController = TextEditingController();
  final _valorCheioController = TextEditingController();
  int _quantidadeParcelas = 1;
  final SelicRate _selicRate = SelicRate.instance;

  final _calculateInvestmentUseCase = CalculateInvestmentReturnsUsecase();
  final repository = SelicRepositoryImpl(SelicDatabaseService());

  InvestmentResultEntity? investmentResult;

  @override
  void initState() {
    super.initState();

    _loadSelicRate();
  }

  Future<void> _loadSelicRate() async {
    _selicRate.rate = await repository.getSelicRate();
  }

  Future<void> _calculate() async {
    if (_selicRate.rate == null) {
      _errorSelicNotDefined();
      return;
    }

    final valueWithDiscount = double.parse(_valorAVistaController.text);
    final value = double.parse(_valorCheioController.text);

    investmentResult = _calculateInvestmentUseCase.call(
      valueWithDiscount: valueWithDiscount,
      annualSelicRate: _selicRate.rate!,
      value: value,
      numberOfMonths: _quantidadeParcelas,
    );

    setState(() {});
  }

  void _errorSelicNotDefined() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Taxa selic não definida'),
          action: SnackBarAction(
            label: 'Definir',
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: const Text('Compra Certa')),
      drawer: _Drawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _valorCheioController,
                      decoration: const InputDecoration(
                        labelText: 'Valor Cheio',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _valorAVistaController,
                      decoration: const InputDecoration(
                        labelText: 'Valor à Vista',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                    ),

                    DropdownButtonFormField<int>(
                      initialValue: _quantidadeParcelas,
                      decoration: const InputDecoration(
                        labelText: 'Quantidade de Parcelas',
                      ),
                      items: List.generate(18, (index) => index + 1)
                          .map(
                            (label) => DropdownMenuItem(
                              value: label,
                              child: Text(label.toString()),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _quantidadeParcelas = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _calculate();
                        }
                      },
                      child: const Text('Calcular'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              if (investmentResult != null)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      Visibility(
                        visible: investmentResult?.advantage.isCard == true,
                        replacement: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('💵', style: TextStyle(fontSize: 48)),
                            Text(
                              'Economia à vista:',
                              style: Theme.of(
                                context,
                              ).textTheme.headlineLarge?.copyWith(),
                            ),
                            Text(
                              'R\$${(investmentResult?.advantageValue ?? 0).toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 48),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('💳', style: TextStyle(fontSize: 48)),
                            Text(
                              'Economia investindo:',
                              style: Theme.of(
                                context,
                              ).textTheme.headlineLarge?.copyWith(),
                            ),
                            Text(
                              'R\$${(investmentResult?.advantageValue ?? 0).toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 48),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Spacer(),
                      Text(
                        'Dados do Investimento:',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        'Valor líquido: R\$ ${investmentResult?.totalNetYield.toStringAsFixed(2)}',
                      ),
                      Text(
                        'Total bruto: R\$ ${investmentResult?.totalYield.toStringAsFixed(2)}',
                      ),
                      Text(
                        'Total de imposto: R\$ ${investmentResult?.totalTax.toStringAsFixed(2)}',
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Drawer extends StatefulWidget {
  const _Drawer();

  @override
  State<_Drawer> createState() => _DrawerState();
}

class _DrawerState extends State<_Drawer> {
  late final selicEditController = TextEditingController();

  final SelicRate _selicRate = SelicRate.instance;
  final repository = SelicRepositoryImpl(SelicDatabaseService());

  @override
  void initState() {
    super.initState();

    if (_selicRate.rate == null) {
      _loadSelicRate();
    } else {
      _setControllerSelic();
    }
  }

  Future<void> _loadSelicRate() async {
    _selicRate.rate = await repository.getSelicRate();
    _setControllerSelic();
  }

  Future<void> saveSelic(String value) async {
    double parsed = double.parse(value);
    await repository.saveSelicRate(parsed);
    _selicRate.rate = parsed;
    _setControllerSelic();
  }

  void _setControllerSelic() {
    setState(() {
      selicEditController.text = _selicRate.rate.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Compra Certa'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calculate),
            title: const Text('Calculadora de Investimentos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InvestmentCalculatorPage(),
                ),
              );
            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 32),
            child: TextFormField(
              controller: selicEditController,
              decoration: InputDecoration(label: Text('Taxa Selic Anual')),
              onFieldSubmitted: saveSelic,
            ),
          ),
        ],
      ),
    );
  }
}
