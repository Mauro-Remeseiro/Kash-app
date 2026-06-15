import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._internal();

  static final DatabaseHelper instance = DatabaseHelper._internal();

  static const String _dbName = 'kash.db';
  static const int _dbVersion = 4;

  static const String tableCuentas = 'cuentas';
  static const String tableEmpleados = 'empleados';
  static const String tableMovimientos = 'movimientos';
  static const String tableAjustes = 'ajustes';
  static const String tableCategorias = 'categorias';
  static const String tableConceptosEmpleado = 'conceptos_empleado';

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
    await _createTablesV3(db);
    await _createConceptosEmpleadoTable(db);
    await _seedAjustes(db);
    await _seedCuentasPersonal(db);
    await _seedCategoriasBase(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _migrateV1ToV2(db);
    }
    if (oldVersion < 3) {
      await _migrateV2ToV3(db);
    }
    if (oldVersion < 4) {
      await _migrateV3ToV4(db);
    }
  }

  Future<void> _createTablesV3(Database db) async {
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
      CREATE TABLE $tableCategorias (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre     TEXT NOT NULL,
        emoji      TEXT NOT NULL,
        tipo       TEXT NOT NULL DEFAULT 'ambos',
        modo       TEXT NOT NULL DEFAULT 'personal',
        es_custom  INTEGER NOT NULL DEFAULT 0,
        orden      INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableMovimientos (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo         TEXT NOT NULL,
        importe      REAL NOT NULL,
        nota         TEXT,
        categoria_id INTEGER,
        cuenta_id    INTEGER NOT NULL,
        empleado_id  INTEGER,
        fecha        TEXT NOT NULL,
        modo         TEXT NOT NULL,
        aprobado     INTEGER DEFAULT 1,
        FOREIGN KEY (categoria_id) REFERENCES $tableCategorias (id) ON DELETE SET NULL,
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

  Future<void> _createConceptosEmpleadoTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableConceptosEmpleado (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        empleado_id  INTEGER NOT NULL,
        tipo         TEXT,
        descripcion  TEXT,
        importe      REAL NOT NULL,
        fecha        TEXT NOT NULL,
        aprobado     INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (empleado_id) REFERENCES $tableEmpleados (id) ON DELETE CASCADE
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

  Future<void> _migrateV2ToV3(Database db) async {
    // Disable FK constraints during migration
    await db.execute('PRAGMA foreign_keys = OFF');

    // Create categorias table and seed default categories
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableCategorias (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre     TEXT NOT NULL,
        emoji      TEXT NOT NULL,
        tipo       TEXT NOT NULL DEFAULT 'ambos',
        modo       TEXT NOT NULL DEFAULT 'personal',
        es_custom  INTEGER NOT NULL DEFAULT 0,
        orden      INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await _seedCategoriasBase(db);

    // Map legacy string ids (movimientos.categoria) to new integer ids
    final filasCategorias = await db.query(tableCategorias);
    final idsPorNombre = {
      for (final fila in filasCategorias)
        (fila['nombre'] as String).toLowerCase(): fila['id'] as int,
    };
    final idOtro = idsPorNombre['otro'];

    // Rebuild movimientos with categoria_id instead of categoria
    await db.execute('''
      CREATE TABLE movimientos_v3 (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo         TEXT NOT NULL,
        importe      REAL NOT NULL,
        nota         TEXT,
        categoria_id INTEGER,
        cuenta_id    INTEGER NOT NULL,
        empleado_id  INTEGER,
        fecha        TEXT NOT NULL,
        modo         TEXT NOT NULL,
        aprobado     INTEGER DEFAULT 1,
        FOREIGN KEY (categoria_id) REFERENCES $tableCategorias (id) ON DELETE SET NULL,
        FOREIGN KEY (cuenta_id) REFERENCES $tableCuentas (id) ON DELETE CASCADE,
        FOREIGN KEY (empleado_id) REFERENCES $tableEmpleados (id) ON DELETE SET NULL
      )
    ''');

    final movimientos = await db.query('movimientos');
    for (final m in movimientos) {
      final categoriaStr = (m['categoria'] as String?)?.toLowerCase();
      final categoriaId = idsPorNombre[categoriaStr] ?? idOtro;
      await db.insert('movimientos_v3', {
        'id': m['id'],
        'tipo': m['tipo'],
        'importe': m['importe'],
        'nota': m['nota'],
        'categoria_id': categoriaId,
        'cuenta_id': m['cuenta_id'],
        'empleado_id': m['empleado_id'],
        'fecha': m['fecha'],
        'modo': m['modo'],
        'aprobado': m['aprobado'],
      });
    }

    await db.execute('DROP TABLE movimientos');
    await db.execute('ALTER TABLE movimientos_v3 RENAME TO movimientos');

    // Re-enable FK constraints
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _migrateV3ToV4(Database db) async {
    await _createConceptosEmpleadoTable(db);
  }

  Future<void> _seedCategoriasBase(Database db) async {
    const personal = [
      {'nombre': 'Comida', 'emoji': '🍔'},
      {'nombre': 'Transporte', 'emoji': '🚌'},
      {'nombre': 'Ocio', 'emoji': '🎬'},
      {'nombre': 'Casa', 'emoji': '🏠'},
      {'nombre': 'Salud', 'emoji': '💊'},
      {'nombre': 'Otro', 'emoji': '❓'},
    ];
    const empresa = [
      {'nombre': 'Clientes', 'emoji': '💼'},
      {'nombre': 'Oficina', 'emoji': '🏢'},
      {'nombre': 'Empleados', 'emoji': '🤝'},
      {'nombre': 'Suministros', 'emoji': '🔧'},
    ];

    var orden = 0;
    for (final c in personal) {
      await db.insert(tableCategorias, {
        'nombre': c['nombre'],
        'emoji': c['emoji'],
        'tipo': 'ambos',
        'modo': 'personal',
        'es_custom': 0,
        'orden': orden++,
      });
    }
    for (final c in empresa) {
      await db.insert(tableCategorias, {
        'nombre': c['nombre'],
        'emoji': c['emoji'],
        'tipo': 'ambos',
        'modo': 'empresa',
        'es_custom': 0,
        'orden': orden++,
      });
    }
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
    int? categoriaId,
    int? limite,
  }) async {
    final db = await database;
    final where = <String>['modo = ?'];
    final whereArgs = <Object?>[modo];

    if (desde != null) { where.add('fecha >= ?'); whereArgs.add(desde.toIso8601String()); }
    if (hasta != null) { where.add('fecha <= ?'); whereArgs.add(hasta.toIso8601String()); }
    if (cuentaId != null) { where.add('cuenta_id = ?'); whereArgs.add(cuentaId); }
    if (empleadoId != null) { where.add('empleado_id = ?'); whereArgs.add(empleadoId); }
    if (categoriaId != null) { where.add('categoria_id = ?'); whereArgs.add(categoriaId); }

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
      SELECT categoria_id, COALESCE(SUM(importe), 0) AS total
      FROM $tableMovimientos
      WHERE modo = ? AND tipo = ? AND fecha >= ? AND fecha <= ?
      GROUP BY categoria_id
      ORDER BY total DESC
      ''',
      [modo, tipo, desde.toIso8601String(), hasta.toIso8601String()],
    );
  }

  // -------------------------------------------------------------------------
  // Categorías
  // -------------------------------------------------------------------------

  Future<int> insertCategoria(Map<String, Object?> categoria) async {
    final db = await database;
    return db.insert(tableCategorias, categoria);
  }

  Future<List<Map<String, Object?>>> getCategorias(String modo) async {
    final db = await database;
    if (modo == 'empresa') {
      return db.query(
        tableCategorias,
        where: 'modo IN (?, ?)',
        whereArgs: ['personal', 'empresa'],
        orderBy: 'orden ASC, id ASC',
      );
    }
    return db.query(
      tableCategorias,
      where: 'modo = ?',
      whereArgs: ['personal'],
      orderBy: 'orden ASC, id ASC',
    );
  }

  Future<int> updateCategoria(int id, Map<String, Object?> categoria) async {
    final db = await database;
    return db.update(tableCategorias, categoria, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteCategoria(int id) async {
    final db = await database;
    return db.delete(tableCategorias, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> contarMovimientosPorCategoria(int categoriaId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM $tableMovimientos WHERE categoria_id = ?',
      [categoriaId],
    );
    return (result.first['total'] as int?) ?? 0;
  }

  Future<int> reasignarMovimientos(int categoriaIdOrigen, int? categoriaIdDestino) async {
    final db = await database;
    return db.update(
      tableMovimientos,
      {'categoria_id': categoriaIdDestino},
      where: 'categoria_id = ?',
      whereArgs: [categoriaIdOrigen],
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

  // -------------------------------------------------------------------------
  // Conceptos de empleado
  // -------------------------------------------------------------------------

  Future<int> insertConceptoEmpleado(Map<String, Object?> concepto) async {
    final db = await database;
    return db.insert(tableConceptosEmpleado, concepto);
  }

  Future<List<Map<String, Object?>>> getConceptosEmpleado(int empleadoId) async {
    final db = await database;
    return db.query(
      tableConceptosEmpleado,
      where: 'empleado_id = ?',
      whereArgs: [empleadoId],
      orderBy: 'fecha DESC, id DESC',
    );
  }

  Future<int> updateConceptoEmpleado(int id, Map<String, Object?> concepto) async {
    final db = await database;
    return db.update(tableConceptosEmpleado, concepto, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteConceptoEmpleado(int id) async {
    final db = await database;
    return db.delete(tableConceptosEmpleado, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> aprobarTodosConceptosEmpleado(int empleadoId) async {
    final db = await database;
    await db.update(
      tableConceptosEmpleado,
      {'aprobado': 1},
      where: 'empleado_id = ?',
      whereArgs: [empleadoId],
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
