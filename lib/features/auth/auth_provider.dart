import 'package:all_in_one/app/provider/app_provider.dart';
import 'package:all_in_one/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:all_in_one/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:all_in_one/features/auth/domain/repositories/auth_repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(dioClient: ref.watch(dioClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
  );
});
