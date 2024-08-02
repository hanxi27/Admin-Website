import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class AgeDistributionWidget extends StatefulWidget {
  @override
  _AgeDistributionWidgetState createState() => _AgeDistributionWidgetState();
}

class _AgeDistributionWidgetState extends State<AgeDistributionWidget> {
  Map<String, int> ageDistribution = {'<21': 0, '21-35': 0, '36-59': 0, '>59': 0};

  @override
  void initState() {
    super.initState();
    fetchAgeDistribution();
  }

  Future<void> fetchAgeDistribution() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
    Map<String, int> ageDist = {'<21': 0, '21-35': 0, '36-59': 0, '>59': 0};
    for (var doc in querySnapshot.docs) {
      final String? ageStr = doc['age']?.toString();
      if (ageStr != null) {
        int age = int.parse(ageStr);
        if (age < 21) {
          ageDist['<21'] = ageDist['<21']! + 1;
        } else if (age >= 21 && age <= 35) {
          ageDist['21-35'] = ageDist['21-35']! + 1;
        } else if (age >= 36 && age <= 59) {
          ageDist['36-59'] = ageDist['36-59']! + 1;
        } else {
          ageDist['>59'] = ageDist['>59']! + 1;
        }
      }
    }
    setState(() {
      ageDistribution = ageDist;
    });
  }

  List<BarChartGroupData> _createAgeData() {
    return ageDistribution.entries.map((entry) {
      int index;
      switch (entry.key) {
        case '<21':
          index = 0;
          break;
        case '21-35':
          index = 1;
          break;
        case '36-59':
          index = 2;
          break;
        case '>59':
          index = 3;
          break;
        default:
          index = 0;
      }
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: Colors.lightBlueAccent,
            width: 30,
            borderRadius: BorderRadius.circular(0),
          )
        ],
      );
    }).toList()
    ..sort((a, b) => a.x.compareTo(b.x));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text('Age Distribution'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: _createAgeData(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
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
                        getTitlesWidget: (double value, TitleMeta meta) {
                          String text;
                          switch (value.toInt()) {
                            case 0:
                              text = '<21';
                              break;
                            case 1:
                              text = '21-35';
                              break;
                            case 2:
                              text = '36-59';
                              break;
                            case 3:
                              text = '>59';
                              break;
                            default:
                              return Container();
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 8,
                            child: Text(text),
                          );
                        },
                      ),
                    ),
                  ),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipPadding: const EdgeInsets.all(8),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        String ageRange;
                        switch (group.x.toInt()) {
                          case 0:
                            ageRange = '<21';
                            break;
                          case 1:
                            ageRange = '21-35';
                            break;
                          case 2:
                            ageRange = '36-59';
                            break;
                          case 3:
                            ageRange = '>59';
                            break;
                          default:
                            ageRange = '';
                        }
                        return BarTooltipItem(
                          '$ageRange\n${rod.toY}',
                          TextStyle(color: Colors.yellow),
                        );
                      },
                    ),
                    touchCallback: (FlTouchEvent event, BarTouchResponse? barTouchResponse) {
                      setState(() {
                        if (event.isInterestedForInteractions &&
                            barTouchResponse != null &&
                            barTouchResponse.spot != null) {
                          final spot = barTouchResponse.spot;
                          final index = spot!.touchedBarGroupIndex;
                          if (index != -1) {
                            print('Touched index: $index');
                          }
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
