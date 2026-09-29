import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// TODO:: OPEN NATIVE DATABASE CONNECTION
LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File(
      p.join(
        directory.path,
        'app_database.sqlite',
      ),
    );

    return NativeDatabase(file);
  });
}