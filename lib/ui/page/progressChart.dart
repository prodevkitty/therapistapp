import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'package:fl_chart/fl_chart.dart';

class ProgressData {
  final DateTime date;
  final double stressLevel;
  final double negativeThoughtsReduction;
  final double positiveThoughtsIncrease;

  ProgressData({
    required this.date,
    required this.stressLevel,
    required this.negativeThoughtsReduction,
    required this.positiveThoughtsIncrease,
  });
}

class ProgressChart extends StatelessWidget {
  final List<ProgressData> progressData;

  const ProgressChart({
    Key? key,
    required this.progressData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> stressBarGroups = [];
    List<BarChartGroupData> reductionBarGroups = [];
    List<BarChartGroupData> increaseBarGroups = [];

    for (int i = 0; i < progressData.length; i++) {
      ProgressData entry = progressData[i];
      double xValue = i.toDouble(); // Use the index as x-axis value

      stressBarGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: entry.stressLevel,
              color: Colors.red,
              width: 10,
            ),
          ],
        ),
      );

      reductionBarGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: entry.negativeThoughtsReduction,
              color: Colors.blue,
              width: 10,
            ),
          ],
        ),
      );

      increaseBarGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: entry.positiveThoughtsIncrease,
              color: Colors.green,
              width: 10,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Your Progress Over Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          // Stress Level Bar Chart
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Stress Levels',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BarChart(
                BarChartData(
                  barGroups: stressBarGroups,
                  titlesData: _buildTitlesData(progressData),
                  borderData: FlBorderData(show: true),
                  gridData: FlGridData(show: true),
                ),
              ),
            ),
          ),
          // Negative Thoughts Reduction Bar Chart
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Negative Thoughts Reduction',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BarChart(
                BarChartData(
                  barGroups: reductionBarGroups,
                  titlesData: _buildTitlesData(progressData),
                  borderData: FlBorderData(show: true),
                  gridData: FlGridData(show: true),
                ),
              ),
            ),
          ),
          // Positive Thoughts Increase Bar Chart
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Positive Thoughts Increase',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BarChart(
                BarChartData(
                  barGroups: increaseBarGroups,
                  titlesData: _buildTitlesData(progressData),
                  borderData: FlBorderData(show: true),
                  gridData: FlGridData(show: true),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  FlTitlesData _buildTitlesData(List<ProgressData> progressData) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            int index = value.toInt();
            if (index >= 0 && index < progressData.length) {
              DateTime date = progressData[index].date;
              return Text(
                DateFormat('MM/dd').format(date),
                style: const TextStyle(fontSize: 10),
              );
            }
            return const Text('');
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: true),
      ),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}
