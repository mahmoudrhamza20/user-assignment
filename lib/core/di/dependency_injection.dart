import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/user_detail/presentation/cubit/user_detail_cubit.dart';
import '../../features/users_list/data/repositories/user_repository.dart';
import '../../features/users_list/presentation/cubit/users_cubit.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../storage/storage_service.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerLazySingleton<StorageService>(() => StorageService(getIt()));

  // Network Info
  getIt.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnection()));

  getIt.registerLazySingleton<DioClient>(() => DioClient(getIt()));

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt(), getIt()),
  );
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(getIt()),
  );

  // Cubits
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt(), getIt()),
  );
  getIt.registerFactory<UsersCubit>(
    () => UsersCubit(getIt()),
  );
  getIt.registerFactory<UserDetailCubit>(
    () => UserDetailCubit(getIt()),
  );
}
