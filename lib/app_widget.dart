import 'package:compra_certa/ui/pages/home_page.dart';
import 'package:compra_certa/ui/pages/investment_calculator_page.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compra Certa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/investment_calculator': (context) => const InvestmentCalculatorPage(),
      },
    );
  }
}