import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_bloc.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/widget/profile_menu_item.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/wallet/wallet_screen.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';
class ProfileOptionsList extends StatefulWidget {
  final UserProfileBloc profileBloc;

  const ProfileOptionsList({super.key, required this.profileBloc});

  @override
  State<ProfileOptionsList> createState() => _ProfileOptionsListState();
}

class _ProfileOptionsListState extends State<ProfileOptionsList> {
late final String userId;
@override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  }
List<Widget> _buildMenuItems(BuildContext context) {
    return [
      ProfileMenuItem(
        icon: Icons.shopping_bag,
        title: 'Orders',
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.orders);
        },
      ),
      ProfileMenuItem(
        icon: Icons.person_outline,
        title: 'My Details',
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.profileDetails,
            arguments: widget.profileBloc,
          );
        },
      ),
      ProfileMenuItem(
        icon: Icons.location_on,
        title: 'Delivery Address',
        onTap: () {
          if (userId.isEmpty) {
            showToast(context, 'User not authenticated');
            return;
          }
          Navigator.pushNamed(
            context,
            AppRoutes.userAddress,
            arguments: userId,
          );
        },
      ),
      ProfileMenuItem(
        icon: Icons.payment_outlined,
        title: 'Payment Method',
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.savedCards);
        },
      ),
      ProfileMenuItem(
        icon: Icons.account_balance_wallet_outlined,
        title: 'My Wallet',
        onTap: () {
          if (userId.isEmpty) {
            showToast(context, 'User not authenticated');
            return;
          }
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WalletScreen(userId: userId),
            ),
          );
        },
      ),
      ProfileMenuItem(
        icon: Icons.local_offer_outlined,
        title: 'Promo code',
        onTap: () {},
      ),
      ProfileMenuItem(
        icon: Icons.settings_outlined,
        title: 'Settings',
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.settings);
        },
      ),
      ProfileMenuItem(
        icon: Icons.help_outline,
        title: 'Help',
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.help);
        },
      ),
      ProfileMenuItem(
        icon: Icons.info_outline,
        title: 'About',
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.aboutUs);
        },
      ),
    ];
  }
@override
  Widget build(BuildContext context) {
    final menuItems = _buildMenuItems(context);
    
    return ListView.separated(
      itemCount: menuItems.length,
      separatorBuilder: (context, index) => 8.h,
      itemBuilder: (context, index) => menuItems[index],
    );
  }
}
