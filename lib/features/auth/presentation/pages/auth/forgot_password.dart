

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/forgot/forgot_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/forgot/forgot_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/auth/login_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/validators/email_validator.dart';
import 'package:rizqmart/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_responsive.dart';

import '../../bloc/auth/forgot/forgot_bloc.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController emailcontroll = TextEditingController();
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
    return BlocConsumer<ForgotBloc,ForgotState>( listener:(context,state){
      if(state is ForgotSuccess){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        emailcontroll.clear();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginPage()));
      }else if(state is ForgotFailure){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));

      }
    } ,
    builder: (context, state) {
      return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 178, 255, 179), Color(0xFFFFF3E0)],
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
                  maxWidth:
                      Responsive.isDesktop(context) ? 480 : double.infinity,
                ),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.08),
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
                      color: Colors.deepOrange,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Reset password',
                        style: GoogleFonts.poppins(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Enter your email address.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: Responsive.isMobile(context) ? 12 : 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Form(
                      key: formkey,
                      child: TextFormFLogin(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailcontroll,
                        hint: 'Enter your registered email',
                        validator: emailValidator,
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.deepOrange,
                          elevation: 4,
                        ),
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            context.read<ForgotBloc>().add(ForgotSubmitted(emailcontroll.text.trim()));
                          }
                        },
                        child: Text(
                          'Reset Password',
                          style: GoogleFonts.poppins(
                            fontSize: Responsive.isMobile(context) ? 14 : 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        '← Back to Login',
                        style: GoogleFonts.poppins(
                          fontSize: Responsive.isMobile(context) ? 12 : 14,
                          color: Colors.deepOrange,
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
