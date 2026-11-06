import 'package:drift/drift.dart';

//single-account cache

class CachedUsers extends Table {
  // Fixed ID because we are caching only the currently logged-in user.
  IntColumn get cacheId => integer()();

  TextColumn get firstName => text()();

  TextColumn get lastName => text()();

  TextColumn get email => text()();

  TextColumn get gender => text()();

  TextColumn get countryCode => text()();

  TextColumn get fullPhoneNumber => text()();

  IntColumn get courseId => integer()();

  TextColumn get role => text()();

  TextColumn get createdAt => text()();

  TextColumn get updatedAt => text()();

  // When this record was last saved locally.
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {cacheId};
}
