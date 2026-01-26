import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AppBarAlert.dart';

class AnimationContainerInAppBar extends StatelessWidget {
  final bool isShowMenu;
  final Function(String) onSelect;

  const AnimationContainerInAppBar({
    required this.isShowMenu,
    required this.onSelect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: kToolbarHeight + 1,
      left: 10,
      right: 16,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: isShowMenu ? 1 : 0,
        child: IgnorePointer(
          ignoring: !isShowMenu,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            child: isShowMenu
                ? AppBarAlert(showMenu: isShowMenu, onSelect: onSelect)
                : const SizedBox(),
          ),
        ),
      ),
    );
  }
}
