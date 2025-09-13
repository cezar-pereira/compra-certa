import 'package:compra_certa/domain/usecases/calculate_investment_returns_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/investment_result_entity.dart';

class InvestmentCalculatorPage extends StatefulWidget {
  const InvestmentCalculatorPage({super.key});

  @override
  State<InvestmentCalculatorPage> createState() =>
      _InvestmentCalculatorPageState();
}

class _InvestmentCalculatorPageState extends State<InvestmentCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _initialValueController = TextEditingController();
  final _monthlyInvestmentController = TextEditingController(text: '0');
  final _monthsController = TextEditingController();
  final _selicRateController = TextEditingController();

  final _calculateInvestmentUseCase = CalculateInvestmentReturnsUsecase();

  InvestmentResultEntity? _investmentResult;

  Future<void> _calculate() async {
    final value = double.parse(_initialValueController.text);

    _investmentResult = _calculateInvestmentUseCase.call(
      valueWithDiscount: value,
      annualSelicRate: double.parse(_selicRateController.text),
      value: value,
      numberOfMonths: int.parse(_monthsController.text),
      withWithdrawl: false,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora de Investimentos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _initialValueController,
                decoration: const InputDecoration(labelText: 'Valor Inicial'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              TextFormField(
                enabled: false,
                controller: _monthlyInvestmentController,
                decoration: const InputDecoration(labelText: 'Aporte Mensal'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _monthsController,
                decoration: const InputDecoration(
                  labelText: 'Quantidade de Meses',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },

                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              TextFormField(
                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: _selicRateController,
                decoration: const InputDecoration(
                  labelText: 'Taxa Selic Anual (%)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
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
              if (_investmentResult != null)
                Column(
                  children: [
                    Text(
                      'Dados do Investimento:',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      'Valor líquido: R\$ ${_investmentResult?.totalNetYield.toStringAsFixed(2)}',
                    ),
                    Text(
                      'Total bruto: R\$ ${_investmentResult?.totalYield.toStringAsFixed(2)}',
                    ),
                    Text(
                      'Total de imposto: R\$ ${_investmentResult?.totalTax.toStringAsFixed(2)}',
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
