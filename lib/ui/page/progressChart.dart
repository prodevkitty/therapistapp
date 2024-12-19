import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: EdgeInsets.all(12),  
            child: Center(
              child: Text(
                'Your Progress Over Time',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _buildLineChart(
            progressData,
            'Stress Levels',
            (data) => data.stressLevel,
            const [Colors.red, Colors.orange],
          ),
          _buildLineChart(
            progressData,
            'Negative Thoughts Reduction',
            (data) => data.negativeThoughtsReduction,
            const [Colors.blue, Colors.lightBlueAccent],
          ),
          _buildLineChart(
            progressData,
            'Positive Thoughts Increase',
            (data) => data.positiveThoughtsIncrease,
            const [Colors.green, Colors.lightGreenAccent],
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(
    List<ProgressData> data,
    String title,
    double Function(ProgressData) valueSelector,
    List<Color> gradientColors,
  ) {
    List<FlSpot> spots = data
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), valueSelector(entry.value)))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: _buildTitlesData(data),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    left: BorderSide(color: Colors.grey),
                    bottom: BorderSide(color: Colors.grey),
                  ),
                ),
                minY: 0,
                maxY: 10,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    gradient: LinearGradient(colors: gradientColors),
                    barWidth: 4,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: gradientColors
                            .map((color) => color.withOpacity(0.2))
                            .toList(),
                      ),
                    ),
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
      
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
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    DateFormat('MM/dd').format(date),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
            }
            return const Text('');
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
        return Text(
          value.toString(),
          style: const TextStyle(fontSize: 10),
        );
          },
        ),
      ),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}
