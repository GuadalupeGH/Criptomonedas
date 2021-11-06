import 'package:criptomonedas/models/chart_model.dart';
import 'package:criptomonedas/models/crypto_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CryptoDetail extends StatefulWidget {
  final ChartModel chartData;
  final CryptoModel criptoModel;
  CryptoDetail(this.chartData, this.criptoModel);

  @override
  _CryptoDetailState createState() => _CryptoDetailState();
}

class SalesData {
  SalesData(this.day, this.value);
  final DateTime day;
  final double value;
}

class _CryptoDetailState extends State<CryptoDetail> {
  final formateador = NumberFormat.currency(
    locale: 'es_MX',
    symbol: '\$',
  );
  @override
  Widget build(BuildContext context) {
    List<SalesData> chartData = [];
    for (var a = 0; a < widget.chartData.prices!.length; a++) {
      chartData.add(SalesData(
          DateTime.fromMillisecondsSinceEpoch(widget.chartData.prices![a][0]),
          widget.chartData.prices![a][1]));
    }
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
      body: Container(
        margin: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              spreadRadius: 0,
              blurRadius: 15,
              offset: Offset(0.1, 0.4)),
        ], color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: ListView(
          children: [
            Container(
              child: Wrap(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(widget.criptoModel.image!))),
                  ),
                  Text(
                    widget.criptoModel.name! +
                        ' (' +
                        widget.criptoModel.symbol!.toUpperCase() +
                        ')',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Ubuntu',
                      fontSize: 40,
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child:
                  Text('Fecha de creacion:' + widget.criptoModel.genesisDate!),
            ),
            Container(
              child: Text('\nPrecio actual (USD): ' +
                  formateador.format(widget.criptoModel.currentPriceUsd) +
                  '\n\nPrecio actual(MXN):' +
                  formateador.format(widget.criptoModel.currentPriceMxn!)),
            ),
            Container(
              margin: EdgeInsets.only(top: 30, bottom: 20),
              child: Text(
                  'Grafica BTC/USD de los ultimos ' +
                      widget.chartData.prices!.length.toString() +
                      ' dias',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Ubuntu',
                    fontSize: 15,
                  )),
            ),
            Container(
              height: 300,
              width: double.infinity,
              child: Hero(
                tag: 'detail' + widget.criptoModel.id!,
                child: SfCartesianChart(
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                    ),
                    palette: [Colors.blue],
                    legend: Legend(isVisible: false),
                    primaryXAxis: DateTimeAxis(
                        axisLine: AxisLine(
                          width: 1,
                        ),
                        dateFormat: DateFormat.Md(),
                        autoScrollingMode: AutoScrollingMode.start,
                        isVisible: true,
                        interval: 2,
                        autoScrollingDeltaType: DateTimeIntervalType.days,
                        enableAutoIntervalOnZooming: true,
                        interactiveTooltip: InteractiveTooltip(
                          enable: true,
                        )),
                    plotAreaBorderWidth: 0,
                    borderWidth: 0,
                    primaryYAxis: NumericAxis(isVisible: true),
                    enableAxisAnimation: false,
                    series: <ChartSeries>[
                      // Renders line chart
                      LineSeries<SalesData, DateTime>(
                          dataSource: chartData,
                          xValueMapper: (SalesData sales, _) => sales.day,
                          yValueMapper: (SalesData sales, _) => sales.value,
                          name: 'Precio')
                    ]),
              ),
            ),
            Container(
              child: Text(
                widget.criptoModel.description!,
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
