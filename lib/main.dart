import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/theme_cubit.dart';
import 'package:rizqmart/core/theme/theme_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/forgot/forgot_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/google/google_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signIn/signin_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signUp/signup_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signout/sign_out_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/counter/counter_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/dashboard/dash_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/explore/explore_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_bloc.dart';
import 'package:rizqmart/features/auth/presentation/pages/onboarding/splash_screen.dart';
import 'package:rizqmart/core/services/registeration/register.dart';
import 'package:rizqmart/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
      create: (context) => SignupBloc(sl()),
    ),
        BlocProvider( create: (context) => SigninBloc(signinUsecase: sl()) ),
        BlocProvider(create: (context)=>ForgotBloc(forgotpassUsecase: sl())),
        BlocProvider(create: (context)=>GooogleAuthBloc(signInWithGoogle: sl())),
        BlocProvider(create: (context)=>SignOutBloc(signoutUsecase: sl())),
                                                               //main parts
        BlocProvider(create: (context)=>DashBloc(usecase: sl())),
        BlocProvider(create: (context)=>CounterCubit()),
        BlocProvider(create: (context)=>ExploreBloc(getProductUsecase: sl(), getProductbycategoryUsecase: sl(), searchProductsUsecase: sl(), getCategoryUsecase: sl())),
        BlocProvider(create: (context)=>WishListBloc(addToWishListUsecase: sl(), deleteFrmWishListUsecase: sl(), getAllWishListUsecase: sl(), wishListToggleUsecase: sl())),
      ],
      child: BlocBuilder<ThemeCubit,ThemeState>(builder: (context,state){
       return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RizqMart',
        theme: ThemeCubit.lightTheme,
            darkTheme: ThemeCubit.darkTheme,
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: const SplashScreen(),
      );
      })
    );
  }
}