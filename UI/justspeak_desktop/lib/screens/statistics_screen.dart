import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  static const List<FlSpot> _userData = [
    FlSpot(0, 200),
    FlSpot(1, 200),
    FlSpot(2, 20),
    FlSpot(3, 600),
    FlSpot(4, 200),
    FlSpot(5, 30),
    FlSpot(6, 30),
  ];

  static const List<FlSpot> _sessionData = [
    FlSpot(0, 3700),
    FlSpot(1, 500),
    FlSpot(2, 1150),
    FlSpot(3, 400),
    FlSpot(4, 1300),
    FlSpot(5, 2500),
    FlSpot(6, 2900),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[700],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCard(
                  'Active sessions',
                  '20',
                  Colors.white,
                  Colors.purple[800]!,
                ),
                _buildCard(
                  'Tutors',
                  '120',
                  Colors.purple[300]!,
                  Colors.purple[800]!,
                ),
                _buildCard(
                  'Students',
                  '5000',
                  Colors.purple[900]!,
                  Colors.purple[800]!,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Graphs
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildGraphCard('Users', _userData)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildGraphCard('Sessions', _sessionData)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    String title,
    String value,
    Color bgColor,
    Color textColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: textColor, fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraphCard(String title, List<FlSpot> data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: data,
                    isCurved: true,
                    barWidth: 3,
                    color: Colors.purple,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.purple.withOpacity(0.3),
                    ),
                  ),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toString());
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
