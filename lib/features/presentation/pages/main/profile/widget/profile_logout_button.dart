import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/presentation/routes/app_routes.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/bloc/auth/signout/sign_out_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/auth/signout/sign_out_event.dart';
import 'package:rizqmart/features/presentation/bloc/auth/signout/sign_out_state.dart';
import 'package:rizqmart/features/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/presentation/widgets/dialogs/logout_dailog.dart';
import 'package:rizqmart/features/presentation/widgets/common/show_toast_actions.dart';

// ---------------- Profile Logout Button ----------------

class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({super.key});

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignOutBloc, SignOutState>(
      listener: (context, state) {
        if (state is LoadingSignOutState) {
          showLoadingDialog(context);
          return;
        }
        Navigator.of(context, rootNavigator: true).pop();
        if (state is SignOutFailureState) {
          showToast(
            context,
            state.error,
            type: ToastType.error,
          );
        }
        if (state is SignOutSuccessState) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      },
      child: MainButton(
        label: 'Log Out',
        onPress: () {
          context.read<SignOutBloc>().add(SignOutRequestedEvent());
        },
        color: context.cs.primary,
        textColor: context.cs.surface,
      ),
    );
  }
}
