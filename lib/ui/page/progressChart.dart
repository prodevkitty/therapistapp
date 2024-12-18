// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart'; // For formatting dates

// // Example model class to hold the progress data
// class ProgressData {
//   final DateTime date;
//   final double stressLevel;
//   final double negativeThoughtsReduction;
//   final double positiveThoughtsIncrease;

//   ProgressData({
//     required this.date,
//     required this.stressLevel,
//     required this.negativeThoughtsReduction,
//     required this.positiveThoughtsIncrease,
//   });
// }

// class ProgressChart extends StatelessWidget {
//   final List<ProgressData> progressData;

//   const ProgressChart({
//     Key? key,
//     required this.progressData,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     List<FlSpot> stressSpots = [];
//     List<FlSpot> reductionSpots = [];
//     List<FlSpot> increaseSpots = [];

//     for (var entry in progressData) {
//       stressSpots.add(FlSpot(
//           entry.date.millisecondsSinceEpoch.toDouble(), entry.stressLevel));
//       reductionSpots.add(FlSpot(entry.date.millisecondsSinceEpoch.toDouble(),
//           entry.negativeThoughtsReduction));
//       increaseSpots.add(FlSpot(entry.date.millisecondsSinceEpoch.toDouble(),
//           entry.positiveThoughtsIncrease));
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Journey to Wellness'), // Static title, replace with translation if needed
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: LineChart(
//           LineChartData(
//             gridData: FlGridData(show: true),
//             titlesData: FlTitlesData(
//               bottomTitles: SideTitles(
//                 showTitles: true,
//                 getTextStyles: (context, value) => TextStyle(
//                   color: Colors.black,
//                   fontSize: 10,
//                 ),
//                 margin: 10,
//                 getTitles: (value) {
//                   DateTime date =
//                       DateTime.fromMillisecondsSinceEpoch(value.toInt());
//                   return DateFormat('MM/dd').format(date);
//                 },
//               ),
//               leftTitles: SideTitles(showTitles: true),
//             ),
//             borderData: FlBorderData(show: true),
//             lineBarsData: [
//               LineChartBarData(
//                 spots: stressSpots,
//                 isCurved: true,
//                 colors: [Colors.red],
//                 belowBarData: BarAreaData(show: true, colors: [
//                   Colors.red.withOpacity(0.3),
//                 ]),
//                 barWidth: 4,
//               ),
//               LineChartBarData(
//                 spots: reductionSpots,
//                 isCurved: true,
//                 colors: [Colors.blue],
//                 belowBarData: BarAreaData(show: true, colors: [
//                   Colors.blue.withOpacity(0.3),
//                 ]),
//                 barWidth: 4,
//               ),
//               LineChartBarData(
//                 spots: increaseSpots,
//                 isCurved: true,
//                 colors: [Colors.green],
//                 belowBarData: BarAreaData(show: true, colors: [
//                   Colors.green.withOpacity(0.3),
//                 ]),
//                 barWidth: 4,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }