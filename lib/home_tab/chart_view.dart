import 'package:calendar_every/provider/chart_provider.dart';
import 'package:calendar_every/theme/agro_text_style.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class ChartView extends StatefulWidget {
  const ChartView({super.key});

  @override
  State<ChartView> createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              DateTime.now().month.toString() + '월 운동',
              style: AgroTextStyle.headlineLarge,
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                context.read<ChartProvider>().getLastDayOfMonth(DateTime.now());
              },
              child: Stack(
                children: [
                  AspectRatio(
                      aspectRatio: 2.0,
                      child: Consumer<ChartProvider>(
                        builder: (context, provider, child) {
                          return PieChart(
                            PieChartData(
                              sectionsSpace: 0,
                              centerSpaceRadius: 30,
                              sections: [
                                //운동한날
                                PieChartSectionData(
                                    value: provider.workDay.toDouble(),
                                    color: Colors.red,
                                    radius: 50,
                                    title: '${provider.workDay.toString()}일'),
                                //이번달 남은 날
                                PieChartSectionData(
                                    value:
                                        (provider.lastDay - DateTime.now().day)
                                            .toDouble(),
                                    color: Colors.blue,
                                    radius: 50,
                                    title:
                                        '${(provider.lastDay - DateTime.now().day)}일'),
                                //운동 인증안한날
                                PieChartSectionData(
                                    value:
                                        (DateTime.now().day - provider.workDay)
                                            .toDouble(),
                                    color: Colors.greenAccent,
                                    radius: 50,
                                    title:
                                        '${(DateTime.now().day - provider.workDay)}일'),
                              ],
                            ),
                          );
                        },
                      )),
                  Positioned.fill(
                      right: 16,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text('남은 날')
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text('운동 간 날')
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.greenAccent,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text('운동 안간 날')
                              ],
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '지난 6개월 운동량',
              style: AgroTextStyle.headlineLarge,
            ),
            AspectRatio(
              aspectRatio: 2,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Consumer<ChartProvider>(
                    builder: (context, provider, child) {
                      return LineChart(
                        LineChartData(
                          lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                  tooltipBgColor:
                                      Colors.greenAccent.withOpacity(0.7))),
                          lineBarsData: [
                            LineChartBarData(
                                spots: [
                                  FlSpot(0,
                                      provider.firstEvents.length.toDouble()),
                                  FlSpot(1,
                                      provider.secondEvents.length.toDouble()),
                                  FlSpot(2,
                                      provider.thirdEvents.length.toDouble()),
                                  FlSpot(
                                      3, provider.fourEvents.length.toDouble()),
                                  FlSpot(
                                      4, provider.fiveEvents.length.toDouble()),
                                  FlSpot(
                                      5, provider.sixEvents.length.toDouble()),
                                ],
                                isCurved: true,
                                barWidth: 1,
                                color: Colors.blue,
                                dotData: const FlDotData(
                                  show: true,
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                )),
                          ],
                          minY: 0,
                          maxY: 31,
                          titlesData: FlTitlesData(
                            show: true,
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 18,
                                interval: 1,
                                getTitlesWidget: bottomTitleWidgets,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 10,
                                reservedSize: 40,
                                getTitlesWidget: leftTitleWidgets,
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          gridData: const FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            drawHorizontalLine: false,
                          ),
                        ),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    DateTime date = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final showCalendarProvider =
          Provider.of<ChartProvider>(context, listen: false);

      showCalendarProvider.getWorkDayOfMonth(DateTime.now());
      showCalendarProvider.getLastDayOfMonth(DateTime.now());

      showCalendarProvider.getSixEventMonth(
          date, showCalendarProvider.sixEvents);
      showCalendarProvider.getSixEventMonth(
          DateTime(date.year, date.month - 1), showCalendarProvider.fiveEvents);
      showCalendarProvider.getSixEventMonth(
          DateTime(date.year, date.month - 2), showCalendarProvider.fourEvents);
      showCalendarProvider.getSixEventMonth(DateTime(date.year, date.month - 3),
          showCalendarProvider.thirdEvents);
      showCalendarProvider.getSixEventMonth(DateTime(date.year, date.month - 4),
          showCalendarProvider.secondEvents);
      showCalendarProvider.getSixEventMonth(DateTime(date.year, date.month - 5),
          showCalendarProvider.firstEvents);
    });
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '${Jiffy.now().add(months: -5).month}월';
        break;
      case 1:
        text = '${Jiffy.now().add(months: -4).month}월';
        break;
      case 2:
        text = '${Jiffy.now().add(months: -3).month}월';
        break;
      case 3:
        text = '${Jiffy.now().add(months: -2).month}월';
        break;
      case 4:
        text = '${Jiffy.now().add(months: -1).month}월';
        break;
      case 5:
        text = '${(DateTime.now().month)}월';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontSize: 12,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(value > 30 ? '' : '${value.toInt()}일', style: style),
    );
  }
}
