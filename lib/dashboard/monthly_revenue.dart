// monthly_revenue.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class MonthlyRevenueChart extends StatelessWidget {
  final Map<String, double> monthlyRevenue;
  final String selectedYear;
  final Function(double) onBarTouch;

  MonthlyRevenueChart({
    required this.monthlyRevenue,
    required this.selectedYear,
    required this.onBarTouch,
  });

  List<BarChartGroupData> _buildMonthlyRevenueChart() {
    List<BarChartGroupData> barGroups = [];
    Map<int, double> revenuePerMonth = {};

    for (int i = 1; i <= 12; i++) {
      revenuePerMonth[i] = 0.0;
    }

    monthlyRevenue.forEach((month, revenue) {
      if (month.startsWith(selectedYear)) {
        int monthIndex = int.parse(month.split('-')[1]);
        revenuePerMonth[monthIndex] = revenue;
      }
    });

    for (int i = 1; i <= 12; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: revenuePerMonth[i] ?? 0.0,
              color: Colors.lightGreenAccent,
              width: 20,
            ),
          ],
        ),
      );
    }

    return barGroups;
  }

  String _formatMonth(int month) {
    return DateFormat('MMM').format(DateTime(0, month));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Monthly Revenue', style: TextStyle(fontSize: 18)),
        SizedBox(
          height: 500,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barGroups: _buildMonthlyRevenueChart(),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) {
                        if (value == monthlyRevenue.values.reduce((a, b) => a > b ? a : b)) {
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
                        return Text(_formatMonth(value.toInt()));
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
      ],
    );
  }
}
