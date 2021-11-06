import 'dart:convert';
import 'package:criptomonedas/models/crypto_trending_model.dart';
import 'package:criptomonedas/network/get_currency_chart_data.dart';
import 'package:http/http.dart' as http;

class ApiTrending {
  Future<List<CryptoTrendingModel>?> getTrending() async {
    var URL = Uri.parse('https://api.coingecko.com/api/v3/search/trending');

    final response = await http.get(URL);

    if (response.statusCode == 200) {
      var popular = jsonDecode(response.body)['coins'] as List;

      List<CryptoTrendingModel>? listaTrending = popular
          .map((moneda) => CryptoTrendingModel.fromMap(moneda['item']))
          .toList();
      for (var i = 0; i < listaTrending.length; i++) {
        listaTrending.elementAt(i).chart =
            await ApiGrafica().getChart(listaTrending.elementAt(i).id);
      }
      print(listaTrending.elementAt(0).chart);

      return listaTrending;
    } else {
      return null;
    }
  }
}
