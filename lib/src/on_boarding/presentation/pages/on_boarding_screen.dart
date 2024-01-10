import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_classes_platform/config/assets/app_colors.dart';
import 'package:online_classes_platform/config/assets/assets.dart';
import 'package:online_classes_platform/core/common/views/page_loading.dart';
import 'package:online_classes_platform/core/common/widgets/gradient_background.dart';
import 'package:online_classes_platform/src/on_boarding/domain/entities/page_content.dart';
import 'package:online_classes_platform/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:online_classes_platform/src/on_boarding/presentation/widgets/on_boarding_body.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  static const String routeName = '/';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final pageController = PageController();

  @override
  void initState() {
    super.initState();
    context.read<OnBoardingCubit>().checkIfUserIsFirstTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<OnBoardingCubit, OnBoardingState>(
        listener: (BuildContext context, OnBoardingState state) {
          if (state is OnBoardingUserStatus && !state.isFirstTimer) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is OnBoardingUserCached) {
            //TODO
          }
        },
        builder: (BuildContext context, OnBoardingState state) {
          if (state is OnBoardingUserStatus && state.isFirstTimer) {
            return GradientBackground(
              imageUrl: Assets.imagesOnBoardingBackground,
              child: Stack(
                children: [
                  PageView(
                    controller: pageController,
                    children: [
                      OnBoardingBody(pageContent: PageContent.first()),
                      OnBoardingBody(pageContent: PageContent.second()),
                      OnBoardingBody(pageContent: PageContent.third()),
                    ],
                  ),
                  Align(
                    alignment: const Alignment(0, .04),
                    child: SmoothPageIndicator(
                      controller: pageController,
                      count: 3,
                      onDotClicked: (index) {
                        pageController.animateToPage(
                          index,
                          duration: const Duration(
                            milliseconds: 400,
                          ),
                          curve: Curves.easeInOut,
                        );
                      },
                      effect: const WormEffect(
                        dotHeight: 12,
                        dotWidth: 12,
                        spacing: 48,
                        activeDotColor: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const PageLoading();
        },
      ),
    );
  }
}
