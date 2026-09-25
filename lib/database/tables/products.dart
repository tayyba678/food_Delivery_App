import 'package:drift/drift.dart';

class Products extends Table {
  IntColumn get id => integer()();

  TextColumn get title => text()();

  RealColumn get price => real()();

  TextColumn get description => text()();

  TextColumn get category => text()();

  TextColumn get thumbnail => text()();

  RealColumn get rating => real()();

  @override
  Set<Column> get primaryKey => {id};
}