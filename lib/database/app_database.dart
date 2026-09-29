import 'package:drift/drift.dart';

import 'database_connection.dart';
import 'tables/products.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Products])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;

  // TODO:: CLEAR ALL TABLES ON LOGOUT
  Future<void> clearDatabase() async {
    await transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }
}