import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._internal();

  static final DatabaseHelper instance = DatabaseHelper._internal();

  static const String _dbName = 'kash.db';
  static const int _dbVersion = 2;

  static const String tableCuentas = 'cuentas';
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
    final path   = join(dbPath, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async => db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createTablesV2(db);
    await _seedAjustes(db);
    await _seedCuentasPersonal(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _migrateV1ToV2(db);
    }
  }

  Future<void> _createTablesV2(Database db) async {
    await db.execute('''
      CREATE TABLE $tableCuentas (
        id                INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre            TEXT NOT NULL,
        icono             TEXT NOT NULL DEFAULT '💵',
        saldo             REAL NOT NULL DEFAULT 0,
        incluir_en_total  INTEGER NOT NULL DEFAULT 1,
        es_principal      INTEGER NOT NULL DEFAULT 0,
        modo              TEXT NOT NULL DEFAULT 'personal',
        color             TEXT,
        actualizado_en    TEXT NOT NULL,
        creado_en         TEXT NOT NULL
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
        cuenta_id    INTEGER NOT NULL,
        empleado_id  INTEGER,
        fecha        TEXT NOT NULL,
        modo         TEXT NOT NULL,
        aprobado     INTEGER DEFAULT 1,
        FOREIGN KEY (cuenta_id) REFERENCES $tableCuentas (id) ON DELETE CASCADE,
        FOREIGN KEY (empleado_id) REFERENCES $tableEmpleados (id) ON DELETE SET NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableAjustes (
        clave TEXT PRIMARY KEY,
        valor TEXT NOT NULL
      )
    ''');
  }

  Future<void> _migrateV1ToV2(Database db) async {
    // Disable FK constraints during migration
    await db.execute('PRAGMA foreign_keys = OFF');

    // Create cuentas table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableCuentas (
        id                INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre            TEXT NOT NULL,
        icono             TEXT NOT NULL DEFAULT '💵',
        saldo             REAL NOT NULL DEFAULT 0,
        incluir_en_total  INTEGER NOT NULL DEFAULT 1,
        es_principal      INTEGER NOT NULL DEFAULT 0,
        modo              TEXT NOT NULL DEFAULT 'personal',
        color             TEXT,
        actualizado_en    TEXT NOT NULL,
        creado_en         TEXT NOT NULL
      )
    ''');

    // Migrate existing cajas → cuentas preserving ids
    final cajas = await db.query('cajas');
    if (cajas.isEmpty) {
      await _seedCuentasPersonal(db);
    } else {
      var firstId = true;
      for (final caja in cajas) {
        final now = caja['creado_en'] as String? ?? DateTime.now().toIso8601String();
        await db.insert(tableCuentas, {
          'id': caja['id'],
          'nombre': caja['nombre'],
          'icono': caja['icono'] ?? '💵',
          'saldo': caja['saldo'],
          'incluir_en_total': 1,
          'es_principal': firstId ? 1 : 0,
          'modo': caja['modo'],
          'color': caja['color'],
          'actualizado_en': now,
          'creado_en': now,
        });
        firstId = false;
      }
    }

    // Rebuild movimientos with cuenta_id instead of caja_id
    await db.execute('''
      CREATE TABLE movimientos_v2 (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo         TEXT NOT NULL,
        importe      REAL NOT NULL,
        nota         TEXT,
        categoria    TEXT NOT NULL,
        cuenta_id    INTEGER NOT NULL,
        empleado_id  INTEGER,
        fecha        TEXT NOT NULL,
        modo         TEXT NOT NULL,
        aprobado     INTEGER DEFAULT 1
      )
    ''');

    await db.execute('''
      INSERT INTO movimientos_v2 (id, tipo, importe, nota, categoria, cuenta_id, empleado_id, fecha, modo, aprobado)
      SELECT id, tipo, importe, nota, categoria, caja_id, empleado_id, fecha, modo, aprobado FROM movimientos
    ''');

    await db.execute('DROP TABLE movimientos');
    await db.execute('ALTER TABLE movimientos_v2 RENAME TO movimientos');
    await db.execute('DROP TABLE IF EXISTS cajas');

    // Re-enable FK constraints
    await db.execute('PRAGMA foreign_keys = ON');

    // Seed new ajuste keys
    await db.insert(tableAjustes, {'clave': 'onboarding_completado', 'valor': '1'},
        conflictAlgorithm: ConflictAlgorithm.ignore);
    await db.insert(tableAjustes, {'clave': 'kash_ai_habilitada', 'valor': '1'},
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> _seedAjustes(Database db) async {
    const valores = {
      'modo_app': 'personal',
      'tema': 'system',
      'presupuesto_mensual': '0',
      'moneda': 'EUR',
      'onboarding_completado': '0',
      'kash_ai_habilitada': '1',
    };
    for (final entry in valores.entries) {
      await db.insert(
        tableAjustes,
        {'clave': entry.key, 'valor': entry.value},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  Future<void> _seedCuentasPersonal(Database db) async {
    final now = DateTime.now().toIso8601String();
    final cuentas = [
      {'nombre': 'Efectivo', 'icono': '💵', 'saldo': 0.0, 'incluir_en_total': 1, 'es_principal': 1, 'modo': 'personal', 'color': null, 'actualizado_en': now, 'creado_en': now},
      {'nombre': 'Banco', 'icono': '🏦', 'saldo': 0.0, 'incluir_en_total': 1, 'es_principal': 0, 'modo': 'personal', 'color': null, 'actualizado_en': now, 'creado_en': now},
      {'nombre': 'Ahorros', 'icono': '💴', 'saldo': 0.0, 'incluir_en_total': 1, 'es_principal': 0, 'modo': 'personal', 'color': null, 'actualizado_en': now, 'creado_en': now},
    ];
    for (final c in cuentas) {
      await db.insert(tableCuentas, c);
    }
  }

  Future<void> _seedCuentasEmpresa(Database db) async {
    final now = DateTime.now().toIso8601String();
    final cuentas = [
      {'nombre': 'Caja chica', 'icono': '💵', 'saldo': 0.0, 'incluir_en_total': 1, 'es_principal': 1, 'modo': 'empresa', 'color': null, 'actualizado_en': now, 'creado_en': now},
      {'nombre': 'Cuenta operaciones', 'icono': '🏦', 'saldo': 0.0, 'incluir_en_total': 1, 'es_principal': 0, 'modo': 'empresa', 'color': null, 'actualizado_en': now, 'creado_en': now},
      {'nombre': 'Cuenta nóminas', 'icono': '💳', 'saldo': 0.0, 'incluir_en_total': 1, 'es_principal': 0, 'modo': 'empresa', 'color': null, 'actualizado_en': now, 'creado_en': now},
    ];
    for (final c in cuentas) {
      await db.insert(tableCuentas, c);
    }
  }

  // -------------------------------------------------------------------------
  // Cuentas
  // -------------------------------------------------------------------------

  Future<int> insertCuenta(Map<String, Object?> cuenta) async {
    final db = await database;
    return db.insert(tableCuentas, cuenta);
  }

  Future<List<Map<String, Object?>>> getCuentas(String modo) async {
    final db = await database;
    return db.query(tableCuentas, where: 'modo = ?', whereArgs: [modo], orderBy: 'id ASC');
  }

  Future<Map<String, Object?>?> getCuenta(int id) async {
    final db = await database;
    final result = await db.query(tableCuentas, where: 'id = ?', whereArgs: [id], limit: 1);
    return result.isEmpty ? null : result.first;
  }

  Future<int> updateCuenta(int id, Map<String, Object?> cuenta) async {
    final db = await database;
    return db.update(tableCuentas, cuenta, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> ajustarSaldoCuenta(int id, double delta) async {
    final db = await database;
    return db.rawUpdate(
      'UPDATE $tableCuentas SET saldo = saldo + ?, actualizado_en = ? WHERE id = ?',
      [delta, DateTime.now().toIso8601String(), id],
    );
  }

  Future<int> deleteCuenta(int id) async {
    final db = await database;
    return db.delete(tableCuentas, where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> hayCuentasParaModo(String modo) async {
    final db = await database;
    final result = await db.query(tableCuentas,
        where: 'modo = ?', whereArgs: [modo], limit: 1);
    return result.isNotEmpty;
  }

  Future<void> seedCuentasEmpresaIfEmpty(String modo) async {
    final db = await database;
    final hay = await hayCuentasParaModo(modo);
    if (!hay && modo == 'empresa') {
      await _seedCuentasEmpresa(db);
    }
  }

  // -------------------------------------------------------------------------
  // Empleados
  // -------------------------------------------------------------------------

  Future<int> insertEmpleado(Map<String, Object?> empleado) async {
    final db = await database;
    return db.insert(tableEmpleados, empleado);
  }

  Future<List<Map<String, Object?>>> getEmpleados({bool soloActivos = false}) async {
    final db = await database;
    if (soloActivos) {
      return db.query(tableEmpleados, where: 'activo = ?', whereArgs: [1], orderBy: 'nombre ASC');
    }
    return db.query(tableEmpleados, orderBy: 'nombre ASC');
  }

  Future<Map<String, Object?>?> getEmpleado(int id) async {
    final db = await database;
    final result = await db.query(tableEmpleados, where: 'id = ?', whereArgs: [id], limit: 1);
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

  // -------------------------------------------------------------------------
  // Movimientos
  // -------------------------------------------------------------------------

  Future<int> insertMovimiento(Map<String, Object?> movimiento) async {
    final db = await database;
    return db.insert(tableMovimientos, movimiento);
  }

  Future<List<Map<String, Object?>>> getMovimientos({
    required String modo,
    DateTime? desde,
    DateTime? hasta,
    int? cuentaId,
    int? empleadoId,
    String? categoria,
    int? limite,
  }) async {
    final db = await database;
    final where = <String>['modo = ?'];
    final whereArgs = <Object?>[modo];

    if (desde != null) { where.add('fecha >= ?'); whereArgs.add(desde.toIso8601String()); }
    if (hasta != null) { where.add('fecha <= ?'); whereArgs.add(hasta.toIso8601String()); }
    if (cuentaId != null) { where.add('cuenta_id = ?'); whereArgs.add(cuentaId); }
    if (empleadoId != null) { where.add('empleado_id = ?'); whereArgs.add(empleadoId); }
    if (categoria != null) { where.add('categoria = ?'); whereArgs.add(categoria); }

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
    final result = await db.query(tableMovimientos, where: 'id = ?', whereArgs: [id], limit: 1);
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

  // -------------------------------------------------------------------------
  // Ajustes
  // -------------------------------------------------------------------------

  Future<String?> getAjuste(String clave) async {
    final db = await database;
    final result = await db.query(tableAjustes, where: 'clave = ?', whereArgs: [clave], limit: 1);
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
