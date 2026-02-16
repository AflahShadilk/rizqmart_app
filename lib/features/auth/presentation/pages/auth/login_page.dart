

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/google/google.state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/google/google_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/google/google_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signIn/signin_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signIn/signin_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signIn/signin_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/validators/email_validator.dart';
import 'package:rizqmart/features/auth/presentation/pages/validators/password_validator.dart';
import 'package:rizqmart/features/auth/presentation/widgets/app_logo.dart';
import 'package:rizqmart/features/auth/presentation/widgets/auth_decoration_names.dart';
import 'package:rizqmart/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/elevated_buttons.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/google_sign_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/text_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_responsive.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> createAccount = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
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
    return BlocConsumer<SigninBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.massage),
            backgroundColor: AppColors.success500.withValues(alpha: .2),
          ));
          Navigator.pushReplacementNamed(context,AppRoutes.navigationBar);

          email.clear();
          password.clear();
        } else if (state is SignInFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.error),
              backgroundColor: AppColors.error500.withValues(alpha: 0.3)));
        }
      },
      builder: (context, state) {
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        final isKeyboardVisible = keyboardHeight > 0;

        return ResponsiveWrapper(child: Scaffold(
          backgroundColor: Colors.green,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
              child: Stack(
            children: [
              Column(
                children: [
                  40.h,
                  Center(child: CommonAppLogo()),
                  20.h,
                ],
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 200),
                top: isKeyboardVisible
                    ? MediaQuery.of(context).size.height * 0.15
                    : MediaQuery.of(context).size.height * 0.43,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black10,
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
                              'Login',
                              style: GoogleFonts.poppins(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black50,
                              ),
                            ),
                          ),
                          24.h,
                          fieldCatogoryName('Email'),
                          TextFormFLogin(
                            controller: email,
                            hint: 'Enter your email',
                            validator: emailValidator,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          10.h,
                          fieldCatogoryName('Password'),
                          TextFormFLogin(
                            controller: password,
                            hint: 'Enter password',
                            validator: passwordValidator,
                            obscureText: true,
                          ),
                          textButtonAuth(context, onpress: () {
                            Navigator.of(context).pushNamed(AppRoutes.forgot);
                          }, content: "Forgot Password?", color: AppColors.black),

                          
                          Center(
                            child: elevatedButton(fontSize, onpress: () async {
                              if (createAccount.currentState!.validate()) {
                                context.read<SigninBloc>().add(
                                    SignInSubmittedEvent(
                                        emailId: email.text.trim(),
                                        password: password.text.trim()));
                              }
                            },
                                color: Colors.green,
                                padd: const EdgeInsets.symmetric(
                                    horizontal: 80, vertical: 14),
                                content: 'Login'),
                          ),
                          Center(
                            child:
                                BlocConsumer<GooogleAuthBloc, GooogleAuthState>(
                              listener: (context, state) {
                                if (state is GooogleAuthFailure) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Google Sign-In Error: ${state.message}')),
                                  );
                                } else if (state is GooogleAuthSuccess) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Welcome ${state.user.displayName ?? state.user.email}',
                                      ),
                                    ),
                                  );
                                  Navigator.pushReplacementNamed(context, AppRoutes.navigationBar);
                                }
                              },
                              builder: (context, state) {
                                if (state is GooogleAuthLoading) {
                                  return const SizedBox(
                                    height: 50,
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                }

                                return GoogleSignInButton(
                                  onPressed: () {
                                    context
                                        .read<GooogleAuthBloc>()
                                        .add(SignInWithGoogleEvent());
                                    
                                    
                                  },
                                );
                              },
                            ),
                          ),
                          5.h,
                          Center(
                            child: textButtonAuth(context, onpress: () {
                              Navigator.pushNamed(context, AppRoutes.signUp);
                            },
                                content: "Don't have an account? Sign up",
                                color: Colors.green),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
        ));
      },
    );
  }
}