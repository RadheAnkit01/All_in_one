import 'package:all_in_one/app/provider/app_provider.dart';
import 'package:all_in_one/core/errors/failure.dart';
import 'package:all_in_one/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:all_in_one/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:all_in_one/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:all_in_one/features/auth/domain/repositories/auth_repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(dioClient: ref.watch(dioClientProvider));
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSource(tokenStorage: ref.watch(tokenStorageProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

final loginLoadingProvider = StateProvider<bool>((ref) {
  return false;
});
final loginErrorProvider = StateProvider<Failure?>((ref) {
  return null;
});
