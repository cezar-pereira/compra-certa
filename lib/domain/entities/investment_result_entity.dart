enum InvestmentResultEntityAdvantage {
  cash,
  card;

  bool get isCash => this == InvestmentResultEntityAdvantage.cash;
  bool get isCard => this == InvestmentResultEntityAdvantage.card;
}

class InvestmentResultEntity {
  final double totalNetYield;
  final double totalTax;
  final double value;
  final double valueWithDiscount;
  final double finalBalance;

  double get balanceTotal => value + totalNetYield;
  double get totalYield => totalNetYield + totalTax;

  double get advantageValue {
    switch (advantage) {
      case InvestmentResultEntityAdvantage.cash:
        return (value - valueWithDiscount) - totalNetYield;
      case InvestmentResultEntityAdvantage.card:
        return totalNetYield - (value - valueWithDiscount);
    }
  }

  InvestmentResultEntityAdvantage get advantage {
    final difference = value - valueWithDiscount;

    final dvantage = difference > totalNetYield
        ? InvestmentResultEntityAdvantage.cash
        : InvestmentResultEntityAdvantage.card;

    return dvantage;
  }

  InvestmentResultEntity({
    required this.value,
    required this.valueWithDiscount,
    required this.totalNetYield,
    required this.totalTax,
    required this.finalBalance,
  });
}
