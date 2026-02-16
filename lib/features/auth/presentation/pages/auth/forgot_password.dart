

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/forgot/forgot_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/forgot/forgot_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/validators/email_validator.dart';
import 'package:rizqmart/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_responsive.dart';

import '../../bloc/auth/forgot/forgot_bloc.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController emailcontroll = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double fontSize;
    final EdgeInsets padding;

    if (Responsive.isTablet(context)) {
      fontSize = 22;
      padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 24);
    } else {
      fontSize = 18;
      padding = const EdgeInsets.all(16);
    }

    return BlocConsumer<ForgotBloc, ForgotState>(
      listener: (context, state) {
        if (state is ForgotSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.success500.withValues(alpha: .2),
            ),
          );
          emailcontroll.clear();
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        } else if (state is ForgotFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: AppColors.error500.withValues(alpha: .2),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.success500,
                    AppColors.lightBackground,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              width: double.infinity,
              padding: padding,
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: Responsive.isDesktop(context) ? 480 : double.infinity,
                    ),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black10,
                          blurRadius: 20,
                          spreadRadius: 4,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock_reset,
                          size: Responsive.isDesktop(context) ? 64 : 48,
                          color: AppColors.secondary500,
                        ),
                        16.h,
                        Center(
                          child: Text(
                            'Reset password',
                            style: GoogleFonts.poppins(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w600,
                              color: AppColors.grey900,
                            ),
                          ),
                        ),
                        10.h,
                        Text(
                          'Enter your email address.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: Responsive.isMobile(context) ? 12 : 14,
                            color: AppColors.grey700,
                          ),
                        ),
                        28.h,
                        Form(
                          key: formkey,
                          child: TextFormFLogin(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailcontroll,
                            hint: 'Enter your registered email',
                            validator: emailValidator,
                          ),
                        ),
                        30.h,
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: AppColors.secondary500,
                              elevation: 4,
                            ),
                            onPressed: () {
                              if (formkey.currentState!.validate()) {
                                context
                                    .read<ForgotBloc>()
                                    .add(ForgotSubmitted(emailcontroll.text.trim()));
                              }
                            },
                            child: Text(
                              'Reset Password',
                              style: GoogleFonts.poppins(
                                fontSize:
                                    Responsive.isMobile(context) ? 14 : 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        18.h,
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            '← Back to Login',
                            style: GoogleFonts.poppins(
                              fontSize:
                                  Responsive.isMobile(context) ? 12 : 14,
                              color: AppColors.secondary500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
