import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:orora2/super_base.dart';

class BarChartSample2 extends StatefulWidget {
  final Map incomeData;
  final Map expenses;
  final String title;
  const BarChartSample2({super.key, required this.incomeData, required this.expenses, required this.title});

  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends Superbase<BarChartSample2> {
  final double width = 7;

   List<BarChartGroupData> rawBarGroups = [];
   List<BarChartGroupData> showingBarGroups = [];

  int touchedGroupIndex = -1;

  double maxY = 4.0;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData();
    });
  }

  void loadData(){
    final items = <BarChartGroupData>[];
    int k=0;
    widget.incomeData.forEach((key, value) {

      double inc = (value as num).toDouble();
      double exp = (widget.expenses[key] as num).toDouble();

      maxY = max(maxY, max(inc, exp));

      items.add(makeGroupData(k++, exp, inc));
    });

    rawBarGroups = items;

    setState(() {
      showingBarGroups = rawBarGroups;
    });
  }

  @override
  void didUpdateWidget(covariant BarChartSample2 oldWidget) {
    if(widget.incomeData != oldWidget.incomeData){
      loadData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 6,
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: Theme.of(context).primaryColorLight,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10).copyWith(bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15).copyWith(bottom: 25,right: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(widget.title,style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                    const Text("7 days")
                  ],
                ),
              ),
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: maxY,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.grey,
                        getTooltipItem: (a, b, c, d) => null,
                      ),
                      touchCallback: (FlTouchEvent event, response) {
                        if (response == null || response.spot == null) {
                          setState(() {
                            touchedGroupIndex = -1;
                            showingBarGroups = List.of(rawBarGroups);
                          });
                          return;
                        }

                        touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                        setState(() {
                          if (!event.isInterestedForInteractions) {
                            touchedGroupIndex = -1;
                            showingBarGroups = List.of(rawBarGroups);
                            return;
                          }
                          showingBarGroups = List.of(rawBarGroups);
                          if (touchedGroupIndex != -1) {
                            var sum = 0.0;
                            for (final rod
                                in showingBarGroups[touchedGroupIndex].barRods) {
                              sum += rod.toY;
                            }
                            final avg = sum /
                                showingBarGroups[touchedGroupIndex].barRods.length;

                            showingBarGroups[touchedGroupIndex] =
                                showingBarGroups[touchedGroupIndex].copyWith(
                              barRods: showingBarGroups[touchedGroupIndex]
                                  .barRods
                                  .map((rod) {
                                return rod.copyWith(toY: avg);
                              }).toList(),
                            );
                          }
                        });
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: bottomTitles,
                          reservedSize: 42,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 39,
                          interval: maxY/4,
                          getTitlesWidget: leftTitles,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    barGroups: showingBarGroups,
                    gridData: FlGridData(show: false),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.normal,
      fontSize: 10,
    );
    String text= formatter.format(value);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style,maxLines: 2,overflow: TextOverflow.ellipsis,),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    List<String> titles = [];

    widget.incomeData.forEach((key, value) {
      titles.add(key);
    });

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.normal,
        fontSize: 10,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 2,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Colors.black54,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          width: width,
          color: Theme.of(context).primaryColorDark,
        ),
      ],
    );
  }

}
