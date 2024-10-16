import 'package:flutter/material.dart';
import 'package:bubblebalance/core/utils/log.dart';

Color getColorFromScores(double completedPoints, double expectedPoints) {
  // Если ожидаемое количество очков равно нулю, возвращаем красный
  if (expectedPoints == 0) {
    return Color.fromRGBO(215, 46, 88, 1);
  }

  // Вычисляем процент выполненных очков
  double percentage = completedPoints / expectedPoints;

  percentage = percentage.clamp(0.0, 1.0);

  // Переход от красного (0%) к зелёному (100%)
  int red = (215 * (1 - percentage)).toInt();
  int green = (215 * percentage).toInt();
  return Color.fromARGB(255, red, green, 0); // Возвращаем цвет
}
