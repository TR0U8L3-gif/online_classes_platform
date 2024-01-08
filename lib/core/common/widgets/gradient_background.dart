import 'package:flutter/material.dart';
import 'package:online_classes_platform/core/assets/assets.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    required this.imageUrl,
    required this.child,
    super.key,
  });

  final Widget child;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
