import 'package:flutter_test/flutter_test.dart';
import 'package:compra_certa/domain/usecases/calculate_investment_returns_usecase.dart';

void main() {
  group('CalculateInvestmentReturnsUsecase', () {
    late CalculateInvestmentReturnsUsecase useCase;

    setUp(() {
      useCase = CalculateInvestmentReturnsUsecase();
    });

    test(
      'should calculate investment returns with monthly withdrawals correctly',
      () {
        final result = useCase.call(
          annualSelicRate: 15.0,
          value: 200.0,
          valueWithDiscount: 180.0,
          numberOfMonths: 12,
        );

        expect(result.value, 200.0);
        expect(result.totalNetYield, greaterThan(0));
        expect(result.totalTax, greaterThan(0));
        expect(
          result.finalBalance,
          lessThan(200.0),
        ); // Deve ser menor devido aos saques
      },
    );

    test(
      'should calculate investment returns without monthly withdrawals correctly',
      () {
        final result = useCase.call(
          annualSelicRate: 15.0,
          value: 1000.0,
          valueWithDiscount: 900.0,
          numberOfMonths: 12,
        );

        expect(result.value, 1000.0);
        expect(result.totalNetYield, greaterThan(0));
        expect(result.totalTax, greaterThan(0));
        expect(
          result.balanceTotal,
          greaterThan(1000.0),
        ); // Deve ser maior devido ao rendimento
      },
    );

    test('should calculate tax correctly for different periods', () {
      final result6Months = useCase.call(
        annualSelicRate: 10.0,
        value: 1000.0,
        valueWithDiscount: 900.0,

        numberOfMonths: 6,
      );

      final result12Months = useCase.call(
        annualSelicRate: 10.0,
        value: 1000.0,
        valueWithDiscount: 900.0,

        numberOfMonths: 12,
      );

      // Verifica se os impostos estão sendo calculados corretamente
      expect(result6Months.totalTax, greaterThan(0));
      expect(result12Months.totalTax, greaterThan(0));
      expect(result6Months.totalTax, lessThan(result12Months.totalTax));
    });
  });
}
