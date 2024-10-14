import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:plinko/core/utils/icon_provider.dart';

import '../ui_kit/bottom_bar/bottom_bar.dart';

class RootNavigationScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const RootNavigationScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  State<RootNavigationScreen> createState() => _RootNavigationScreenState();
}

class _RootNavigationScreenState extends State<RootNavigationScreen> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    widget.navigationShell.currentIndex == 4
                        ? IconProvider.backgroundQ.buildImageUrl()
                        : IconProvider.background.buildImageUrl(),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: widget.navigationShell,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: BottomBar(
                selectedIndex: currentIndex,
                onTap: _onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(int index) {
    currentIndex = index;
    widget.navigationShell.goBranch(
      index,
      initialLocation: true,
    );
  }
}
