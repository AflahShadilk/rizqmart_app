import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/di/register.dart';
import 'package:rizqmart/features/presentation/bloc/main/cook_tonight/cook_tonight_bloc.dart';
import 'package:rizqmart/features/presentation/pages/main/cook_tonight/cook_tonight_page.dart';
import 'package:rizqmart/features/presentation/routes/app_routes.dart';
import 'package:rizqmart/features/presentation/pages/main/chat/chat_page.dart';

import 'package:rizqmart/features/domain/entities/main/address_entities.dart';
import 'package:rizqmart/features/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/domain/entities/main/saved_card_entity.dart';
import 'package:rizqmart/features/presentation/bloc/main/profile/user_profile_bloc.dart';
import 'package:rizqmart/features/presentation/pages/main/address/address_display_page.dart';
import 'package:rizqmart/features/presentation/pages/main/address/add_edit_address_page.dart';
import 'package:rizqmart/features/presentation/pages/auth/forgot_password.dart';
import 'package:rizqmart/features/presentation/pages/auth/login_page.dart';
import 'package:rizqmart/features/presentation/pages/auth/sign_up_page.dart';
import 'package:rizqmart/features/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/presentation/pages/main/cart/cart_page.dart';
import 'package:rizqmart/features/presentation/pages/main/dashboard/dashboard_page.dart';
import 'package:rizqmart/features/presentation/pages/main/dashboard/see_all_page.dart';
import 'package:rizqmart/features/presentation/pages/main/navbar/navigation_bar.dart';
import 'package:rizqmart/features/presentation/pages/main/explore/explore_page.dart';
import 'package:rizqmart/features/presentation/pages/main/explore/product_by_category_page.dart';
import 'package:rizqmart/features/presentation/pages/main/order/orders_page.dart';
import 'package:rizqmart/features/presentation/pages/main/order/order_details_page.dart';
import 'package:rizqmart/features/presentation/pages/main/order/success_page.dart';
import 'package:rizqmart/features/presentation/pages/main/payment/payment_processing_page.dart';
import 'package:rizqmart/features/presentation/pages/main/profile/help&about&setting/about_us_page.dart';
import 'package:rizqmart/features/presentation/pages/main/profile/help&about&setting/help_page.dart';
import 'package:rizqmart/features/presentation/pages/main/profile/help&about&setting/settings_page.dart';
import 'package:rizqmart/features/presentation/pages/main/profile/payment/saved_cards_page.dart';
import 'package:rizqmart/features/presentation/pages/main/profile/profile_page.dart';
import 'package:rizqmart/features/presentation/pages/main/profile/show_details_page.dart';
import 'package:rizqmart/features/presentation/pages/main/profile/edit_user_details_page.dart';
import 'package:rizqmart/features/presentation/pages/main/wishlist/wish_list_page.dart';
import 'package:rizqmart/features/presentation/pages/onboarding/splash_screen.dart';
import 'package:rizqmart/features/presentation/pages/onboarding/welcome1.dart';
import 'package:rizqmart/features/presentation/pages/main/product_details/view_details_page.dart';
import 'package:rizqmart/features/presentation/widgets/common/not_found_page.dart';
import 'package:rizqmart/features/presentation/pages/main/dashboard/notifications_page.dart';

/// Utility class responsible for generating and routing material pages based on named routes.
class RouteGenerator {
  static Route<dynamic> onGenerate(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeFlow());

      case AppRoutes.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpPage());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.forgot:
        return MaterialPageRoute(builder: (_) => const ForgotPassword());

      case AppRoutes.navigationBar:
        return MaterialPageRoute(builder: (_) => const NavigationBarPage());

      case AppRoutes.dashBoard:
        return MaterialPageRoute(builder: (_) => const DashboardPage());

      case AppRoutes.allProduct:
        if (args is List<ProductEntities>) {
          return MaterialPageRoute(
            builder: (_) => AllProductsPage(products: args),
          );
        }
        return _error();

      case AppRoutes.productDetails:
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => ProductDetailsPage(
              product: args['product'],
              variantIndex: args['variantIndex'],
            ),
          );
        }
        return _error();

      case AppRoutes.productByCategory:
        final categoryName = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ProductByCategoryPage(categoryName: categoryName),
        );

      case AppRoutes.explore:
        return MaterialPageRoute(builder: (_) => const ExplorePage());

      case AppRoutes.wishList:
        return MaterialPageRoute(builder: (_) => FavoritePage());

      case AppRoutes.cart:
        return MaterialPageRoute(builder: (_) => CartPage());

      case AppRoutes.orderSuccess:
        if (args is List<CartEntities>) {
          return MaterialPageRoute(
            builder: (_) => SuccessPage(items: args),
          );
        }
        return MaterialPageRoute(builder: (_) => SuccessPage());

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => ProfilePage());
        case AppRoutes.savedCards:
        return MaterialPageRoute(builder: (_) => const SavedCardsPage());
      case AppRoutes.settings:
  return MaterialPageRoute(builder: (_) => const SettingsPage());

case AppRoutes.help:
  return MaterialPageRoute(builder: (_) => const HelpPage());

case AppRoutes.aboutUs:
  return MaterialPageRoute(builder: (_) => const AboutUsPage());


      case AppRoutes.profileDetails:
        final bloc = settings.arguments as UserProfileBloc;
        return MaterialPageRoute(
          builder: (_) => ShowDetailsPage(profileBloc: bloc),
        );

      case AppRoutes.editProfileDetails:
        final bloc = settings.arguments as UserProfileBloc;
        return MaterialPageRoute(
          builder: (_) => EditUserDetailsPage(profileBloc: bloc),
        );

      case AppRoutes.userAddress:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) =>
                AddressDisplayPage(userId: args, isSelecting: false),
          );
        }
        return _error();

      case AppRoutes.selectAddress:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => AddressDisplayPage(userId: args, isSelecting: true),
          );
        }
        return _error();
      case AppRoutes.addAddress:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => AddEditAddressPage(userId: args),
          );
        }
        return _error();

      case AppRoutes.editAddress:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => AddEditAddressPage(
              userId: args['userId'] as String,
              address: args['address'] as AddressEntities?,
            ),
          );
        }
        return _error();

      case AppRoutes.paymentProcessing:
  if (args is Map<String, dynamic>) {
    final order = args['order'] as OrderEntities;
    final paymentMethod = args['paymentMethod'] as String;
    final savedCard = args['savedCard'] as SavedCardEntity?;
    return MaterialPageRoute(
      builder: (_) => PaymentProcessingPage(
        order: order,
        paymentMethod: paymentMethod,
        savedCard: savedCard,
      ),
    );
  }
  return _error();

      case AppRoutes.orders:
        return MaterialPageRoute(builder: (_) => const OrdersPage());

      case AppRoutes.chat:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => ChatPage(
              orderId: args['orderId'],
              orderDisplayId: args['orderDisplayId'],
              deliveryPartnerName: args['deliveryPartnerName'],
              productId: args['productId'],
              productName: args['productName'],
              productImage: args['productImage'],
              sellerId: args['sellerId'],
              orderStatus: args['orderStatus'] ?? 'active',
            ),
          );
        }
        return _error();



      case AppRoutes.orderDetails:
        if (args is OrderEntities) {
          return MaterialPageRoute(
            builder: (_) => OrderDetailsPage(order: args),
          );
        }
        return _error();

      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsPage());

      case AppRoutes.cookTonight:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<CookTonightBloc>(),
            child: const CookTonightPage(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const NavigationBarPage(),
        );
    }
  }

  static Route<dynamic> _error() {
    return MaterialPageRoute(
      builder: (_) => const NotFoundPage(),
    );
  }
}
