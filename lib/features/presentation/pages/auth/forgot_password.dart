import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/features/presentation/routes/app_routes.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/features/presentation/bloc/auth/forgot/forgot_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/auth/forgot/forgot_event.dart';
import 'package:rizqmart/features/presentation/bloc/auth/forgot/forgot_state.dart';
import 'package:rizqmart/features/presentation/pages/validators/email_validator.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController emailcontroll = TextEditingController();

  @override
  void dispose() {
    emailcontroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotBloc, ForgotState>(
      listener: (context, state) {
        if (state is ForgotSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.success500.withValues(alpha: 0.2),
          ));
          emailcontroll.clear();
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        } else if (state is ForgotFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
            backgroundColor: AppColors.error500.withValues(alpha: 0.2),
          ));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.primaryBlue,
          resizeToAvoidBottomInset: true,
          body: Column(
            children: [
              // Blue header ~200px
              Container(
                width: double.infinity,
                height: 200,
                color: AppColors.primaryBlue,
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800, // ExtraBold
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "We'll email you a reset link",
                        style: GoogleFonts.manrope(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w400, // Regular
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // White rounded-top card
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Form(
                      key: formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reset Password',
                            style: GoogleFonts.manrope(
                              color: AppColors.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.w800, // ExtraBold
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Enter the email linked to your account',
                            style: GoogleFonts.manrope(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w400, // Regular
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Email Field
                          Text(
                            'EMAIL',
                            style: GoogleFonts.manrope(
                              color: AppColors.labelGray,
                              fontSize: 12,
                              fontWeight: FontWeight.w600, // SemiBold
                            ),
                          ),
                          TextFormField(
                            controller: emailcontroll,
                            validator: emailValidator,
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.manrope(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your email',
                              hintStyle: GoogleFonts.manrope(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 8),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.dividerGray, width: 1),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.primaryBlue, width: 1),
                              ),
                              errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 1),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          
                          // Send Reset Link Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                if (formkey.currentState!.validate()) {
                                  context.read<ForgotBloc>().add(
                                    ForgotSubmitted(emailcontroll.text.trim())
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Send Reset Link',
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Remember your password? Login
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: "Remember your password? ",
                                  style: GoogleFonts.manrope(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Login",
                                      style: GoogleFonts.manrope(
                                        color: AppColors.primaryBlue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
