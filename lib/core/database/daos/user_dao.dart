import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/cached_users.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [CachedUsers])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.db);

  // Get currently cached user.
  Future<CachedUser?> getCurrentUser() {
    return (select(
      cachedUsers,
    )..where((user) => user.cacheId.equals(1))).getSingleOrNull();
  }

  // Insert or update currently cached user.
  Future<void> saveCurrentUser({
    required String firstName,
    required String lastName,
    required String email,
    required String gender,
    required String countryCode,
    required String fullPhoneNumber,
    required int courseId,
    required String role,
    required String createdAt,
    required String updatedAt,
  }) async {
    final companion = CachedUsersCompanion.insert(
      cacheId: Value<int>(1),
      firstName: firstName,
      lastName: lastName,
      email: email,
      gender: gender,
      countryCode: countryCode,
      fullPhoneNumber: fullPhoneNumber,
      courseId: courseId,
      role: role,
      createdAt: createdAt,
      updatedAt: updatedAt,
      cachedAt: Value(DateTime.now()),
    );

    await into(cachedUsers).insertOnConflictUpdate(companion);
  }

  // Delete currently cached user.
  Future<void> clearCurrentUser() async {
    await (delete(cachedUsers)..where((user) => user.cacheId.equals(1))).go();
  }
}
