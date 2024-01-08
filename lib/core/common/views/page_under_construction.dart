import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:online_classes_platform/core/assets/assets.dart';
import 'package:online_classes_platform/core/common/widgets/gradient_background.dart';

class PageUnderConstruction extends StatelessWidget {
  const PageUnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        imageUrl: Assets.lottiePageUnderConstruction,
        child: Lottie.asset(Assets.lottiePageUnderConstruction),
      ),
    );
  }
}
