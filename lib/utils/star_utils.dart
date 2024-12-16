import 'dart:math';
import 'package:flutter/material.dart';
import '../models/star.dart';
import '../database/db_helper.dart';

// 별 데이터를 생성하는 함수
Future<List<Star>> generateStarsFromDiary() async {
  final db = await DBHelper.instance.database;
  final result = await db.query('diary_entries');

  final random = Random();
  return result.map((entry) {
    final emotion = entry['emotion'] as String;
    final content = entry['content'] as String;
    final color = getColorByEmotion(emotion);

    return Star(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: random.nextDouble() * 5 + 2, // 별 크기 (2~7 사이)
      color: color,
      content: content.length > 5
          ? '${content.substring(0, 5)}...'
          : content, // 5글자 제한
    );
  }).toList();
}

// 감정에 따라 별 색상 지정
Color getColorByEmotion(String emotion) {
  switch (emotion) {
    case '행복':
      return Colors.yellow;
    case '슬픔':
      return Colors.blue;
    case '화남':
      return Colors.red;
    case '평온':
      return Colors.green;
    default:
      return Colors.white;
  }
}
