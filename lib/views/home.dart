import 'package:criptomonedas/models/crypto_model.dart';
import 'package:criptomonedas/models/crypto_trending_model.dart';
import 'package:criptomonedas/network/get_crypto_trending.dart';
import 'package:criptomonedas/network/get_currency_chart_data.dart';
import 'package:criptomonedas/network/get_currency_detail.dart';
import 'package:criptomonedas/views/crypto_detail_future.dart';
import 'package:criptomonedas/views/crypto_search.dart';
import 'package:criptomonedas/views/crypto_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class SalesData {
  SalesData(this.day, this.value);
  final DateTime day;
  final double value;
}

class _HomeState extends State<Home> {
  ApiGrafica? apiGrafica;
  ApiCriptomoneda? apiCriptomoneda;
  ApiTrending? apiTrending;
  var num_trending;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiGrafica = ApiGrafica();
    apiCriptomoneda = ApiCriptomoneda();
    apiTrending = ApiTrending();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
      body: FutureBuilder(
        future: Future.wait([
          apiGrafica!.getChart('bitcoin'),
          apiCriptomoneda!.getCrypto('bitcoin'),
          apiGrafica!.getChart('ethereum'),
          apiCriptomoneda!.getCrypto('ethereum'),
          apiGrafica!.getChart('binancecoin'),
          apiCriptomoneda!.getCrypto('binancecoin'),
          apiGrafica!.getChart('tether'),
          apiCriptomoneda!.getCrypto('tether'),
          apiGrafica!.getChart('solana'),
          apiCriptomoneda!.getCrypto('solana'),
          apiGrafica!.getChart('cardano'),
          apiCriptomoneda!.getCrypto('cardano'),
          apiGrafica!.getChart('ripple'),
          apiCriptomoneda!.getCrypto('ripple'),
          apiGrafica!.getChart('polkadot'),
          apiCriptomoneda!.getCrypto('polkadot'),
          apiGrafica!.getChart('dogecoin'),
          apiCriptomoneda!.getCrypto('dogecoin'),
          apiGrafica!.getChart('shiba-inu'),
          apiCriptomoneda!.getCrypto('shiba-inu'),
          apiTrending!.getTrending(),
        ]).timeout(const Duration(seconds: 25)),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error'),
            );
          } else {
            if (snapshot.connectionState == ConnectionState.done) {
              num_trending = snapshot.data![20].length;
              print(num_trending);
              return inicio(snapshot.data!);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
        },
      ),
    );
  }

  Widget inicio(List<dynamic> data) {
    return Stack(
      children: [
        //SEARCH BAR
        SafeArea(
            child: Container(
                child: ListView(children: [
          Container(
            margin: EdgeInsets.only(right: 20, left: 20, top: 10),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.white12),
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                    spreadRadius: 0,
                    blurRadius: 15,
                    offset: Offset(0.1, 0.4)),
              ],
            ),
            child: TextField(
              onSubmitted: (value) {
                if (value == '') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Ingresa una moneda para buscar',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Ubuntu',
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.red,
                  ));
                } else {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  CryptoSearch(value),
                          transitionDuration: Duration(milliseconds: 800)));
                }
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '  Buscar criptomoneda',
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 25,
                  )),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Text(
              'Top 10 criptomonedas',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 170,
            margin: EdgeInsets.only(right: 20, left: 0),
            padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                CryptoView(data[0], data[1]),
                CryptoView(data[2], data[3]),
                CryptoView(data[4], data[5]),
                CryptoView(data[6], data[7]),
                CryptoView(data[8], data[9]),
                CryptoView(data[10], data[11]),
                CryptoView(data[12], data[13]),
                CryptoView(data[14], data[15]),
                CryptoView(data[16], data[17]),
                CryptoView(data[18], data[19]),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Monedas en tendencia',
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold),
            ),
          ),
        ]))),
        Container(
          padding: EdgeInsets.only(
            top: 360,
          ),
          child: ListView.builder(
            itemCount: num_trending,
            itemBuilder: (context, index) {
              CryptoTrendingModel trend = data[20].elementAt(index);
              print(trend);
              List<SalesData> chartData = [];
              for (var a = 0; a < trend.chart!.prices!.length; a++) {
                chartData.add(SalesData(
                    DateTime.fromMillisecondsSinceEpoch(
                        trend.chart!.prices![a][0]),
                    trend.chart!.prices![a][1]));
              }
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  CryptoDetailFuture(
                                      trend.chart!,
                                      CryptoModel(
                                          trend.id,
                                          trend.symbol,
                                          trend.name,
                                          '',
                                          trend.large,
                                          '',
                                          trend.priceBtc,
                                          0)),
                          transitionDuration: Duration(milliseconds: 800)));
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1.0),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                          spreadRadius: 0,
                          blurRadius: 15,
                          offset: Offset(0.1, 0.4)),
                    ],
                  ),
                  height: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 2,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(trend.large!))),
                        ),
                      ),
                      Flexible(
                          fit: FlexFit.tight,
                          flex: 3,
                          child: Column(
                            children: [
                              Container(
                                child: Text(
                                  trend.name!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      fontFamily: 'Ubuntu'),
                                ),
                              ),
                              Container(
                                child: Text(
                                  trend.symbol!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      fontFamily: 'Ubuntu'),
                                ),
                              ),
                            ],
                          )),
                      Flexible(
                        flex: 6,
                        fit: FlexFit.tight,
                        child: Container(
                          child: SfCartesianChart(
                            palette: [Colors.blue],
                            legend: Legend(isVisible: false),
                            primaryXAxis: DateTimeAxis(
                                axisLine: AxisLine(
                                  width: 0,
                                ),
                                isVisible: false),
                            plotAreaBorderWidth: 0,
                            borderWidth: 0,
                            primaryYAxis: NumericAxis(isVisible: false),
                            series: <ChartSeries>[
                              // Renders line chart
                              LineSeries<SalesData, DateTime>(
                                dataSource: chartData,
                                xValueMapper: (SalesData sales, _) => sales.day,
                                yValueMapper: (SalesData sales, _) =>
                                    sales.value,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
