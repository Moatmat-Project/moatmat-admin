import 'package:moatmat_admin/Core/services/database/database_service_settings.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class DatabaseService {
  Future<Database> initialize();
}

class DatabaseServiceImplements implements DatabaseService {
  ///
  @override
  Future<Database> initialize() async {
    //
    String databasePath = await getDatabasesPath();
    //
    String path = join(databasePath, "app.db");
    //
    Database database = await openDatabase(
      path,
      version: DatabaseServiceSettings.version,
      onCreate: onCreate,
      onUpgrade: onUpgrade,
    );
    //
    return database;
  }

  ///
  Future<void> onCreate(Database db, int v) async {
    for (var table in DatabaseServiceSettings.tables) {
      await db.execute(table.sql);
    }
    return;
  }

  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    throw UnimplementedError();
  }
}
