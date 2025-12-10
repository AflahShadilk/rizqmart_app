import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rizqmart/features/auth/data/data_source/auth/forgotpass_remote_datasource_impl.dart';
import 'package:rizqmart/features/auth/data/data_source/auth/google_auth_remote_data_source.dart';
import 'package:rizqmart/features/auth/data/data_source/auth/signin_remote_datasource_impl.dart';
import 'package:rizqmart/features/auth/data/data_source/auth/signup_remote_datasource.dart';
import 'package:rizqmart/features/auth/data/data_source/auth/signup_remote_datasource_impl.dart';
import 'package:rizqmart/features/auth/data/data_source/main/address_data_source.dart';
import 'package:rizqmart/features/auth/data/data_source/main/cart_data_source.dart';
import 'package:rizqmart/features/auth/data/data_source/main/dashboard_data_source.dart';
import 'package:rizqmart/features/auth/data/data_source/main/explore_data_source.dart';
import 'package:rizqmart/features/auth/data/data_source/main/order_data_source.dart';
import 'package:rizqmart/features/auth/data/data_source/main/user_profile_data_source.dart';
import 'package:rizqmart/features/auth/data/data_source/main/wish_list_data_source.dart';
import 'package:rizqmart/features/auth/data/repository/auth/google_repository_imple.dart';
import 'package:rizqmart/features/auth/data/repository/auth/signin_repository_impl.dart';
import 'package:rizqmart/features/auth/data/repository/auth/signup_repository_impl.dart';
import 'package:rizqmart/features/auth/data/repository/main/address_repository_imple.dart';
import 'package:rizqmart/features/auth/data/repository/main/cart_repository_impl.dart';
import 'package:rizqmart/features/auth/data/repository/main/dashboard_repository_impl.dart';
import 'package:rizqmart/features/auth/data/repository/main/explore_repository_imple.dart';
import 'package:rizqmart/features/auth/data/repository/main/order_repository_imple.dart';
import 'package:rizqmart/features/auth/data/repository/main/user_profile_repository_imple.dart';
import 'package:rizqmart/features/auth/data/repository/main/wish_list_repository_imple.dart';
import 'package:rizqmart/features/auth/domain/repositories/auth/google_repository.dart';
import 'package:rizqmart/features/auth/domain/repositories/auth/create_account_authrepository.dart';
import 'package:rizqmart/features/auth/domain/repositories/auth/signin_authrepository.dart';
import 'package:rizqmart/features/auth/domain/repositories/auth/forgotpass_authrepo.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/address_repository.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/cart_repository.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/dashboard_repository.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/explore_repository.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/order_repository.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/user_profile_repository.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/wish_list_repository.dart';
import 'package:rizqmart/features/auth/domain/usecase/auth/google_sign_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/auth/signin_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/auth/signout_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/auth/signup_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/auth/forgotpass_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/address/add_address_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/address/delete_address_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/address/get_address_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/address/get_current_location_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/address/set_default_address_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/address/update_address_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/cart/add_to_cart_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/cart/clear_cart_item_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/cart/decreament_cart_item_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/cart/get_cart_items_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/cart/increment_cart_item_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/cart/remove_from_cart_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/cart/update_cartitem_quantity_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/explore/get_category_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/explore/get_productbycategory_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/explore/get_products_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/explore/search_products_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/dashboard/get_product_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/order/cancel_order_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/order/get_user_orders_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/order/place_order_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/userprofile/delete_profile_photo_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/userprofile/update_profile_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/userprofile/upload_profile_photo_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/userprofile/get_user_profile_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/wishlist/add_to_wish_list_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/wishlist/delete_frm_wish_list_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/wishlist/get_all_wish_list_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/wishlist/wish_list_toggle_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/forgot/forgot_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/google/google_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signIn/signin_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/auth/signUp/signup_bloc.dart';

final sl = GetIt.instance;

void setupLocator() {
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());

  sl.registerLazySingleton<SignupRemoteDatasource>(
    () => SignupRemoteDatasourceImpl(
      firebaseAuth: sl(),
      firebaseFirestore: sl(),
    ),
  );
  sl.registerLazySingleton<SigninRemoteDatasourceImpl>(
    () => SigninRemoteDatasourceImpl(firebaseAuth: sl()),
  );
  sl.registerLazySingleton<ForgotpassAuthrepo>(
    () => ForgotpassRemoteDatasourceImpl(firebaseAuth: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      googleSignIn: sl(),
    ),
  );

  // Repository implementations registered as their interfaces
  sl.registerLazySingleton<CreateAccountAuthrepository>(
    () => SignupRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<SigninAuthrepository>(
    () => SigninRepositoryImpl(signinRemoteDatasourceImpl: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );
  //usecaseas
  sl.registerLazySingleton(() => SignoutUsecase(sl(), sl()));
  sl.registerLazySingleton(
    () => SignupUsecase(sl()),
  );
  sl.registerLazySingleton(
    () => SigninUsecase(signinAuthrepository: sl()),
  );
  sl.registerLazySingleton(
    () => ForgotpassUsecase(sl()),
  );
  sl.registerLazySingleton(
    () => SignInWithGoogle(sl()),
  );
  sl.registerLazySingleton(
    () => SignupBloc(sl()),
  );
  sl.registerLazySingleton(
    () => SigninBloc(signinUsecase: sl()),
  );
  sl.registerLazySingleton(
    () => ForgotBloc(forgotpassUsecase: sl()),
  );
  sl.registerLazySingleton(
    () => GooogleAuthBloc(signInWithGoogle: sl()),
  );
  //main part data source------------------------------------------------------------
  sl.registerLazySingleton<DashboardDataSource>(() => DashboardDataSource());
  sl.registerLazySingleton<ExploreDataSources>(() => ExploreDataSources());
  sl.registerLazySingleton<WishListDataSource>(() => WishListDataSource());
  sl.registerLazySingleton<CartDataSource>(()=>CartDataSource());
  sl.registerLazySingleton<OrderDataSource>(()=>OrderDataSource());
  sl.registerLazySingleton<UserProfileDataSource>(()=>UserProfileDataSource(firestore: sl()));
  sl.registerLazySingleton<AddressRemoteDataSource>(()=>AddressRemoteDataSource(firestore: sl()));

  //main part repos-------------------------------------------------------------------
  sl.registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(dataSource: sl()));
  sl.registerLazySingleton<ExploreRepository>(
      () => ExploreRepositoryImple(exploreDataSource: sl()));
  sl.registerLazySingleton<WishListRepository>(
      () => WishListRepositoryImple(dataSource: sl(), auth: sl()));
  sl.registerLazySingleton<CartRepository>(()=>CartRepositoryImpl(dataSource: sl()));
  sl.registerLazySingleton<OrderRepository>(()=>OrderRepositoryImpl(dataSource: sl()));
  sl.registerLazySingleton<UserProfileRepository>(()=>UserProfileRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<AddressRepository>(()=>AddressRepositoryImpl(remoteDataSource: sl()));
  //use -------------------------------------------------------------------------------
  //productUsecases
  sl.registerLazySingleton(() => GetProductUsecase(sl()));
  sl.registerLazySingleton(() => GetProductsUsecase(sl()));
  sl.registerLazySingleton(() => GetCategoryUsecase(sl()));
  sl.registerLazySingleton(() => SearchProductsUsecase(sl()));
  sl.registerLazySingleton(() => GetProductbycategoryUsecase(sl()));

  //WishListUsecases
  sl.registerLazySingleton(() => AddToWishListUsecase(sl()));
  sl.registerLazySingleton(() => DeleteFrmWishListUsecase(sl()));
  sl.registerLazySingleton(() => GetAllWishListUsecase(sl()));
  sl.registerLazySingleton(() => WishListToggleUsecase(sl(), sl(), sl()));

  //cart usecases

  sl.registerLazySingleton(()=>AddToCartUsecase(sl()));
  sl.registerLazySingleton(()=>GetCartItemsUsecase(sl()));
  sl.registerLazySingleton(()=>UpdateCartitemQuantityUsecase(sl()));
  sl.registerLazySingleton(()=>IncrementCartItemUsecase(sl()));
  sl.registerLazySingleton(()=>DecreamentCartItemUsecase(sl()));
  sl.registerLazySingleton(()=>RemoveFromCartUsecase(sl()));
  sl.registerLazySingleton(()=>ClearCartItemUsecase(sl()));

  //Order usecase
  sl.registerLazySingleton(()=>PlaceOrderUsecase(sl()));
  sl.registerLazySingleton(()=>GetUserOrdersUsecase(sl()));
  sl.registerLazySingleton(()=>CancelOrderUsecase(sl()));

  ///User Profile usecase
  sl.registerLazySingleton(()=>GetUserProfileUsecase(sl()));
  sl.registerLazySingleton(()=>UpdateProfileUsecase(sl()));
  sl.registerLazySingleton(()=>UploadProfilePhotoUsecase(sl()));
  sl.registerLazySingleton(()=>DeleteProfilePhotoUsecase(sl()));

  //User address usecase
  sl.registerLazySingleton(()=>GetAddressUsecase(sl()));
  sl.registerLazySingleton(()=>AddAddressUsecase(sl()));
  sl.registerLazySingleton(()=>UpdateAddressUsecase(sl()));
  sl.registerLazySingleton(()=>SetDefaultAddressUsecase(sl()));
  sl.registerLazySingleton(()=>DeleteAddressUsecase(sl()));
  sl.registerLazySingleton(()=>GetCurrentLocationUsecase(sl()));
  
  
}
