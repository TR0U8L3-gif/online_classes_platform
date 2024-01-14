import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_classes_platform/config/assets/assets.dart';
import 'package:online_classes_platform/core/common/utils.dart';
import 'package:online_classes_platform/core/common/widgets/gradient_background.dart';
import 'package:online_classes_platform/core/common/widgets/rounded_button.dart';
import 'package:online_classes_platform/core/utils/extension/context_extensions.dart';
import 'package:online_classes_platform/src/auth/data/models/local_user_model.dart';
import 'package:online_classes_platform/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:online_classes_platform/src/auth/presentation/pages/sign_up_screen.dart';
import 'package:online_classes_platform/src/auth/presentation/widgets/sign_in_form.dart';
import 'package:online_classes_platform/src/dashboard/presentation/pages/dashboard.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const routeName = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is AuthError) {
            Utils.showSnackBar(context, state.message);
          } else if (state is AuthSignedIn) {
            context.userProvider.initUser(state.user as LocalUserModel);
            Navigator.pushReplacementNamed(context, Dashboard.routeName);
          }
        },
        builder: (_, state) {
          return GradientBackground(
            imageUrl: Assets.imagesAuthGradientBackground,
            child: SafeArea(
              child: ListView(
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                children: [
                  const Text(
                    'Easy to learn, discover more skills',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sign into your account',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      Baseline(
                        baseline: 100,
                        baselineType: TextBaseline.alphabetic,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              SignUpScreen.routeName,
                            );
                          },
                          child: const Text('register account?'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SignInForm(
                    emailController: emailController,
                    passwordController: passwordController,
                    formKey: formKey,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgot-password');
                      },
                      child: const Text('forgot password?'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (state is AuthLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else
                    RoundedButton(
                      label: 'Sign In',
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        FirebaseAuth.instance.currentUser?.reload();
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                                SignInEvent(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                ),
                              );
                        }
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
