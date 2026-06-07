// ============================================================
// database_helper.dart – SQLite Helper (v2: + users + userId)
// Migration: v1→v2 adds users table + userId col to workouts
// ============================================================

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'workout_model.dart';
import 'user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // ── DB Getter ────────────────────────────────────────────
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('shadowfit.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final path = join(await getDatabasesPath(), filePath);
    return await openDatabase(
      path,
      version:   2,          // bumped from 1 → 2
      onCreate:  _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // ── onCreate (fresh install) ─────────────────────────────
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id       INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT    NOT NULL,
        email    TEXT    NOT NULL UNIQUE,
        password TEXT    NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE workouts (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        userId       INTEGER NOT NULL DEFAULT 0,
        workoutName  TEXT    NOT NULL,
        targetMuscle TEXT    NOT NULL,
        duration     TEXT    NOT NULL,
        notes        TEXT    NOT NULL
      )
    ''');
  }

  // ── onUpgrade (existing install v1 → v2) ────────────────
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // 1. Create users table (didn't exist in v1)
      await db.execute('''
        CREATE TABLE IF NOT EXISTS users (
          id       INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT    NOT NULL,
          email    TEXT    NOT NULL UNIQUE,
          password TEXT    NOT NULL
        )
      ''');
      // 2. Add userId to existing workouts (DEFAULT 0 = legacy/unassigned)
      //    SQLite requires a DEFAULT when adding NOT NULL column to existing table
      await db.execute(
        'ALTER TABLE workouts ADD COLUMN userId INTEGER NOT NULL DEFAULT 0',
      );
    }
  }

  // ════════════════════════════════════════════════════════
  // USER AUTH
  // ════════════════════════════════════════════════════════

  // ── Register ─────────────────────────────────────────────
  /// Returns the new user's id, or throws on duplicate email.
  Future<int> registerUser(User user) async {
    final db = await instance.database;
    return await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail, // reject duplicate emails
    );
  }

  // ── Login ────────────────────────────────────────────────
  /// Returns the matching User, or null if credentials are wrong.
  Future<User?> loginUser(String email, String password) async {
    final db   = await instance.database;
    final maps = await db.query(
      'users',
      where:     'email = ? AND password = ?',
      whereArgs: [email.trim().toLowerCase(), password],
      limit:     1,
    );
    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  // ── Get by email ─────────────────────────────────────────
  Future<User?> getUserByEmail(String email) async {
    final db   = await instance.database;
    final maps = await db.query(
      'users',
      where:     'email = ?',
      whereArgs: [email.trim().toLowerCase()],
      limit:     1,
    );
    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  // ════════════════════════════════════════════════════════
  // WORKOUT CRUD  (all scoped to userId)
  // ════════════════════════════════════════════════════════

  // ── INSERT ────────────────────────────────────────────────
  Future<int> insertWorkout(Workout workout) async {
    final db = await instance.database;
    return await db.insert(
      'workouts',
      workout.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ── READ (user-scoped) ────────────────────────────────────
  Future<List<Workout>> getWorkoutsByUser(int userId) async {
    final db   = await instance.database;
    final maps = await db.query(
      'workouts',
      where:     'userId = ?',
      whereArgs: [userId],
      orderBy:   'id DESC',
    );
    return maps.map((m) => Workout.fromMap(m)).toList();
  }

  // ── UPDATE ────────────────────────────────────────────────
  /// Safety: WHERE id = ? AND userId = ? prevents cross-user edits.
  Future<int> updateWorkout(Workout workout) async {
    final db = await instance.database;
    return await db.update(
      'workouts',
      workout.toMap(),
      where:     'id = ? AND userId = ?',
      whereArgs: [workout.id, workout.userId],
    );
  }

  // ── DELETE ────────────────────────────────────────────────
  /// Safety: WHERE id = ? AND userId = ? prevents cross-user deletes.
  Future<int> deleteWorkout(int id, int userId) async {
    final db = await instance.database;
    return await db.delete(
      'workouts',
      where:     'id = ? AND userId = ?',
      whereArgs: [id, userId],
    );
  }

  // ── DELETE ALL (user-scoped) ──────────────────────────────
  Future<int> deleteAllWorkoutsByUser(int userId) async {
    final db = await instance.database;
    return await db.delete(
      'workouts',
      where:     'userId = ?',
      whereArgs: [userId],
    );
  }

  Future<void> close() async => (await instance.database).close();
}
