import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/features/presentation/routes/app_routes.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/main/address/address_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/main/address/address_state.dart';
import 'package:rizqmart/features/presentation/bloc/main/address/address_event.dart';
import 'package:rizqmart/features/presentation/pages/main/dashboard/widgets/notification_button.dart';

/// A custom app bar widget rendered on the blue header background.
/// Contains the logo, location indicator, action icons, and a white pill search bar.
class TopBarItems extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearch;

  const TopBarItems({
    super.key,
    required this.searchController,
    required this.onSearch,
  });

// ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentUser = FirebaseAuth.instance.currentUser;
    final isLoggedIn = currentUser != null;

    // Transparent — the blue Scaffold background shows through as the header color
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: Column(
        children: [
          // Safe-area top padding
          SizedBox(height: MediaQuery.of(context).padding.top + 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // App Logo / Branding Image
                Image(
                  image: const AssetImage('assets/icons_and_images/carrot.png'),
                  width: size.width * 0.08,
                  color: Colors.white,
                ),
                12.w,

                // Location Display — tapping refreshes the current location
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
                              size: 18,
                            ),
                            4.w,
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

                // Notification bell and profile — override colorScheme so icons render white
                Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                      surfaceContainerHighest: Colors.white.withValues(alpha: 0.2),
                      primary: Colors.white,
                      error: AppColors.accentAmber,
                      onError: Colors.white,
                    ),
                  ),
                  child: const NotificationButton(),
                ),
                12.w,
                isLoggedIn ? const ProfileButton() : const LoginButton(),
              ],
            ),
          ),

          // White pill search bar sits at the bottom of the blue header area.
          // The rounded white card in DashboardPage starts just below this.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
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
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- User Action Widgets ----------------

/// Circular profile avatar button; tapping navigates to the profile page.
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

/// Builds a quick login button for guest users to sign in.
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