import 'package:flutter/material.dart';

class BaseContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final Text text;
  final double? paddingHorizontal;
  final double? paddingVertical;
  final bool isCircle;

  const BaseContainer({
    super.key,
    this.width,
    this.height,
    required this.text,
    this.paddingHorizontal,
    this.paddingVertical,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.symmetric(
        horizontal: paddingHorizontal ?? 0,
        vertical: paddingVertical ?? 0,
      ),
      decoration: BoxDecoration(
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        gradient: const LinearGradient(
          colors: [Color(0xFFF5C660), Color(0xFFF264CE)],
        ),
        borderRadius: isCircle ? null : BorderRadius.circular(42),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: Offset(2, 3),
          ),
        ],
      ),
      child: Center(child: text),
    );
  }
}
