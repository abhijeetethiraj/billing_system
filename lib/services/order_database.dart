import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/order_item_model.dart';
import '../models/order_model.dart';

class OrderDatabase {
  OrderDatabase._();

  static final OrderDatabase instance = OrderDatabase._();

  static const String _dbName = 'billing_system.db';
  static const String _ordersTable = 'orders';
  static const String _orderItemsTable = 'order_items';
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
      onUpgrade: (db, oldVersion, newVersion) async {
        await _createTables(db);
      },
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_ordersTable (
        id TEXT PRIMARY KEY,
        payment_id TEXT NOT NULL,
        amount REAL NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_orderItemsTable (
        id TEXT NOT NULL,
        order_id TEXT NOT NULL,
        name TEXT NOT NULL,
        restaurant TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        image TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertOrder(OrderModel order) async {
    final db = await database;

    await db.transaction((txn) async {
      await txn.insert(
        _ordersTable,
        {
          'id': order.id,
          'payment_id': order.paymentId,
          'amount': order.amount,
          'created_at': order.createdAt.toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      for (final item in order.items) {
        await txn.insert(
          _orderItemsTable,
          {
            ...item.toMap(),
            'order_id': order.id,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<List<OrderModel>> getOrders() async {
    final db = await database;
    final ordersRows = await db.query(_ordersTable, orderBy: 'created_at DESC');
    final orders = <OrderModel>[];

    for (final row in ordersRows) {
      final orderId = row['id'] as String;
      final itemRows = await db.query(
        _orderItemsTable,
        where: 'order_id = ?',
        whereArgs: [orderId],
      );

      orders.add(
        OrderModel(
          id: orderId,
          paymentId: row['payment_id'] as String,
          amount: (row['amount'] as num).toDouble(),
          createdAt: DateTime.parse(row['created_at'] as String),
          items: itemRows.map(OrderItemModel.fromMap).toList(),
        ),
      );
    }

    return orders;
  }
}