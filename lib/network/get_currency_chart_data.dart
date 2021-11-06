import 'dart:convert';
import 'package:criptomonedas/models/chart_model.dart';
import 'package:http/http.dart' as http;

class ApiGrafica {
  Future<ChartModel?> getChart(var id) async {
    var URL = Uri.parse('https://api.coingecko.com/api/v3/coins/' +
        id.toString() +
        '/market_chart?vs_currency=usd&days=15&interval=daily');

    final response = await http.get(URL);
    if (response.statusCode == 200) {
      var popular = jsonDecode(response.body)['prices'] as List;
      ChartModel listaPuntos = ChartModel(popular);
      return listaPuntos;
    } else {
      return null;
    }
  }
}
