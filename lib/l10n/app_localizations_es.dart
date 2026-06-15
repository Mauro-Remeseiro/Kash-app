// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Kash';

  @override
  String get bienvenido => 'Bienvenido a Kash';

  @override
  String get elegirIdioma => 'Elige tu idioma';

  @override
  String get elegirPais => '¿En qué país estás?';

  @override
  String get ajustaMoneda => 'Ajustamos la moneda automáticamente';

  @override
  String get continuar => 'Continuar';

  @override
  String get comoUsarasKash => '¿Cómo usarás Kash?';

  @override
  String get modoPersonalDesc => 'Controla tus gastos e ingresos del día a día';

  @override
  String get modoEmpresaDesc =>
      'Gestiona finanzas, empleados y cuentas de tu negocio';

  @override
  String get empezar => 'Empezar';

  @override
  String get protegeApp => 'Protege tu app';

  @override
  String get soloTuPodras => 'Solo tú podrás ver tus finanzas';

  @override
  String get activarHuella => 'Activar huella / Face ID';

  @override
  String get crearPin => 'Crea un PIN de respaldo';

  @override
  String get finalizarConfig => 'Finalizar configuración';

  @override
  String get ahoraNO => 'Ahora no';

  @override
  String get gastos => 'Gastos';

  @override
  String get ingresos => 'Ingresos';

  @override
  String get balance => 'Balance';

  @override
  String get gastadoEsteMes => 'GASTADO ESTE MES';

  @override
  String get balanceEsteMes => 'BALANCE DEL MES';

  @override
  String get ultimosMovimientos => 'ÚLTIMOS MOVIMIENTOS';

  @override
  String get nuevaCuenta => 'Nueva cuenta';

  @override
  String get guardar => 'Guardar';

  @override
  String get cancelar => 'Cancelar';

  @override
  String get eliminar => 'Eliminar';

  @override
  String get editar => 'Editar';

  @override
  String get ajustes => 'Ajustes';

  @override
  String get preferencias => 'PREFERENCIAS';

  @override
  String get seguridad => 'SEGURIDAD';

  @override
  String get idioma => 'Idioma';

  @override
  String get pais => 'País';

  @override
  String get moneda => 'Moneda';

  @override
  String get paisYMoneda => 'País y moneda';

  @override
  String get inicio => 'Inicio';

  @override
  String get estadisticas => 'Stats';

  @override
  String get estadisticasTitle => 'Estadísticas';

  @override
  String get cuentas => 'Cuentas';

  @override
  String get categorias => 'Categorías';

  @override
  String get empleados => 'Empleados';

  @override
  String get modoPersonal => 'Personal';

  @override
  String get modoEmpresa => 'Empresa';

  @override
  String get sinMovimientos => 'Todavía no hay movimientos en este periodo';

  @override
  String get crearPrimero => 'Crea tu primera cuenta para empezar';

  @override
  String get patrimonio => 'Patrimonio total';

  @override
  String get presupuesto => 'PRESUPUESTO MENSUAL';

  @override
  String get exportarPdf => 'Exportar PDF';

  @override
  String get proFeature => 'Función Pro';

  @override
  String get bloqueoApp => 'Bloqueo con biometría';

  @override
  String get cambiarPin => 'Cambiar PIN';

  @override
  String get desbloquear => 'Usar biometría';

  @override
  String get pinIncorrecto => 'PIN incorrecto';

  @override
  String intentosRestantes(int n) {
    return '$n intentos restantes';
  }

  @override
  String bloqueadoSegundos(int s) {
    return 'Bloqueado ${s}s';
  }

  @override
  String get tusFinanzas => 'Tus finanzas, protegidas';

  @override
  String get modoPodrasCambiar => 'Puedes cambiarlo después en Ajustes';

  @override
  String get tuMonedaSera => 'Tu moneda será';

  @override
  String get buscarPais => 'Buscar país...';

  @override
  String get modoDeUso => 'Modo de uso';

  @override
  String get sinPresupuesto => 'Sin presupuesto mensual definido';

  @override
  String get tocarParaEditar => 'Tocar para editar';

  @override
  String get presupuestoMensual => 'Presupuesto mensual';

  @override
  String get tema => 'TEMA';

  @override
  String get modoApp => 'MODO DE LA APP';

  @override
  String get bloqueoCapturas => 'Bloquear capturas de pantalla';

  @override
  String get pantallaNegraMultitarea => 'Pantalla negra en el multitarea';

  @override
  String get desactivarProteccion => 'Desactivar protección';

  @override
  String get desactivarProteccionMsg =>
      'La app ya no pedirá PIN ni biometría al abrirse. ¿Continuar?';

  @override
  String get desactivar => 'Desactivar';

  @override
  String get pinActualizado => 'PIN actualizado';

  @override
  String get pinActual => 'PIN actual';

  @override
  String get nuevoPin => 'Nuevo PIN';

  @override
  String get confirmarPin => 'Confirmar PIN';

  @override
  String get pinesNoCoinciden => 'Los PINs no coinciden';

  @override
  String get crear => 'Crear';

  @override
  String get pinGuardadoCheck => '✓ PIN guardado';

  @override
  String get bloqueado => 'Bloqueado';

  @override
  String get filtroSemana => 'Semana';

  @override
  String get filtroMes => 'Mes';

  @override
  String get filtroTodo => 'Todo';

  @override
  String gastadoDeTotal(String gastado, String total) {
    return '$gastado de $total';
  }

  @override
  String get sinPresupuestoDefinido => 'Sin presupuesto definido';

  @override
  String get confirmarEliminarMovimiento =>
      '¿Eliminar este movimiento? Esta acción no se puede deshacer.';

  @override
  String get movimientoEliminado => 'Movimiento eliminado';

  @override
  String get sinMovimientosPeriodo => 'Sin movimientos en este periodo';

  @override
  String get sistemaTema => 'Sistema';

  @override
  String get claroTema => 'Claro';

  @override
  String get oscuroTema => 'Oscuro';

  @override
  String get categoriasLabel => 'CATEGORÍAS';

  @override
  String get misCategorias => 'Mis categorías';

  @override
  String get kashAiLabel => 'KASH AI';

  @override
  String get huellaOFaceId => 'Huella o Face ID al entrar';

  @override
  String get claveApiAnthropic => 'Clave de API de Anthropic';

  @override
  String kashAiActivo(int n) {
    return 'Kash AI está activado. $n consultas restantes este mes.';
  }

  @override
  String get kashAiInactivo =>
      'Introduce tu clave para activar el asistente Kash AI.';

  @override
  String get skAntHint => 'sk-ant-...';

  @override
  String get apiKeyGuardada => 'Clave de API guardada';

  @override
  String get apiKeyEliminada => 'Clave de API eliminada';

  @override
  String get entendido => 'Entendido';

  @override
  String get hintImporte => '0,00';

  @override
  String get sinCategoriasAun => 'Todavía no tienes categorías.';

  @override
  String get eliminarCategoriaTitle => 'Eliminar categoría';

  @override
  String eliminarCategoriaConfirm(String nombre) {
    return '¿Seguro que quieres eliminar \"$nombre\"?';
  }

  @override
  String get categoriaPersonalizada => 'Personalizada';

  @override
  String get sinMovimientosCategoria => 'Sin movimientos';

  @override
  String get unMovimiento => '1 movimiento';

  @override
  String nMovimientos(int n) {
    return '$n movimientos';
  }

  @override
  String get moverMovimientosTitle => 'Mover movimientos a...';

  @override
  String reasignarMovimientosMsg(String nombre) {
    return '\"$nombre\" tiene movimientos asociados. Elige a qué categoría quieres moverlos antes de eliminarla.';
  }

  @override
  String get totalEsteMes => 'TOTAL ESTE MES';

  @override
  String get eliminarConceptoTitle => 'Eliminar concepto';

  @override
  String get eliminarConceptoConfirm =>
      '¿Seguro que quieres eliminar este concepto?';

  @override
  String get tipoSueldo => 'Sueldo';

  @override
  String get tipoComision => 'Comisión';

  @override
  String get tipoBonus => 'Bonus';

  @override
  String get tipoDieta => 'Dieta';

  @override
  String get tipoOtro => 'Otro';

  @override
  String get concepto => 'Concepto';

  @override
  String get conceptosLabel => 'CONCEPTOS';

  @override
  String get sinConceptosAun => 'Todavía no hay conceptos para este empleado.';

  @override
  String get pendiente => 'Pendiente';

  @override
  String get aprobarTodos => 'Aprobar todos';

  @override
  String get pendienteDeAprobar => 'PENDIENTE DE APROBAR';

  @override
  String get tuEquipo => 'TU EQUIPO';

  @override
  String get sinEmpleadosAun => 'Todavía no has añadido ningún empleado.';

  @override
  String get exportarInforme => 'Exportar informe';

  @override
  String get proTag => 'PRO';

  @override
  String get exportarInformeProTitle => 'Exportar informe — Kash Pro';

  @override
  String get exportarInformeProMsg =>
      'Exportar el informe de empleados en PDF es una función de Kash Pro (pago único, 2,99 €). Desbloquéala junto con el histórico de meses anteriores y los presupuestos personalizados.';

  @override
  String get aprobado => 'Aprobado';

  @override
  String get nuevoMovimiento => 'Nuevo movimiento';

  @override
  String get categoriaLabel => 'CATEGORÍA';

  @override
  String get cuentaLabel => 'CUENTA';

  @override
  String get crearCuentaPrimero =>
      'Crea primero una cuenta para poder guardar movimientos.';

  @override
  String get asignarAEmpleado => 'ASIGNAR A EMPLEADO';

  @override
  String get sinAsignar => 'Sin asignar';

  @override
  String get conceptoHint => 'Concepto (p. ej. Factura proveedor)';

  @override
  String get gasto => 'Gasto';

  @override
  String get ingreso => 'Ingreso';

  @override
  String get movimientoGuardado => 'Movimiento guardado';

  @override
  String get clienteLabel => 'Cliente';

  @override
  String get gastoFijoLabel => 'Gasto fijo';

  @override
  String get empleadoLabel => 'Empleado';

  @override
  String get kashAiTitleSparkle => 'Kash AI ✨';

  @override
  String consultasEsteMes(int n) {
    return '$n consultas este mes';
  }

  @override
  String get limiteMensualAlcanzado => 'Límite mensual alcanzado';

  @override
  String get sugerenciaAhorro => '¿Cuánto puedo ahorrar?';

  @override
  String get sugerenciaGastoMayor => '¿En qué gasto más?';

  @override
  String get sugerenciaQuePasaSi => '¿Qué pasa si gasto 50€ más?';

  @override
  String get sugerenciaAnalizaMes => 'Analiza mi mes';

  @override
  String get kashAiEmptyState =>
      'Pregúntame lo que quieras\nsobre tus finanzas';

  @override
  String get preguntaKashAiHint => 'Pregunta a Kash AI...';

  @override
  String get kashAiSinApiKey =>
      'Configura tu clave de API de Anthropic en Ajustes › Kash AI para empezar a chatear.';

  @override
  String get separadorO => 'o';

  @override
  String get kashProTitle => 'Kash Pro';

  @override
  String get proximamente => 'Próximamente';

  @override
  String get featureSyncDevices => 'Sincronización entre dispositivos';

  @override
  String get featureReportsCSV => 'Informes y exportación CSV';

  @override
  String get featureUnlimitedEmployees => 'Empleados y cajas ilimitadas';

  @override
  String get featureCustomThemes => 'Temas personalizados';

  @override
  String get avisarmeDisponible => 'Avisarme cuando esté disponible';

  @override
  String get notaOpcionalHint => 'Añadir una nota (opcional)';

  @override
  String get misCuentas => 'Mis cuentas';

  @override
  String get tusCuentas => 'TUS CUENTAS';

  @override
  String get soloCuentasIncluidas => 'Solo cuentas incluidas en total';

  @override
  String get principal => 'Principal';

  @override
  String get incluidaEnTotal => 'Incluida en total';

  @override
  String get noIncluidaEnTotal => 'No incluida en total';

  @override
  String get icono => 'ICONO';

  @override
  String get nombre => 'NOMBRE';

  @override
  String get nombreCuentaHint => 'Nombre de la cuenta';

  @override
  String get actualizarSaldo => 'ACTUALIZAR SALDO';

  @override
  String get ok => 'OK';

  @override
  String get incluirEnPatrimonio => 'Incluir en patrimonio total';

  @override
  String get marcarComoPrincipal => 'Marcar como cuenta principal';

  @override
  String get eliminarCuentaTitle => 'Eliminar cuenta';

  @override
  String eliminarCuentaConfirm(String nombre) {
    return '¿Seguro que quieres eliminar \"$nombre\"? También se eliminarán todos sus movimientos.';
  }

  @override
  String get saldoInicialOpcional => 'SALDO INICIAL (OPCIONAL)';

  @override
  String get cuentaCorrienteEjemplo => 'p. ej. Cuenta corriente';

  @override
  String get crearCuentaBtn => 'Crear cuenta';

  @override
  String get cuentaCreada => 'Cuenta creada';

  @override
  String get totalDelMes => 'TOTAL DEL MES';

  @override
  String get gastosPorSemana => 'GASTOS POR SEMANA';

  @override
  String get desgloseCategorias => 'DESGLOSE POR CATEGORÍA';

  @override
  String get sinGastosEsteMes => 'Todavía no hay gastos este mes.';

  @override
  String valorEsteMes(String valor) {
    return '$valor este mes';
  }

  @override
  String get exportarPdfProTitle => 'Exportar PDF — Kash Pro';

  @override
  String get exportarPdfProMsg =>
      'Exportar tus estadísticas en PDF es una función de Kash Pro (pago único, 2,99 €). Desbloquéala junto con el histórico de meses anteriores y los presupuestos personalizados.';

  @override
  String get editarCategoria => 'Editar categoría';

  @override
  String get nuevaCategoria => 'Nueva categoría';

  @override
  String get nombreHint => 'Nombre';

  @override
  String get emojiLabel => 'EMOJI';

  @override
  String get editarConcepto => 'Editar concepto';

  @override
  String get nuevoConcepto => 'Nuevo concepto';

  @override
  String get tipoLabel => 'TIPO';

  @override
  String get sinTipo => 'Sin tipo';

  @override
  String get descripcionConceptoHint =>
      'Descripción (ej. comisión venta cliente Acme)';

  @override
  String get guardarConcepto => 'Guardar concepto';

  @override
  String get eliminarElementoConfirm =>
      '¿Eliminar este elemento? Esta acción no se puede deshacer.';
}
