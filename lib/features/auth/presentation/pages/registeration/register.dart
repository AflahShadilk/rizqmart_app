import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rizqmart/features/auth/data/data_source/auth/forgotpass_remote_datasource_impl.dart';
import 'package:rizqmart/features/auth/data/data_source/auth/google_auth_remote_data_source.dart';
import 'package:rizqmart/features/auth/data/data_source/auth/signin_remote_datasource_impl.dart';
import 'package:rizqmart/features/auth/data/data_source/auth/signup_remote_datasource.dart';
import 'package:rizqmart/features/auth/data/data_source/auth/signup_remote_datasource_impl.dart';
import 'package:rizqmart/features/auth/data/data_source/main/dashboard_data_source.dart';
import 'package:rizqmart/features/auth/data/repository/auth/google_repository_imple.dart';
import 'package:rizqmart/features/auth/data/repository/auth/signin_repository_impl.dart';
import 'package:rizqmart/features/auth/data/repository/auth/signup_repository_impl.dart';
import 'package:rizqmart/features/auth/data/repository/main/dashboard_repository_impl.dart';
import 'package:rizqmart/features/auth/domain/repositories/auth/google_repository.dart';
import 'package:rizqmart/features/auth/domain/repositories/auth/create_account_authrepository.dart';
import 'package:rizqmart/features/auth/domain/repositories/auth/signin_authrepository.dart';
import 'package:rizqmart/features/auth/domain/repositories/auth/forgotpass_authrepo.dart';
import 'package:rizqmart/features/auth/domain/repositories/main/dashboard_repository.dart';
import 'package:rizqmart/features/auth/domain/usecase/auth/google_sign_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/auth/signin_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/auth/signup_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/auth/forgotpass_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/get_product_usecase.dart';
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
  sl.registerLazySingleton<DashboardDataSource>(()=>DashboardDataSource());


  //main part repos-------------------------------------------------------------------
 sl.registerLazySingleton<DashboardRepository>(()=>DashboardRepositoryImpl(dataSource: sl()));


 //use -------------------------------------------------------------------------------
 sl.registerLazySingleton(()=>GetProductUsecase(sl()));



}
