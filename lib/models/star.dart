import 'package:flutter/material.dart';

/// 별 데이터 모델
class Star {
  final double x; // 별의 x 좌표 (0.0 ~ 1.0)
  final double y; // 별의 y 좌표 (0.0 ~ 1.0)
  final double size; // 별의 크기
  final Color color; // 별의 색상
  final String content; // 별과 연관된 일기 내용 (최대 5자 표시)

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.content,
  });

  /// 별 데이터 디버깅용
  @override
  String toString() {
    return 'Star(x: $x, y: $y, size: $size, color: $color, content: $content)';
  }
}
