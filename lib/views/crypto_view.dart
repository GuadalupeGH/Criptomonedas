import 'package:criptomonedas/models/chart_model.dart';
import 'package:criptomonedas/models/crypto_model.dart';
import 'package:criptomonedas/views/crypto_detail.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CryptoView extends StatefulWidget {
  final ChartModel chartData;
  final CryptoModel criptoModel;
  CryptoView(this.chartData, this.criptoModel);

  @override
  _CryptoViewState createState() => _CryptoViewState();
}

class SalesData {
  SalesData(this.day, this.value);
  final DateTime day;
  final double value;
}

class _CryptoViewState extends State<CryptoView> {
  @override
  Widget build(BuildContext context) {
    List<SalesData> chartData = [];
    for (var a = 0; a < widget.chartData.prices!.length; a++) {
      chartData.add(SalesData(
          DateTime.fromMillisecondsSinceEpoch(widget.chartData.prices![a][0]),
          widget.chartData.prices![a][1]));
    }
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    CryptoDetail(widget.chartData, widget.criptoModel),
                transitionDuration: Duration(milliseconds: 800)));
      },
      child: Container(
        margin: EdgeInsets.only(top: 20, right: 0, bottom: 20, left: 10),
        padding: EdgeInsets.only(left: 20),
        width: 140,
        height: 170,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.15),
                  spreadRadius: 0,
                  blurRadius: 15,
                  offset: Offset(0.1, 0.4)),
            ],
            color: Color.fromRGBO(255, 255, 255, 1.0),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(widget.criptoModel.image!))),
                  ),
                  Container(
                    child: Text(
                      widget.criptoModel.symbol!.toUpperCase(),
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              flex: 8,
              child: Column(
                children: [
                  Container(
                    height: 100,
                    child: Hero(
                        tag: 'detail' + widget.criptoModel.id!,
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
                            ])),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
