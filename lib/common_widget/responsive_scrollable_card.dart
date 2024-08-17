import 'package:flutter/material.dart';

import '../utils/api_const.dart';
import '../utils/app_constant.dart';
import 'responsive_center.dart';

class ResponsiveScrollableCard extends StatelessWidget {
  const ResponsiveScrollableCard({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ResponsiveCenter(
        maxContentWidth: Breakpoint.tablet,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p16),
            child: child,
          ),
        ),
      ),
    );
  }
}
