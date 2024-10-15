import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'dart:math' as math;

import 'package:bubblebalance/core/utils/icon_provider.dart';
import 'package:bubblebalance/routes/route_value.dart';
import 'package:bubblebalance/ui_kit/app_icon/widget/app_icon.dart';

class BottomBar extends StatefulWidget {
  final int selectedIndex;
  final void Function(int) onTap;
  const BottomBar(
      {super.key, required this.selectedIndex, required this.onTap});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;

  final List<double> _initialAngles = [0, -18, 0, 0, 0];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 9),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFD9D9D9),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            SizedBox(
              height: 81,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildIconButton(
                      index: 0,
                      iconUrl: IconProvider.home.buildImageUrl(),
                      iconUrlA: IconProvider.homeA.buildImageUrl(),
                      initialAngle: _initialAngles[0],
                      onPressed: () {
                        context.go(RouteValue.menu.path);
                        _onItemTapped(0);
                      },
                    ),
                    _buildIconButton(
                      index: 1,
                      iconUrl: IconProvider.anal.buildImageUrl(),
                      iconUrlA: IconProvider.analA.buildImageUrl(),
                      initialAngle: _initialAngles[1],
                      onPressed: () {
                        context.go(RouteValue.analytics.path);
                        _onItemTapped(1);
                      },
                    ),
                    _buildIconButton(
                      index: 2,
                      iconUrl: IconProvider.tips.buildImageUrl(),
                      iconUrlA: IconProvider.tipsA.buildImageUrl(),
                      initialAngle: _initialAngles[2],
                      onPressed: () {
                        context.go(RouteValue.tips.path);
                        _onItemTapped(2);
                      },
                    ),
                    _buildIconButton(
                      index: 3,
                      iconUrl: IconProvider.settings.buildImageUrl(),
                      iconUrlA: IconProvider.settingsA.buildImageUrl(),
                      initialAngle: _initialAngles[3],
                      onPressed: () {
                        context.go(RouteValue.settings.path);
                        _onItemTapped(3);
                      },
                    ),
                    _buildIconButton(
                      index: 4,
                      iconUrl: IconProvider.quiz.buildImageUrl(),
                      iconUrlA: IconProvider.quizA.buildImageUrl(),
                      initialAngle: _initialAngles[4],
                      onPressed: () {
                        context.go(RouteValue.tests.path);
                        _onItemTapped(4);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildAnimatedSelection(0),
                    _buildAnimatedSelection(1),
                    _buildAnimatedSelection(2),
                    _buildAnimatedSelection(3),
                    _buildAnimatedSelection(4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    widget.onTap(index);
  }

  Widget _buildIconButton({
    required int index,
    required String iconUrl,
    required String iconUrlA,
    required double initialAngle,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashRadius: 20,
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: 0,
              end: _currentIndex == index ? 15 : 0,
            ),
            duration: const Duration(milliseconds: 300),
            builder: (context, angle, child) {
              return Transform.rotate(
                angle: (initialAngle + angle) * math.pi / 180,
                child: child,
              );
            },
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: 0,
                end: _currentIndex == index ? -10 : 0,
              ),
              duration: const Duration(milliseconds: 300),
              builder: (context, offset, child) {
                return Transform.translate(
                  offset: Offset(0, offset),
                  child: AppIcon(
                    asset: _currentIndex == index ? iconUrlA : iconUrl,
                    height: 30,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedSelection(int index) {
    return AnimatedOpacity(
      opacity: _currentIndex == index ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: AppIcon(
        asset: IconProvider.tbi.buildImageUrl(),
        width: 58,
      ),
    );
  }
}
