class SelicRate {
  static final SelicRate _instance = SelicRate._internal();

  SelicRate._internal();

  static SelicRate get instance => _instance;

  double? _rate;

  double? get rate => _rate;

  set rate(double? value) {
    _rate = value ?? 0;
  }
}
