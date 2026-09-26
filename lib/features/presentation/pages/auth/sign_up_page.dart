import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/features/presentation/routes/app_routes.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/features/presentation/bloc/auth/signUp/signup_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/auth/signUp/signup_event.dart';
import 'package:rizqmart/features/presentation/bloc/auth/signUp/signup_state.dart';
import 'package:rizqmart/features/presentation/pages/validators/email_validator.dart';
import 'package:rizqmart/features/presentation/pages/validators/name_validator.dart';
import 'package:rizqmart/features/presentation/pages/validators/password_validator.dart';

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
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.error500.withValues(alpha: 0.3),
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
                        'Create Account',
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800, // ExtraBold
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Join RizqMart today',
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
                      key: createAccount,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Full Name Field
                          _buildFieldLabel('FULL NAME'),
                          _buildTextField(
                            controller: nameField,
                            hint: 'Enter your full name',
                            validator: nameFieldValidator,
                          ),
                          const SizedBox(height: 24),
                          
                          // Email Field
                          _buildFieldLabel('EMAIL'),
                          _buildTextField(
                            controller: email,
                            hint: 'Enter your email',
                            validator: emailValidator,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 24),
                          
                          // Password Field
                          _buildFieldLabel('PASSWORD'),
                          _buildPasswordField(
                            controller: password,
                            hint: 'Enter password',
                            validator: passwordValidator,
                            isObscure: _obscurePassword,
                            onToggle: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          const SizedBox(height: 24),
                          
                          // Confirm Password Field
                          _buildFieldLabel('CONFIRM PASSWORD'),
                          _buildPasswordField(
                            controller: cpassword,
                            hint: 'Re-enter password',
                            validator: passwordValidator,
                            isObscure: _obscureConfirmPassword,
                            onToggle: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                          const SizedBox(height: 40),
                          
                          // Create Account Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Create Account',
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Terms & Privacy Policy
                          Center(
                            child: Text(
                              'By signing up you agree to our Terms & Privacy Policy',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.manrope(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Already have an account? Login
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(context, AppRoutes.login);
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: "Already have an account? ",
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

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.manrope(
        color: AppColors.labelGray,
        fontSize: 12,
        fontWeight: FontWeight.w600, // SemiBold
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      style: GoogleFonts.manrope(
        color: AppColors.textPrimary,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: hint,
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
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    required bool isObscure,
    required VoidCallback onToggle,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: isObscure,
      style: GoogleFonts.manrope(
        color: AppColors.textPrimary,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: hint,
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
        suffixIcon: IconButton(
          icon: Icon(
            isObscure ? Icons.visibility_off : Icons.visibility,
            color: AppColors.textSecondary,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}