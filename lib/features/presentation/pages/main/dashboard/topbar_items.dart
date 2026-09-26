import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/features/presentation/routes/app_routes.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/main/address/address_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/main/address/address_state.dart';
import 'package:rizqmart/features/presentation/bloc/main/address/address_event.dart';
import 'package:rizqmart/features/presentation/pages/main/dashboard/widgets/notification_button.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';

class TopBarItems extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearch;

  const TopBarItems({
    super.key,
    required this.searchController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final isLoggedIn = currentUser != null;

    return Container(
      width: double.infinity,
      color: AppColors.primaryBlue,
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Location Display
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                       context.read<AddressBloc>().add(GetCurrentLocationEvent());
                    },
                    child: BlocBuilder<AddressBloc, AddressState>(
                      builder: (context, state) {
                        String locationText = 'Your Location';
                        if (state is LocationLoadedState) {
                          locationText = state.addressName ?? 'Unknown Location';
                        } else if (state is LocationLoadingState) {
                          locationText = 'Locating...';
                        }
                    
                        return Row(
                          mainAxisSize: MainAxisSize.min, 
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                locationText,
                                style: GoogleFonts.manrope(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                
                // User Actions Group
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Wrap with local Theme override to cleanly turn the notification icon white
                    Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                          surfaceContainerHighest: Colors.white.withValues(alpha: 0.2),
                          primary: Colors.white,
                          error: AppColors.accentOrange,
                          onError: Colors.white,
                        ),
                      ),
                      child: const NotificationButton(),
                    ),
                    const SizedBox(width: 16),
                    isLoggedIn
                        ? const ProfileButton()
                        : const LoginButton(),
                  ],
                ),
              ],
            ),
          ),
          
          // Global Search Bar Widget styled as a pill
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: searchController,
                onChanged: onSearch,
                style: GoogleFonts.manrope(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Search for groceries...',
                  hintStyle: GoogleFonts.manrope(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final photoUrl = currentUser?.photoURL ?? '';

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.profile);
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 1.5,
          ),
        ),
        child: ClipOval(
          child: photoUrl.isNotEmpty
              ? ProductImage(
                  imageUrl: photoUrl,
                  width: 36,
                  height: 36,
                  borderRadius: BorderRadius.circular(18),
                )
              : Container(
                  color: Colors.white.withValues(alpha: 0.2),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        child: Text(
          'Login',
          style: GoogleFonts.manrope(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}