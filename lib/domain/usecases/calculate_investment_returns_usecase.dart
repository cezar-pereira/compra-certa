// ignore_for_file: avoid_print

import 'dart:math';

import '../entities/investment_result_entity.dart';

class CalculateInvestmentReturnsUsecase {
  double _calculateTax(double grossYield, int month) {
    if (month <= 6) return grossYield * 0.225; // 22.5% até 180 dias
    if (month <= 12) return grossYield * 0.20; // 20% de 181 a 360 dias
    if (month <= 24) return grossYield * 0.175; // 17.5% de 361 a 720 dias
    return grossYield * 0.15; // 15% acima de 720 dias
  }

  InvestmentResultEntity call({
    required double value,
    required double valueWithDiscount,
    required double annualSelicRate,
    required int numberOfMonths,
    bool withWithdrawl = true,
  }) {
    final monthlyWithdrawal = withWithdrawl ? (value / numberOfMonths) : 0;

    final double monthlySelicRate =
        pow(1 + (annualSelicRate / 100), 1 / 12) - 1;

    double balance = value;
    double totalNetYield = 0.0;
    double totalTax = 0.0;

    double totalGrossYield = 0.0;

    for (int month = 1; month <= numberOfMonths; month++) {
      if (balance <= 0) break;

      // Calcula rendimento bruto
      double grossYield = balance * monthlySelicRate;

      totalGrossYield += grossYield;

      // Calcula IR
      double tax = _calculateTax(grossYield, month);

      // Calcula rendimento líquido
      double netYield = grossYield - tax;

      // Atualiza saldo
      balance = balance + netYield - monthlyWithdrawal;

      // Acumula totais
      totalNetYield += netYield;
      totalTax += tax;

      print('Mês: $month');
      print('Saldo: $balance');
      print('Rendimento bruto: $grossYield');
      print('Imposto: $tax');
      print('Rendimento líquido: $netYield');
      print('------------');
      print('Total rendimento: $totalGrossYield');
      print('Total imposto: $totalTax');
      print('Total rendimento liquido: ${totalGrossYield - totalTax}');
      print('====================\n');
    }

    return InvestmentResultEntity(
      value: value,
      valueWithDiscount: valueWithDiscount,
      totalNetYield: totalNetYield,
      totalTax: totalTax,
      finalBalance: balance,
    );
  }
}
