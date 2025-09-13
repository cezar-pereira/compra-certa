import 'package:shared_preferences/shared_preferences.dart';

class SelicDatabaseService {
  Future<void> saveSelicRate(double rate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('selic_rate', rate);
  }

  Future<double?> getSelicRate() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getDouble('selic_rate');
    return value;
  }
}
