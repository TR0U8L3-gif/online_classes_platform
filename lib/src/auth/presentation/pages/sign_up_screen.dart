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
import 'package:online_classes_platform/src/auth/presentation/pages/sign_in_screen.dart';
import 'package:online_classes_platform/src/auth/presentation/widgets/sign_up_form.dart';
import 'package:online_classes_platform/src/dashboard/presentation/pages/dashboard.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const routeName = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullNameController.dispose();
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
          } else if (state is AuthSignedUp) {
            context.read<AuthBloc>().add(
                  SignInEvent(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  ),
                );
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
                  const Text(
                    'Sign up for an account',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          SignInScreen.routeName,
                        );
                      },
                      child: const Text('already have an account?'),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SignUpForm(
                    emailController: emailController,
                    passwordController: passwordController,
                    confirmPasswordController: confirmPasswordController,
                    fullNameController: fullNameController,
                    formKey: formKey,
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
                      label: 'Sign Up',
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        FirebaseAuth.instance.currentUser?.reload();
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                                SignUpEvent(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  fullName: fullNameController.text.trim(),
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
