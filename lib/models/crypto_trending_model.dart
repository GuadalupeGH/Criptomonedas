// Generated by https://quicktype.io

import 'chart_model.dart';

class CryptoTrendingModel {
  String? id;
  int? coinId;
  String? name;
  String? symbol;
  int? marketCapRank;
  String? large;
  String? slug;
  double? priceBtc;
  int? score;
  ChartModel? chart;

  CryptoTrendingModel(
      {this.id,
      this.coinId,
      this.name,
      this.symbol,
      this.marketCapRank,
      this.large,
      this.slug,
      this.priceBtc,
      this.score,
      this.chart});

  factory CryptoTrendingModel.fromMap(Map<String, dynamic> map) {
    return CryptoTrendingModel(
        id: map['id'],
        coinId: map['coind_id'],
        name: map['name'],
        symbol: map['symbol'],
        marketCapRank: map['market_cap_rank'],
        large: map['large'],
        slug: map['slug'],
        priceBtc: map['price_btc'],
        score: map['score']);
  }
}