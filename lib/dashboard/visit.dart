import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class VisitChart extends StatelessWidget {
  final Map<DateTime, int> dailyVisits;  // Map of DateTime to the number of visits (purchases)
  final String selectedYear;
  final String selectedMonth;

  VisitChart({
    required this.dailyVisits,
    required this.selectedYear,
    required this.selectedMonth,
  });

  List<BarChartGroupData> _buildDailyVisitChart() {
    List<BarChartGroupData> barGroups = [];
    var sortedKeys = dailyVisits.keys.toList()..sort();

    for (var date in sortedKeys) {
      if (DateFormat('yyyy-MM').format(date) == '$selectedYear-$selectedMonth') {
        barGroups.add(
          BarChartGroupData(
            x: date.day,
            barRods: [
              BarChartRodData(
                toY: dailyVisits[date]!.toDouble(),
                color: Colors.orangeAccent,
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
        Text('Daily Visits', style: TextStyle(fontSize: 18)),
        Column(
          children: [
            SizedBox(
              height: 450,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: _buildDailyVisitChart(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 60,
                          getTitlesWidget: (value, meta) {
                            if (value % 1 == 0 && value > 0) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(value.toInt().toString()),
                              );
                            }
                            return Container();  // Do not show anything for irrelevant values
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
                            rod.toY.toStringAsFixed(0),  // Display the number of visits without decimals
                            TextStyle(color: Colors.white),
                          );
                        },
                      ),
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
