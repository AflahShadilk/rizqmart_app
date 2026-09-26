import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/features/presentation/cubits/navigation/navigation_cubit.dart';
import 'package:rizqmart/features/presentation/pages/main/navbar/widgets/page_container.dart';

class NavigationBarPage extends StatelessWidget {
  const NavigationBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, selectedIndex) {
          return ScaffoldMessenger(
            child: Scaffold(
              extendBody: true,
              body: PageContainer(selectedIndex: selectedIndex),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: const Border(
                    top: BorderSide(
                      color: AppColors.dividerGray,
                      width: 1,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: selectedIndex,
                  onTap: (index) {
                    context.read<NavigationCubit>().updateIndex(index);
                  },
                  selectedItemColor: AppColors.primaryBlue,
                  unselectedItemColor: AppColors.textSecondary,
                  selectedLabelStyle: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700, // SemiBold or Bold for active
                  ),
                  unselectedLabelStyle: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w500, // Medium for inactive
                  ),
                  items: const [
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 4.0),
                        child: Icon(Icons.dashboard_rounded),
                      ),
                      label: 'Dashboard',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 4.0),
                        child: Icon(Icons.search_rounded),
                      ),
                      label: 'Explore',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 4.0),
                        child: Icon(Icons.favorite_border_rounded),
                      ),
                      label: 'Wishlist',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 4.0),
                        child: Icon(Icons.shopping_cart_outlined),
                      ),
                      label: 'Cart',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}