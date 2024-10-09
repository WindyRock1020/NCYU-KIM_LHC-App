import 'package:flutter/material.dart';
import 'dart:math';

class pointsChart extends StatelessWidget {
  final double bodyPosturePoints;
  final double loadWeightPoints;
  final double frequencyPoints;
  final double handlingPoints;
  final double unfavourablePoints;
  final double workOrganizationPoints;

  pointsChart({
    required this.bodyPosturePoints,
    required this.loadWeightPoints,
    required this.frequencyPoints,
    required this.handlingPoints,
    required this.unfavourablePoints,
    required this.workOrganizationPoints,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(300, 300),
      painter: RadarChartPainter(
        bodyPosturePoints: bodyPosturePoints,
        loadWeightPoints: loadWeightPoints,
        frequencyPoints: frequencyPoints,
        handlingPoints: handlingPoints,
        unfavourablePoints: unfavourablePoints,
        workOrganizationPoints: workOrganizationPoints,
      ),
    );
  }
}

class RadarChartPainter extends CustomPainter {
  final double bodyPosturePoints;
  final double loadWeightPoints;
  final double frequencyPoints;
  final double handlingPoints;
  final double unfavourablePoints;
  final double workOrganizationPoints;

  RadarChartPainter({
    required this.bodyPosturePoints,
    required this.loadWeightPoints,
    required this.frequencyPoints,
    required this.handlingPoints,
    required this.unfavourablePoints,
    required this.workOrganizationPoints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint gridPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Paint dataPaint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = min(size.width / 2, size.height / 2) * 0.8;

    // 各項評級項目
    final List<String> labels = [
      '身體姿勢',
      '時間評級',
      '不良工作條件',
      '工作時間分配',
      '負荷處理條件',
      '負重評級'
    ];

    // 各項評級分數
    final List<double> points = [
      bodyPosturePoints,
      frequencyPoints,
      unfavourablePoints,
      workOrganizationPoints,
      handlingPoints,
      loadWeightPoints,
    ];

    // 各項評級最大分數
    final List<double> maxPoints = [26, 10, 13, 4, 4, 100];

    // 繪製六邊形網格
    for (int i = 0; i <= 3; i++) {
      final double scale = (i + 1) / 4;
      _drawPolygon(canvas, centerX, centerY, radius * scale, gridPaint);
    }
    // 繪製對角線
    _drawDiagonals(canvas, centerX, centerY, radius, gridPaint);
    // 繪製數據區域
    Path dataPath = Path();
    for (int i = 0; i < points.length; i++) {
      final angle = (i * pi / 3) - pi / 2;
      final double percent = points[i] / maxPoints[i];  // 根據最大值標準化
      final dx = centerX + radius * percent * cos(angle);
      final dy = centerY + radius * percent * sin(angle);
      if (i == 0) {
        dataPath.moveTo(dx, dy);
      } else {
        dataPath.lineTo(dx, dy);
      }
    }
    dataPath.close();
    canvas.drawPath(dataPath, dataPaint);
    final List<int> dxList =[40, 30, 40, 40, 40, 30];
    final List<int> dyList =[30, 45, 60, 30, 60, 45];
    // 繪製每個標籤、分數
    for (int i = 0; i < labels.length; i++) {
      final angle = (i * pi / 3) - pi / 2;
      final dx = centerX + (radius + dxList[i]) * cos(angle);
      final dy = centerY + (radius + dyList[i]) * sin(angle);
      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(color: Colors.black, fontSize: 16),
          children: <TextSpan>[
            TextSpan(text: '\n${points[i].toString().replaceAll(".0", "")}分', style: TextStyle(fontSize:22,fontWeight: FontWeight.bold)), // 這是第二部分的文字，使用不同樣式
          ],
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(dx - textPainter.width / 2, dy - textPainter.height / 2));
    }
  }
  // 繪製六邊形
  void _drawPolygon(Canvas canvas, double centerX, double centerY, double radius, Paint paint) {
    final Path path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * pi / 3) - pi / 2;
      final dx = centerX + radius * cos(angle);
      final dy = centerY + radius * sin(angle);
      if (i == 0) {
        path.moveTo(dx, dy);
      } else {
        path.lineTo(dx, dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }
  void _drawDiagonals(Canvas canvas, double centerX, double centerY, double radius, Paint paint) {
    for (int i = 0; i < 6; i++) {
      final angle = (i * pi / 3) - pi / 2;
      final dx = centerX + radius * cos(angle);
      final dy = centerY + radius * sin(angle);
      canvas.drawLine(Offset(centerX, centerY), Offset(dx, dy), paint);
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
