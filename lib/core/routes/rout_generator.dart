import 'package:flutter/material.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/profile/user_profile_bloc.dart';
import 'package:rizqmart/features/auth/presentation/pages/auth/forgot_password.dart';
import 'package:rizqmart/features/auth/presentation/pages/auth/login_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/auth/sign_up_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/cart/cart_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/dashboard_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/see_all_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/navigator/navigation_bar.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/explore/explore_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/explore/product_by_category_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/order/success_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/address/address_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/profile_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/show_details_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/wishlist/wish_list_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/onboarding/splash_screen.dart';
import 'package:rizqmart/features/auth/presentation/pages/onboarding/welcome1.dart';
import 'package:rizqmart/features/auth/presentation/pages/product_details_page/view_details_page.dart';
import 'package:rizqmart/features/auth/presentation/widgets/not_found_page.dart';

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
        return MaterialPageRoute(builder: (_) => SuccessPage());

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case AppRoutes.profileDetails:
        final bloc = settings.arguments as UserProfileBloc;
        return MaterialPageRoute(
          builder: (_) => ShowDetailsPage(profileBloc: bloc),
        );

      case AppRoutes.userAddress:
        final String userId=settings.arguments as String;
        return MaterialPageRoute(builder: (_)=>AddressPage(userId: userId));

      //========
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
