import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/cart_model.dart';

class CartDatabase {
  CartDatabase._();

  static final CartDatabase instance = CartDatabase._();

  static const String _dbName = 'billing_system.db';
  static const String _tableName = 'cart_items';
  static const int _dbVersion = 2;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onOpen: (db) async {
        await _createTables(db);
      },
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tableName (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        restaurant TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        image TEXT NOT NULL
      )
    ''');
  }

  Future<List<CartModel>> getCartItems() async {
    final db = await database;
    final rows = await db.query(_tableName, orderBy: 'name ASC');
    return rows.map(CartModel.fromMap).toList();
  }

  Future<void> replaceCartItems(List<CartModel> items) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete(_tableName);
      for (final item in items) {
        await txn.insert(
          _tableName,
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }
}