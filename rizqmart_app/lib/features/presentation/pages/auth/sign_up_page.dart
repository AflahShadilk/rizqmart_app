

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/routes/app_routes.dart';
import 'package:rizqmart/features/presentation/bloc/auth/signUp/signup_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/auth/signUp/signup_event.dart';
import 'package:rizqmart/features/presentation/bloc/auth/signUp/signup_state.dart';
import 'package:rizqmart/features/presentation/pages/validators/email_validator.dart';
import 'package:rizqmart/features/presentation/pages/validators/name_validator.dart';
import 'package:rizqmart/features/presentation/pages/validators/password_validator.dart';
import 'package:rizqmart/features/presentation/widgets/common/icon_and_name.dart';
import 'package:rizqmart/features/presentation/widgets/common/auth_decoration_names.dart';
import 'package:rizqmart/features/presentation/widgets/common/auth_text_field.dart';
import 'package:rizqmart/features/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/presentation/widgets/buttons/text_button.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> createAccount = GlobalKey<FormState>();
  final TextEditingController nameField = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController cpassword = TextEditingController();

  @override
  void dispose() {
    nameField.dispose();
    email.dispose();
    password.dispose();
    cpassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 600),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 60,
                        ),
                      );
                    },
                  ),
                  16.h,
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            }
          });
        } else if (state is SignupFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.cs.surface,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: ResponsiveWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const IconRizq(),
                    12.h,
                    const RizqMartName(),
                    32.h,
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Form(
                        key: createAccount,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Create Account',
                                style: context.ts.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: context.cs.onSurface,
                                ),
                              ),
                            ),
                            24.h,
                            fieldCatogoryName(context, 'Full Name'),
                            TextFormFLogin(
                              controller: nameField,
                              hint: 'Enter your full name',
                              validator: nameFieldValidator,
                            ),
                            16.h,
                            fieldCatogoryName(context, 'Email'),
                            TextFormFLogin(
                              controller: email,
                              hint: 'Enter your email',
                              validator: emailValidator,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            16.h,
                            fieldCatogoryName(context, 'Password'),
                            TextFormFLogin(
                              controller: password,
                              hint: 'Enter password',
                              validator: passwordValidator,
                              obscureText: true,
                            ),
                            16.h,
                            fieldCatogoryName(context, 'Confirm Password'),
                            TextFormFLogin(
                              controller: cpassword,
                              hint: 'Re-enter password',
                              validator: passwordValidator,
                              obscureText: true,
                            ),
                            32.h,
                            SizedBox(
                              width: double.infinity,
                              child: MainButton(
                                label: 'Get Started',
                                onPress: () {
                                  if (createAccount.currentState!.validate()) {
                                    context.read<SignupBloc>().add(
                                      SignupSubmitted(
                                        name: nameField.text.trim(),
                                        email: email.text.trim(),
                                        password: password.text.trim(),
                                        conformPass: cpassword.text.trim(),
                                      ),
                                    );
                                  }
                                },
                                color: context.cs.primary,
                                textColor: context.cs.onPrimary,
                              ),
                            ),
                            16.h,
                            Center(
                              child: AuthTextButton(
                                onPress: () {
                                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                                },
                                content: "Already have an account? Login",
                                color: context.cs.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}