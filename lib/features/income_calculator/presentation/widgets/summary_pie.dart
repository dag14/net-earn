import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalarySummary extends StatefulWidget {
  const SalarySummary({super.key});

  @override
  State<StatefulWidget> createState() => SalarySummaryState();
}

class SalarySummaryState extends State<SalarySummary> {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                    return;
                  }
                  touchedIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              },
            ),
            borderData: FlBorderData(show: false),
            sectionsSpace: 0,
            centerSpaceRadius: 0,
            sections: showingSections(),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final theme = Theme.of(context);
      final shadows = [
        Shadow(color: theme.shadowColor.withOpacity(0.5), blurRadius: 2)
      ];
      final textStyle = TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: shadows,
      );

      // TODO: For better theme consistency, these colors should be part of your AppTheme.
      // For example: theme.colorScheme.chartBlue, theme.colorScheme.chartPurple, etc.
      final pieColors = [
        Colors.blue,
        theme.unselectedWidgetColor, // Using a theme-based grey
        Colors.purple,
        theme.colorScheme.primary, // Using theme's primary green
      ];

      return switch (i) {
        0 => PieChartSectionData(
              color: pieColors[0],
              value: 40,
              title: '40%',
              radius: radius,
              titleStyle: textStyle,
            ),
        1 => PieChartSectionData(
              color: pieColors[1],
              value: 30,
              title: '30%',
              radius: radius,
              titleStyle: textStyle,
            ),
        2 => PieChartSectionData(
              color: pieColors[2],
              value: 16,
              title: '16%',
              radius: radius,
              titleStyle: textStyle,
            ),
        3 => PieChartSectionData(
              color: pieColors[3],
              value: 15,
              title: '15%',
              radius: radius,
              titleStyle: textStyle,
            ),
        _ => throw StateError('Invalid'),
      };
    });
  }
}
