// daily_revenue.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class DailyRevenueChart extends StatelessWidget {
  final Map<DateTime, double> dailyRevenue;
  final String selectedYear;
  final String selectedMonth;
  final Function(double) onBarTouch;

  DailyRevenueChart({
    required this.dailyRevenue,
    required this.selectedYear,
    required this.selectedMonth,
    required this.onBarTouch,
  });

  List<BarChartGroupData> _buildDailyRevenueChart() {
    List<BarChartGroupData> barGroups = [];
    var sortedKeys = dailyRevenue.keys.toList()..sort();

    for (var date in sortedKeys) {
      if (DateFormat('yyyy-MM').format(date) == '$selectedYear-$selectedMonth') {
        barGroups.add(
          BarChartGroupData(
            x: date.day,
            barRods: [
              BarChartRodData(
                toY: dailyRevenue[date]!,
                color: Colors.lightBlueAccent,
                width: 20,
              ),
            ],
          ),
        );
      }
    }

    return barGroups;
  }

  String _formatDate(int day) {
    return DateFormat('d').format(DateTime(0, 1, day));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Daily Revenue', style: TextStyle(fontSize: 18)),
        Column(
          children: [
            SizedBox(
              height: 450,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: _buildDailyRevenueChart(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 60,
                          getTitlesWidget: (value, meta) {
                            if (value == dailyRevenue.values.reduce((a, b) => a > b ? a : b)) {
                              return Container();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(value.toInt().toString()),
                            );
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(_formatDate(value.toInt()));
                          },
                        ),
                      ),
                    ),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        tooltipPadding: const EdgeInsets.all(8),
                        tooltipRoundedRadius: 8,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            rod.toY.toStringAsFixed(2),
                            TextStyle(color: Colors.white),
                          );
                        },
                      ),
                      touchCallback: (FlTouchEvent event, barTouchResponse) {
                        if (event is FlTapUpEvent && barTouchResponse?.spot != null) {
                          onBarTouch(barTouchResponse!.spot!.touchedRodData.toY);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Day',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
