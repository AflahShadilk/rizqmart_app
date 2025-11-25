// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signout/sign_out_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signout/sign_out_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signout/sign_out_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/auth/login_page.dart';
import 'package:rizqmart/features/auth/presentation/widgets/dialogs/logout_dailog.dart';
import 'package:rizqmart/features/auth/presentation/widgets/search_helper/search_bar.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';

Container topBarItems(
  BuildContext context,
  searchController,
  Function(String) onSearch,
) {
   
  final size = MediaQuery.of(context).size;

  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),

      color: Theme.of(context).appBarTheme.foregroundColor,

      boxShadow: [
        BoxShadow(
          color: context.cs.primary.withOpacity(0.10),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: [
        const SizedBox(height: 60),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              // ---------- LOGO
              SizedBox(
                width: size.width * 0.1,
                child: const ClipRRect(
                  child: Image(
                    image: AssetImage('assets/icons_and_images/carrot.png'),
                  ),
                ),
              ),

              // ---------- LOCATION
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: context.cs.secondary,             
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Your Location',
                    style:context.ts.bodyMedium?.copyWith(
                      color:context.cs.onSurface,          
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // ---------- PROFILE BUTTON 
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                     context.cs.secondary,
                     context.cs.secondary.withOpacity(0.7),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:context.cs.secondary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: BlocListener<SignOutBloc, SignOutState>(
                  listener: (context, state) {
                    if (state is LoadingSignOutState) {
                      showLoadingDialog(context);
                      return;
                    }
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context, rootNavigator: true).pop();
                    }

                    if (state is SignOutFailureState) {
                      showToast(
                        context,
                        state.error,
                        type: ToastType.error,
                      );
                    } else if (state is SignOutSuccessState) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    }
                  },
                  child: GestureDetector(
                    onTap: () {
                      context.read<SignOutBloc>().add(SignOutRequestedEvent());
                    },
                    child: Center(
                      child: Icon(
                        Icons.person,
                        color:context.cs.onSecondary, 
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 13, 15, 8),
          child: SearchField(
            controller: searchController, 
            onChanged: onSearch,
          ),
        ),
      ],
    ),
  );
}
