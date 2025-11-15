// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signout/sign_out_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signout/sign_out_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signout/sign_out_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/auth/login_page.dart';
import 'package:rizqmart/features/auth/presentation/widgets/icon_and_name.dart';

Container topBarItems(
    BuildContext context, searchController, Function(String) onSearch) {
  final colorScheme = Theme.of(context).colorScheme;

  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Theme.of(context).appBarTheme.backgroundColor!.withOpacity(0.05),
      boxShadow: [
        BoxShadow(
          color: colorScheme.onBackground.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: [
        SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.12,
                child: const IconRizq(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: colorScheme.secondary,
                    ),
                    Text(
                      'Your Location',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withOpacity(0.7),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: BlocListener<SignOutBloc, SignOutState>(
                    listener: (context, state) {
                      if (state is LoadingSignOutState) {
                        _showLoadingDialog(context);
                        return;
                      }
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context, rootNavigator: true).pop();
                      }

                      if (state is SignOutFailureState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.error),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      } else if (state is SignOutSuccessState) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => LoginPage()));
                      }
                    },
                    child: GestureDetector(
                      onTap: () {
                        context
                            .read<SignOutBloc>()
                            .add(SignOutRequestedEvent());
                      },
                      child: Center(
                        child: Icon(
                          Icons.person,
                          color: colorScheme.onPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: TextField(
            controller: searchController,
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: 'Search products...',
              hintStyle: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
              prefixIcon: Icon(
                Icons.search,
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
              suffixIcon: searchController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        searchController.clear();
                        onSearch('');
                      },
                      child: Icon(
                        Icons.clear,
                        color: colorScheme.onSurface.withOpacity(0.4),
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: colorScheme.onSurface.withOpacity(0.2),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: colorScheme.onSurface.withOpacity(0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.greenAccent,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? colorScheme.onBackground.withOpacity(0.05)
                  : colorScheme.onBackground.withOpacity(0.03),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            style: TextStyle(
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    ),
  );
}

void _showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Signing out...'),
            ],
          ),
        ),
      );
    },
  );
}
