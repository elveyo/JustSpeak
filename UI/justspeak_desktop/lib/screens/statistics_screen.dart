import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/statistics.dart';
import '../providers/user_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late Future<StatisticsResponse> _statisticsFuture;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _statisticsFuture = userProvider.getStatistics();
  }

  List<Map<String, dynamic>> _extractYearMonthData(List<Map<int, int>> data) {
    final List<Map<String, dynamic>> result = <Map<String, dynamic>>[];
    for (var map in data) {
      if (map.isNotEmpty) {
        final int key = map.keys.first;
        final int year = key ~/ 100;
        final int month = key % 100;
        final int count = map.values.first;
        result.add({'year': year, 'month': month, 'count': count});
      }
    }
    result.sort((a, b) {
      int cmp = (a['year'] as int).compareTo(b['year'] as int);
      if (cmp != 0) return cmp;
      return (a['month'] as int).compareTo(b['month'] as int);
    });
    return result;
  }

  String _monthName(int month) {
    const months = [
      "",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    if (month >= 1 && month <= 12) return months[month];
    return month.toString();
  }

  String _formatLabel(Map<String, dynamic> row) {
    return "${_monthName(row['month'])} ${row['year']}";
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double screenHeight =
        mediaQuery.size.height -
        mediaQuery.viewPadding.top -
        kToolbarHeight; // minus typical appbar

    return Scaffold(
      backgroundColor: Colors.purple[700],
      body: FutureBuilder<StatisticsResponse>(
        future: _statisticsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to fetch statistics: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          final stats = snapshot.data!;
          final usersChartData = _extractYearMonthData(stats.users);
          final sessionsChartData = _extractYearMonthData(stats.sessions);

          // New layout to fill most of the available height
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: screenHeight,
              child: Column(
                children: [
                  // Top cards - make bigger with new icons and more padding/margin
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCard(
                        'Active sessions',
                        stats.sessionsNum.toString(),
                        Colors.white,
                        Colors.purple[800]!,
                        Icons.schedule,
                        iconBgColor: Colors.white,
                      ),
                      const SizedBox(width: 18),
                      _buildCard(
                        'Tutors',
                        stats.tutorsNum.toString(),
                        Colors.white,
                        Colors.purple[800]!,
                        Icons.school,
                        iconBgColor: Colors.white,
                      ),
                      const SizedBox(width: 18),
                      _buildCard(
                        'Students',
                        stats.studentsNum.toString(),
                        Colors.white,
                        Colors.purple[800]!,
                        Icons.people_alt,
                        iconBgColor: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 38),
                  // Charts section consuming more vertical space
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildLineChartCard(
                            title: "Users Growth (by Month)",
                            data: usersChartData,
                            color: Colors.purple,
                            valueLabel: "Users",
                            chartHeight: (screenHeight - 220) * 0.88,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildLineChartCard(
                            title: "Sessions Growth (by Month)",
                            data: sessionsChartData,
                            color: Colors.deepPurple,
                            valueLabel: "Sessions",
                            chartHeight: (screenHeight - 220) * 0.88,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Enhanced card with icon, larger, more padding
  Widget _buildCard(
    String title,
    String value,
    Color bgColor,
    Color textColor,
    IconData icon, {
    Color? iconBgColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.shade900.withOpacity(0.10),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: iconBgColor ?? Colors.purple[100],
              radius: 25,
              child: Icon(icon, color: textColor, size: 30),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor.withOpacity(0.9),
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show month only once on X axis
  Widget _buildLineChartCard({
    required String title,
    required List<Map<String, dynamic>> data,
    required Color color,
    required String valueLabel,
    double chartHeight = 300,
  }) {
    if (data.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: color.withOpacity(0.18), width: 1),
        ),
        child: const Center(
          child: Text("No data available", style: TextStyle(fontSize: 16)),
        ),
      );
    }

    List<int> uniqueMonthIndexes = [];
    Set<String> seenMonths = {};
    for (int i = 0; i < data.length; i++) {
      final ym = '${data[i]["year"]}-${data[i]["month"]}';
      if (!seenMonths.contains(ym)) {
        uniqueMonthIndexes.add(i);
        seenMonths.add(ym);
      }
    }
    if (uniqueMonthIndexes.isEmpty ||
        uniqueMonthIndexes.last != data.length - 1) {
      uniqueMonthIndexes.add(data.length - 1);
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.18), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.purple.shade700,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: chartHeight,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 14.0,
                left: 0.0,
                top: 0,
                bottom: 0,
              ),
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      fitInsideHorizontally: true,
                      fitInsideVertically: true,
                      getTooltipItems: (spots) {
                        return spots.map((LineBarSpot spot) {
                          final idx = spot.x.round();
                          final label = idx >= 0 && idx < data.length
                              ? _formatLabel(data[idx])
                              : "";
                          return LineTooltipItem(
                            '$label\n${spot.y.toInt()} $valueLabel',
                            TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _findMaxY(data) ~/ 5 > 0
                        ? (_findMaxY(data) / 5).ceilToDouble()
                        : 1,
                    getDrawingHorizontalLine: (value) =>
                        FlLine(color: Colors.grey[200], strokeWidth: 1),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.purple[100]!, width: 1),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) {
                          if (value == value.toInt() && value >= 0) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        interval: _findMaxY(data) ~/ 5 > 0
                            ? (_findMaxY(data) / 5).ceilToDouble()
                            : 1,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final int idx = value.round();
                          if (idx < 0 || idx >= data.length) {
                            return const SizedBox.shrink();
                          }
                          if (!uniqueMonthIndexes.contains(idx)) {
                            return const SizedBox.shrink();
                          }
                          final isFirst = idx == 0;
                          final isLast = idx == data.length - 1;
                          final bool yearChanged =
                              idx > 0 &&
                              data[idx]['year'] != data[idx - 1]['year'];
                          String lbl = _monthName(data[idx]['month']);
                          if (isFirst || yearChanged || isLast) {
                            lbl = "$lbl\n${data[idx]['year']}";
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              lbl,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black45,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                        interval: 1,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  minY: 0,
                  maxY: _findMaxY(data) * 1.2,
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      preventCurveOverShooting: true,
                      color: color,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, i) {
                          return FlDotCirclePainter(
                            radius: 3.2,
                            color: Colors.white,
                            strokeColor: color,
                            strokeWidth: 2,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: color.withOpacity(0.12),
                      ),
                      spots: List<FlSpot>.generate(
                        data.length,
                        (index) => FlSpot(
                          index.toDouble(),
                          (data[index]['count'] as num).toDouble(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _findMaxY(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return 10;
    return data
        .map<double>((row) => (row['count'] as num).toDouble())
        .reduce((a, b) => a > b ? a : b);
  }
}
