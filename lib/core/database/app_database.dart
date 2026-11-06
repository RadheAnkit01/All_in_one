import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/user_dao.dart';
import 'tables/app_metadata.dart';
import 'tables/cached_users.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [AppMetadata, CachedUsers], daos: [UserDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'all_in_one_database'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(cachedUsers);
      }
    },
  );
}
