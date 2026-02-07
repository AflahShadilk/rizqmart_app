import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/routes/rout_generator.dart';
import 'package:rizqmart/core/services/registeration/register.dart';
import 'package:rizqmart/core/theme/theme_cubit.dart';
import 'package:rizqmart/core/theme/theme_state.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/cart/add_to_cart_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/cart/clear_cart_item_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/cart/decreament_cart_item_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/cart/get_cart_items_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/cart/increment_cart_item_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/cart/remove_from_cart_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/cart/update_cartitem_quantity_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/forgot/forgot_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/google/google_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signIn/signin_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signUp/signup_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signout/sign_out_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/counter/counter_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/search_bar/search_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/toggle_see_all/toggle_see_all_button.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/dashboard/dash_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/explore/explore_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/order/order_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/payment/payment_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/chat/chat_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/payment/saved_cards/saved_cards_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/notification/notification_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/review/review_bloc.dart';

class BlocProviders extends StatelessWidget {
  const BlocProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Theme
        BlocProvider(
          create: (_) => ThemeCubit(),
        ),

        // Auth BLoCs
        BlocProvider(
          create: (context) => SignupBloc(sl()),
        ),
        BlocProvider(
          create: (context) => SigninBloc(signinUsecase: sl()),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => ForgotBloc(forgotpassUsecase: sl()),
        ),
        BlocProvider(
          create: (context) => GooogleAuthBloc(signInWithGoogle: sl()),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => SignOutBloc(signoutUsecase: sl()),
          lazy: true,
        ),

        // Main Feature BLoCs
        BlocProvider(
          create: (context) => DashBloc(usecase: sl()),
        ),
        BlocProvider(
          create: (context) => CounterCubit(),
          lazy: true,
        ),
        BlocProvider(
          create: (context) => ExploreBloc(
            getProductUsecase: sl(),
            getProductbycategoryUsecase: sl(),
            searchProductsUsecase: sl(),
            getCategoryUsecase: sl(),
          ),
          lazy: true,
        ),
        BlocProvider(
          create: (context) => WishListBloc(
            addToWishListUsecase: sl(),
            deleteFrmWishListUsecase: sl(),
            getAllWishListUsecase: sl(),
            wishListToggleUsecase: sl(),
          ),
          lazy: true,
        ),
        BlocProvider(
          create: (context) => SearchCubit(),
          lazy: true,
        ),
        BlocProvider(
          create: (context) => ToggleSeeAllButtonCubit(),
          lazy: true,
        ),

        // Cart BLoC
        BlocProvider(
          create: (context) => CartBloc(
            getCartItemsUsecase: GetCartItemsUsecase(sl()),
            addToCartUsecase: AddToCartUsecase(sl()),
            removeFromCartUsecase: RemoveFromCartUsecase(sl()),
            updateCartitemQuantityUsecase: UpdateCartitemQuantityUsecase(sl()),
            incrementCartItemUsecase: IncrementCartItemUsecase(sl()),
            decreamentCartItemUsecase: DecreamentCartItemUsecase(sl()),
            clearCartItemUsecase: ClearCartItemUsecase(sl()),
          ),
          lazy: true,
        ),

        //Order BLoC
        BlocProvider(
          create: (context) => OrderBloc(
            placeOrderUsecase: sl(),
            getUserOrdersUsecase: sl(),
            cancelOrderUsecase: sl(),
          ),
          lazy: true,
        ),
        BlocProvider(
          create: (context) => PaymentBloc(
              createOrderUsecase: sl(),
              payWithStripeUseCase: sl(),
              payWithCODUseCase: sl(),
              cancelOrderUseCase: sl(),
              refundOrderUseCase: sl(),
              payWithWalletUseCase: sl(),
          ),
          lazy: true,
        ),
        BlocProvider(
          create: (context) => AddressBloc(
            getAddressUsecase: sl(),
            addAddressUsecase: sl(),
            updateAddressUsecase: sl(),
            deleteAddressUsecase: sl(),
            setDefaultAddressUsecase: sl(),
            getCurrentLocationUsecase: sl(),
          ),
          lazy: true,
        ),
        BlocProvider(
          create: (context) => sl<ChatBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<SavedCardsBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<NotificationBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<ReviewBloc>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'RizqMart',
            theme: ThemeCubit.lightTheme,
            darkTheme: ThemeCubit.darkTheme,
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: RouteGenerator.onGenerate,
          );
        },
      ),
    );
  }
}
