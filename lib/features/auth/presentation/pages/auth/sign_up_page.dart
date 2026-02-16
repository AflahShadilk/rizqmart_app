

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signUp/signup_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signUp/signup_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signUp/signup_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/validators/email_validator.dart';
import 'package:rizqmart/features/auth/presentation/pages/validators/name_validator.dart';
import 'package:rizqmart/features/auth/presentation/pages/validators/password_validator.dart';
import 'package:rizqmart/features/auth/presentation/widgets/app_logo.dart';
import 'package:rizqmart/features/auth/presentation/widgets/auth_decoration_names.dart';
import 'package:rizqmart/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/elevated_buttons.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/text_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_responsive.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';

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
    final double fontSize;

    if (Responsive.isTablet(context)) {
      fontSize = 22;
    } else {
      fontSize = 18;
    }

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
                        child: Icon(
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
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        final isKeyboardVisible = keyboardHeight > 0;
        return ResponsiveWrapper(child: Scaffold(
          backgroundColor: Colors.green.shade100,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    25.h,
                    Center(child: CommonAppLogo()),
                    5.h,
                  ],
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 200),
                  top: isKeyboardVisible
                      ? MediaQuery.of(context).size.height * 0.15
                      : MediaQuery.of(context).size.height * 0.41,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: createAccount,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Create Account',
                                style: GoogleFonts.poppins(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            5.h,
                            fieldCatogoryName('Full Name'),
                            TextFormFLogin(
                              controller: nameField,
                              hint: 'Enter your full name',
                              validator: nameFieldValidator,
                            ),
                            5.h,
                            fieldCatogoryName('Email'),
                            TextFormFLogin(
                              controller: email,
                              hint: 'Enter your email',
                              validator: emailValidator,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            5.h,
                            fieldCatogoryName('Password'),
                            TextFormFLogin(
                              controller: password,
                              hint: 'Enter password',
                              validator: passwordValidator,
                              obscureText: true,
                            ),
                            5.h,
                            fieldCatogoryName('Confirm Password'),
                            TextFormFLogin(
                              controller: cpassword,
                              hint: 'Re-enter password',
                              validator: passwordValidator,
                              obscureText: true,
                            ),
                            15.h,
                            Center(
                              child: elevatedButton(fontSize,
                                  onpress: () {
                                if (createAccount.currentState!
                                    .validate()) {
                                  context.read<SignupBloc>().add(
                                      SignupSubmitted(
                                          name: nameField.text.trim(),
                                          email: email.text.trim(),
                                          password:
                                              password.text.trim(),
                                          conformPass:
                                              cpassword.text.trim()));
                                }
                              },
                                  color: Colors.green,
                                  padd: const EdgeInsets.symmetric(
                                      horizontal: 80, vertical: 14),
                                  content: 'Get Started'),
                            ),
                            10.h,
                            Center(
                              child: textButtonAuth(context,
                                  onpress: () {
                                Navigator.pushReplacementNamed(context, AppRoutes.login);
                              },
                                  content:
                                      "Already have an account?Login",
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
      },
    );
  }
}