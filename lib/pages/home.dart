import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/models/data_model.dart';
import 'package:flutter_application_1/utils/widgets/widgets.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomePage extends StatefulWidget {
  final _channel = WebSocketChannel.connect(
    Uri.parse("ws://prereg.ex.api.ampiy.com/prices"),
  );

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String msg = '{"method": "SUBSCRIBE","params": ["all@ticker"],"cid": 1}';

  @override
  void initState() {
    
    //delaying data sink in stream becuase it takes time to connect to server
    Future.delayed(Duration(seconds: 3), () {
      widget._channel.sink.add(msg);
      print('sending msg');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          height: (size.height),
          width: size.width,
          child: Stack(
            children: [
              //bottom bar
              bottomBar(size),

              //main container
              mainContainer(size, context, widget._channel.stream),

              //bottom bar center button
              bottomBarCenterButton(size),
            ],
          ),
        ),
      ),
    );
  }

  
//disposing stream
  @override
  void dispose() {
    widget._channel.sink.close();
    super.dispose();
  }
}

//line chart package
class LineChartWidget extends StatelessWidget {
  Color lineColor = Colors.black.withOpacity(0.2);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          handleBuiltInTouches: false,
        ),
        minX: 0,
        minY: 0,
        maxX: 10,
        maxY: 10,
        titlesData: LineTitles.getTitleData(),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 3),
              FlSpot(1, 5),
              FlSpot(2, 4),
              FlSpot(3, 7),
              FlSpot(4, 3),
              FlSpot(5, 8),
              FlSpot(6, 4),
              FlSpot(7, 6),
              FlSpot(8, 7),
              FlSpot(9, 5),
              FlSpot(10, 4),
            ],
            color: lineColor,
            barWidth: 1.3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: false,
            ),
          ),
        ],
        gridData: FlGridData(
          show: false,
        ),
        borderData: FlBorderData(
          show: false,
        ),
      ),
    );
  }
}

class LineTitles {
  static getTitleData() => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      );
}
