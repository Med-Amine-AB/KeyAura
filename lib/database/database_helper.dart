import 'dart:async';
import 'package:keyaura/model/credit_card.dart';
import 'package:keyaura/model/digital_credential.dart';
import 'package:keyaura/model/user_profile.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Table creation queries
  final List<String> _createTableQueries = [
    '''
    CREATE TABLE categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT,
      icon TEXT,
      color TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
    ''',
    '''
    CREATE TABLE providers (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT,
      icon TEXT,
      color TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
    ''',
    '''
    CREATE TABLE digital_credentials (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      password TEXT NOT NULL,
      url TEXT,
      color TEXT,
      icon TEXT,
      description TEXT,
      category_id INTEGER,
      provider_id INTEGER,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (category_id) REFERENCES categories(id),
      FOREIGN KEY (provider_id) REFERENCES providers(id)
    )
    ''',
    '''
    CREATE TABLE physical_credentials (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      password TEXT NOT NULL,
      color TEXT,
      icon TEXT,
      description TEXT,
      category_id INTEGER,
      provider_id INTEGER,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (category_id) REFERENCES categories(id),
      FOREIGN KEY (provider_id) REFERENCES providers(id)
    )
    ''',
    '''
    CREATE TABLE credit_cards (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      card_holder TEXT NOT NULL,
      card_number TEXT NOT NULL,
      expiry_date TEXT NOT NULL,
      cvv TEXT NOT NULL,
      credit_card_password TEXT,
      color TEXT,
      icon TEXT,
      description TEXT,
      category_id INTEGER,
      provider_id INTEGER,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (category_id) REFERENCES categories(id),
      FOREIGN KEY (provider_id) REFERENCES providers(id)
    )
    ''',
    '''
    CREATE TABLE secure_notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      note TEXT NOT NULL,
      category_id INTEGER,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (category_id) REFERENCES categories(id)
    )
    ''',
    '''
    CREATE TABLE user_profile (
      id INTEGER PRIMARY KEY,
      username TEXT NOT NULL,
      master_password_hash TEXT NOT NULL,
      recovery_info TEXT,
      settings TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
    '''
  ];

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'keyaura_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    for (final query in _createTableQueries) {
      await db.execute(query);
    }
    await _createUpdateTriggers(db);
  }

  Future<void> _createUpdateTriggers(Database db) async {
    final tables = [
      'categories',
      'providers',
      'digital_credentials',
      'physical_credentials',
      'credit_cards',
      'secure_notes',
      'user_profile'
    ];

    for (final table in tables) {
      await db.execute('''
        CREATE TRIGGER IF NOT EXISTS update_${table}_timestamp
        AFTER UPDATE ON $table
        BEGIN
          UPDATE $table SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
        END;
      ''');
    }
  }

  // Generic CRUD operations
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> getAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<Map<String, dynamic>?> getById(String table, int id) async {
    final db = await database;
    final results = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> update(String table, int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(String table, int id) async {
    final db = await database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // User Profile Specific Methods
  Future<int> createUpdateUserProfile(UserProfile profile) async {
    final db = await database;
    return await db.insert(
      'user_profile',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserProfile?> getUserProfile() async {
    final db = await database;
    final results = await db.query('user_profile', limit: 1);
    return results.isNotEmpty ? UserProfile.fromMap(results.first) : null;
  }

  // Custom query methods
  Future<List<DigitalCredential>> getDigitalCredentialsByCategory(int categoryId) async {
    final db = await database;
    final results = await db.query(
      'digital_credentials',
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
    return results.map((map) => DigitalCredential.fromMap(map)).toList();
  }

  Future<List<CreditCard>> getAllCreditCards() async {
    final db = await database;
    final results = await db.query('credit_cards');
    return results.map((map) => CreditCard.fromMap(map)).toList();
  }

  // Add more custom methods as needed
}