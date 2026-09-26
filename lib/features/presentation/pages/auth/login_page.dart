import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/features/presentation/routes/app_routes.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/features/presentation/bloc/auth/google/google.state.dart';
import 'package:rizqmart/features/presentation/bloc/auth/google/google_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/auth/google/google_event.dart';
import 'package:rizqmart/features/presentation/bloc/auth/signIn/signin_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/auth/signIn/signin_event.dart';
import 'package:rizqmart/features/presentation/bloc/auth/signIn/signin_state.dart';
import 'package:rizqmart/features/presentation/pages/validators/email_validator.dart';
import 'package:rizqmart/features/presentation/pages/validators/password_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> createAccount = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigninBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.massage),
            backgroundColor: AppColors.success500.withValues(alpha: 0.2),
          ));
          Navigator.pushReplacementNamed(context, AppRoutes.navigationBar);
          email.clear();
          password.clear();
        } else if (state is SignInFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
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
              // Header Block
              Container(
                width: double.infinity,
                height: 300,
                color: AppColors.primaryBlue,
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'RizqMart',
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800, // ExtraBold
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fresh groceries, delivered fast',
                        style: GoogleFonts.manrope(
                          color: Colors.white.withValues(alpha: 0.8), // 80% opacity
                          fontSize: 14,
                          fontWeight: FontWeight.w400, // Regular
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Overlapping Card
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
                          Text(
                            'Welcome Back',
                            style: GoogleFonts.manrope(
                              color: AppColors.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.w800, // ExtraBold
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Login to continue shopping',
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
                            controller: email,
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
                          const SizedBox(height: 24),
                          // Password Field
                          Text(
                            'PASSWORD',
                            style: GoogleFonts.manrope(
                              color: AppColors.labelGray,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextFormField(
                            controller: password,
                            validator: passwordValidator,
                            obscureText: _obscurePassword,
                            style: GoogleFonts.manrope(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
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
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: AppColors.textSecondary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(AppRoutes.forgot);
                              },
                              child: Text(
                                'Forgot Password?',
                                style: GoogleFonts.manrope(
                                  color: AppColors.primaryBlue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                if (createAccount.currentState!.validate()) {
                                  context.read<SigninBloc>().add(
                                    SignInSubmittedEvent(
                                      emailId: email.text.trim(),
                                      password: password.text.trim(),
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
                                'Login',
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // OR divider
                          Row(
                            children: [
                              const Expanded(child: Divider(color: AppColors.dividerGray, thickness: 1)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'OR',
                                  style: GoogleFonts.manrope(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Expanded(child: Divider(color: AppColors.dividerGray, thickness: 1)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Google Sign In
                          BlocConsumer<GooogleAuthBloc, GooogleAuthState>(
                            listener: (context, state) {
                              if (state is GooogleAuthFailure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Google Sign-In Error: ${state.message}')),
                                );
                              } else if (state is GooogleAuthSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Welcome ${state.user.displayName ?? state.user.email}'),
                                  ),
                                );
                                Navigator.pushReplacementNamed(context, AppRoutes.navigationBar);
                              }
                            },
                            builder: (context, state) {
                              if (state is GooogleAuthLoading) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              return SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: OutlinedButton(
                                  onPressed: () {
                                    context.read<GooogleAuthBloc>().add(SignInWithGoogleEvent());
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(color: AppColors.dividerGray, width: 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/icons_and_images/googleicon.png', height: 24, width: 24),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Sign in with Google',
                                        style: GoogleFonts.manrope(
                                          color: AppColors.textPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 32),
                          // Sign Up Link
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.signUp);
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: "Don't have an account? ",
                                  style: GoogleFonts.manrope(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Sign Up",
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