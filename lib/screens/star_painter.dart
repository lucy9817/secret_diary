import 'package:flutter/material.dart';
import 'package:secret_diary_stars/models/star.dart';

class StarPainter extends CustomPainter {
  final List<Star> stars;

  StarPainter(this.stars);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // 별 그리기
    for (var star in stars) {
      paint.color = star.color;
      final offset = Offset(star.x * size.width, star.y * size.height);
      canvas.drawCircle(offset, star.size, paint);

      // 별을 터치할 수 있게 작은 원으로 감싸기
      final tapAreaPaint = Paint()
        ..color = Colors.transparent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 30;
      canvas.drawCircle(offset, star.size + 30, tapAreaPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
