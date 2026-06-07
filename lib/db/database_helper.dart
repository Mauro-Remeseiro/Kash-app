import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._internal();

  static final DatabaseHelper instance = DatabaseHelper._internal();

  static const String _dbName = 'kash.db';
  static const int _dbVersion = 1;

  static const String tableCajas = 'cajas';
  static const String tableEmpleados = 'empleados';
  static const String tableMovimientos = 'movimientos';
  static const String tableAjustes = 'ajustes';

  Database? _database;

  Future<Database> get database async {
    final existing = _database;
    if (existing != null) return existing;
    final db = await _open();
    _database = db;
    return db;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableCajas (
        id        INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre    TEXT NOT NULL,
        tipo      TEXT NOT NULL,
        saldo     REAL NOT NULL DEFAULT 0,
        modo      TEXT NOT NULL,
        icono     TEXT,
        color     TEXT,
        creado_en TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableEmpleados (
        id        INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre    TEXT NOT NULL,
        iniciales TEXT NOT NULL,
        activo    INTEGER NOT NULL DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableMovimientos (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo         TEXT NOT NULL,
        importe      REAL NOT NULL,
        nota         TEXT,
        categoria    TEXT NOT NULL,
        caja_id      INTEGER NOT NULL,
        empleado_id  INTEGER,
        fecha        TEXT NOT NULL,
        modo         TEXT NOT NULL,
        aprobado     INTEGER DEFAULT 1,
        FOREIGN KEY (caja_id) REFERENCES $tableCajas (id) ON DELETE CASCADE,
        FOREIGN KEY (empleado_id) REFERENCES $tableEmpleados (id) ON DELETE SET NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableAjustes (
        clave TEXT PRIMARY KEY,
        valor TEXT NOT NULL
      )
    ''');

    await _seedAjustes(db);
  }

  Future<void> _seedAjustes(Database db) async {
    const valoresIniciales = {
      'modo_app': 'personal',
      'tema': 'system',
      'presupuesto_mensual': '0',
      'moneda': 'EUR',
    };
    for (final entry in valoresIniciales.entries) {
      await db.insert(
        tableAjustes,
        {'clave': entry.key, 'valor': entry.value},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  // ---------------------------------------------------------------------
  // Cajas
  // ---------------------------------------------------------------------

  Future<int> insertCaja(Map<String, Object?> caja) async {
    final db = await database;
    return db.insert(tableCajas, caja);
  }

  Future<List<Map<String, Object?>>> getCajas(String modo) async {
    final db = await database;
    return db.query(
      tableCajas,
      where: 'modo = ?',
      whereArgs: [modo],
      orderBy: 'id ASC',
    );
  }

  Future<Map<String, Object?>?> getCaja(int id) async {
    final db = await database;
    final result = await db.query(
      tableCajas,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isEmpty ? null : result.first;
  }

  Future<int> updateCaja(int id, Map<String, Object?> caja) async {
    final db = await database;
    return db.update(tableCajas, caja, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> ajustarSaldoCaja(int id, double delta) async {
    final db = await database;
    return db.rawUpdate(
      'UPDATE $tableCajas SET saldo = saldo + ? WHERE id = ?',
      [delta, id],
    );
  }

  Future<int> deleteCaja(int id) async {
    final db = await database;
    return db.delete(tableCajas, where: 'id = ?', whereArgs: [id]);
  }

  // ---------------------------------------------------------------------
  // Empleados
  // ---------------------------------------------------------------------

  Future<int> insertEmpleado(Map<String, Object?> empleado) async {
    final db = await database;
    return db.insert(tableEmpleados, empleado);
  }

  Future<List<Map<String, Object?>>> getEmpleados({bool soloActivos = false}) async {
    final db = await database;
    if (soloActivos) {
      return db.query(
        tableEmpleados,
        where: 'activo = ?',
        whereArgs: [1],
        orderBy: 'nombre ASC',
      );
    }
    return db.query(tableEmpleados, orderBy: 'nombre ASC');
  }

  Future<Map<String, Object?>?> getEmpleado(int id) async {
    final db = await database;
    final result = await db.query(
      tableEmpleados,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isEmpty ? null : result.first;
  }

  Future<int> updateEmpleado(int id, Map<String, Object?> empleado) async {
    final db = await database;
    return db.update(tableEmpleados, empleado, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteEmpleado(int id) async {
    final db = await database;
    return db.delete(tableEmpleados, where: 'id = ?', whereArgs: [id]);
  }

  // ---------------------------------------------------------------------
  // Movimientos
  // ---------------------------------------------------------------------

  Future<int> insertMovimiento(Map<String, Object?> movimiento) async {
    final db = await database;
    return db.insert(tableMovimientos, movimiento);
  }

  Future<List<Map<String, Object?>>> getMovimientos({
    required String modo,
    DateTime? desde,
    DateTime? hasta,
    int? cajaId,
    int? empleadoId,
    String? categoria,
    int? limite,
  }) async {
    final db = await database;
    final where = <String>['modo = ?'];
    final whereArgs = <Object?>[modo];

    if (desde != null) {
      where.add('fecha >= ?');
      whereArgs.add(desde.toIso8601String());
    }
    if (hasta != null) {
      where.add('fecha <= ?');
      whereArgs.add(hasta.toIso8601String());
    }
    if (cajaId != null) {
      where.add('caja_id = ?');
      whereArgs.add(cajaId);
    }
    if (empleadoId != null) {
      where.add('empleado_id = ?');
      whereArgs.add(empleadoId);
    }
    if (categoria != null) {
      where.add('categoria = ?');
      whereArgs.add(categoria);
    }

    return db.query(
      tableMovimientos,
      where: where.join(' AND '),
      whereArgs: whereArgs,
      orderBy: 'fecha DESC, id DESC',
      limit: limite,
    );
  }

  Future<Map<String, Object?>?> getMovimiento(int id) async {
    final db = await database;
    final result = await db.query(
      tableMovimientos,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isEmpty ? null : result.first;
  }

  Future<int> updateMovimiento(int id, Map<String, Object?> movimiento) async {
    final db = await database;
    return db.update(tableMovimientos, movimiento, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteMovimiento(int id) async {
    final db = await database;
    return db.delete(tableMovimientos, where: 'id = ?', whereArgs: [id]);
  }

  /// Suma de importes para un tipo ('gasto' | 'ingreso') en un rango de fechas.
  Future<double> sumaPorTipo({
    required String modo,
    required String tipo,
    required DateTime desde,
    required DateTime hasta,
  }) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT COALESCE(SUM(importe), 0) AS total
      FROM $tableMovimientos
      WHERE modo = ? AND tipo = ? AND fecha >= ? AND fecha <= ?
      ''',
      [modo, tipo, desde.toIso8601String(), hasta.toIso8601String()],
    );
    final value = result.first['total'];
    return (value as num).toDouble();
  }

  /// Total gastado por categoría en un rango de fechas (para estadísticas).
  Future<List<Map<String, Object?>>> totalesPorCategoria({
    required String modo,
    required String tipo,
    required DateTime desde,
    required DateTime hasta,
  }) async {
    final db = await database;
    return db.rawQuery(
      '''
      SELECT categoria, COALESCE(SUM(importe), 0) AS total
      FROM $tableMovimientos
      WHERE modo = ? AND tipo = ? AND fecha >= ? AND fecha <= ?
      GROUP BY categoria
      ORDER BY total DESC
      ''',
      [modo, tipo, desde.toIso8601String(), hasta.toIso8601String()],
    );
  }

  // ---------------------------------------------------------------------
  // Ajustes
  // ---------------------------------------------------------------------

  Future<String?> getAjuste(String clave) async {
    final db = await database;
    final result = await db.query(
      tableAjustes,
      where: 'clave = ?',
      whereArgs: [clave],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return result.first['valor'] as String?;
  }

  Future<Map<String, String>> getTodosLosAjustes() async {
    final db = await database;
    final result = await db.query(tableAjustes);
    return {
      for (final fila in result) fila['clave'] as String: fila['valor'] as String,
    };
  }

  Future<void> setAjuste(String clave, String valor) async {
    final db = await database;
    await db.insert(
      tableAjustes,
      {'clave': clave, 'valor': valor},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
