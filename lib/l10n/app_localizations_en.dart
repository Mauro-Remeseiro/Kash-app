// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Kash';

  @override
  String get bienvenido => 'Welcome to Kash';

  @override
  String get elegirIdioma => 'Choose your language';

  @override
  String get elegirPais => 'Which country are you in?';

  @override
  String get ajustaMoneda => 'We\'ll set your currency automatically';

  @override
  String get continuar => 'Continue';

  @override
  String get comoUsarasKash => 'How will you use Kash?';

  @override
  String get modoPersonalDesc => 'Track your everyday expenses and income';

  @override
  String get modoEmpresaDesc =>
      'Manage finances, employees and accounts for your business';

  @override
  String get empezar => 'Get started';

  @override
  String get protegeApp => 'Protect your app';

  @override
  String get soloTuPodras => 'Only you can see your finances';

  @override
  String get activarHuella => 'Enable fingerprint / Face ID';

  @override
  String get crearPin => 'Create a backup PIN';

  @override
  String get finalizarConfig => 'Finish setup';

  @override
  String get ahoraNO => 'Not now';

  @override
  String get gastos => 'Expenses';

  @override
  String get ingresos => 'Income';

  @override
  String get balance => 'Balance';

  @override
  String get gastadoEsteMes => 'SPENT THIS MONTH';

  @override
  String get balanceEsteMes => 'MONTHLY BALANCE';

  @override
  String get ultimosMovimientos => 'RECENT TRANSACTIONS';

  @override
  String get nuevaCuenta => 'New account';

  @override
  String get guardar => 'Save';

  @override
  String get cancelar => 'Cancel';

  @override
  String get eliminar => 'Delete';

  @override
  String get editar => 'Edit';

  @override
  String get ajustes => 'Settings';

  @override
  String get preferencias => 'PREFERENCES';

  @override
  String get seguridad => 'SECURITY';

  @override
  String get idioma => 'Language';

  @override
  String get pais => 'Country';

  @override
  String get moneda => 'Currency';

  @override
  String get paisYMoneda => 'Country and currency';

  @override
  String get inicio => 'Home';

  @override
  String get estadisticas => 'Stats';

  @override
  String get estadisticasTitle => 'Statistics';

  @override
  String get cuentas => 'Accounts';

  @override
  String get categorias => 'Categories';

  @override
  String get empleados => 'Employees';

  @override
  String get modoPersonal => 'Personal';

  @override
  String get modoEmpresa => 'Business';

  @override
  String get sinMovimientos => 'No transactions yet in this period';

  @override
  String get crearPrimero => 'Create your first account to get started';

  @override
  String get patrimonio => 'Total net worth';

  @override
  String get presupuesto => 'MONTHLY BUDGET';

  @override
  String get exportarPdf => 'Export PDF';

  @override
  String get proFeature => 'Pro feature';

  @override
  String get bloqueoApp => 'Biometric lock';

  @override
  String get cambiarPin => 'Change PIN';

  @override
  String get desbloquear => 'Use biometrics';

  @override
  String get pinIncorrecto => 'Incorrect PIN';

  @override
  String intentosRestantes(int n) {
    return '$n attempts remaining';
  }

  @override
  String bloqueadoSegundos(int s) {
    return 'Locked ${s}s';
  }

  @override
  String get tusFinanzas => 'Your finances, protected';

  @override
  String get modoPodrasCambiar => 'You can change this later in Settings';

  @override
  String get tuMonedaSera => 'Your currency will be';

  @override
  String get buscarPais => 'Search country...';

  @override
  String get modoDeUso => 'Mode';

  @override
  String get sinPresupuesto => 'No monthly budget defined';

  @override
  String get tocarParaEditar => 'Tap to edit';

  @override
  String get presupuestoMensual => 'Monthly budget';

  @override
  String get tema => 'THEME';

  @override
  String get modoApp => 'APP MODE';

  @override
  String get bloqueoCapturas => 'Block screen capture';

  @override
  String get pantallaNegraMultitarea => 'Black screen in app switcher';

  @override
  String get desactivarProteccion => 'Disable protection';

  @override
  String get desactivarProteccionMsg =>
      'The app will no longer ask for PIN or biometrics when opened. Continue?';

  @override
  String get desactivar => 'Disable';

  @override
  String get pinActualizado => 'PIN updated';

  @override
  String get pinActual => 'Current PIN';

  @override
  String get nuevoPin => 'New PIN';

  @override
  String get confirmarPin => 'Confirm PIN';

  @override
  String get pinesNoCoinciden => 'PINs don\'t match';

  @override
  String get crear => 'Create';

  @override
  String get pinGuardadoCheck => '✓ PIN saved';

  @override
  String get bloqueado => 'Locked';

  @override
  String get filtroSemana => 'Week';

  @override
  String get filtroMes => 'Month';

  @override
  String get filtroTodo => 'All';

  @override
  String gastadoDeTotal(String gastado, String total) {
    return '$gastado of $total';
  }

  @override
  String get sinPresupuestoDefinido => 'No budget set';

  @override
  String get confirmarEliminarMovimiento =>
      'Delete this transaction? This action cannot be undone.';

  @override
  String get movimientoEliminado => 'Transaction deleted';

  @override
  String get sinMovimientosPeriodo => 'No transactions in this period';

  @override
  String get sistemaTema => 'System';

  @override
  String get claroTema => 'Light';

  @override
  String get oscuroTema => 'Dark';

  @override
  String get categoriasLabel => 'CATEGORIES';

  @override
  String get misCategorias => 'My categories';

  @override
  String get kashAiLabel => 'KASH AI';

  @override
  String get huellaOFaceId => 'Fingerprint or Face ID to unlock';

  @override
  String get claveApiAnthropic => 'Anthropic API key';

  @override
  String kashAiActivo(int n) {
    return 'Kash AI is active. $n queries left this month.';
  }

  @override
  String get kashAiInactivo =>
      'Enter your key to activate the Kash AI assistant.';

  @override
  String get skAntHint => 'sk-ant-...';

  @override
  String get apiKeyGuardada => 'API key saved';

  @override
  String get apiKeyEliminada => 'API key deleted';

  @override
  String get entendido => 'Got it';

  @override
  String get hintImporte => '0.00';

  @override
  String get sinCategoriasAun => 'You don\'t have any categories yet.';

  @override
  String get eliminarCategoriaTitle => 'Delete category';

  @override
  String eliminarCategoriaConfirm(String nombre) {
    return 'Are you sure you want to delete \"$nombre\"?';
  }

  @override
  String get categoriaPersonalizada => 'Custom';

  @override
  String get sinMovimientosCategoria => 'No transactions';

  @override
  String get unMovimiento => '1 transaction';

  @override
  String nMovimientos(int n) {
    return '$n transactions';
  }

  @override
  String get moverMovimientosTitle => 'Move transactions to...';

  @override
  String reasignarMovimientosMsg(String nombre) {
    return '\"$nombre\" has transactions associated with it. Choose which category to move them to before deleting it.';
  }

  @override
  String get totalEsteMes => 'TOTAL THIS MONTH';

  @override
  String get eliminarConceptoTitle => 'Delete entry';

  @override
  String get eliminarConceptoConfirm =>
      'Are you sure you want to delete this entry?';

  @override
  String get tipoSueldo => 'Salary';

  @override
  String get tipoComision => 'Commission';

  @override
  String get tipoBonus => 'Bonus';

  @override
  String get tipoDieta => 'Allowance';

  @override
  String get tipoOtro => 'Other';

  @override
  String get concepto => 'Entry';

  @override
  String get conceptosLabel => 'ENTRIES';

  @override
  String get sinConceptosAun => 'No entries for this employee yet.';

  @override
  String get pendiente => 'Pending';

  @override
  String get aprobarTodos => 'Approve all';

  @override
  String get pendienteDeAprobar => 'PENDING APPROVAL';

  @override
  String get tuEquipo => 'YOUR TEAM';

  @override
  String get sinEmpleadosAun => 'You haven\'t added any employees yet.';

  @override
  String get exportarInforme => 'Export report';

  @override
  String get proTag => 'PRO';

  @override
  String get exportarInformeProTitle => 'Export report — Kash Pro';

  @override
  String get exportarInformeProMsg =>
      'Exporting the employee report as a PDF is a Kash Pro feature (one-time payment, €2.99). Unlock it along with the history of previous months and custom budgets.';

  @override
  String get aprobado => 'Approved';

  @override
  String get nuevoMovimiento => 'New transaction';

  @override
  String get categoriaLabel => 'CATEGORY';

  @override
  String get cuentaLabel => 'ACCOUNT';

  @override
  String get crearCuentaPrimero =>
      'Create an account first to be able to save transactions.';

  @override
  String get asignarAEmpleado => 'ASSIGN TO EMPLOYEE';

  @override
  String get sinAsignar => 'Unassigned';

  @override
  String get conceptoHint => 'Description (e.g. Supplier invoice)';

  @override
  String get gasto => 'Expense';

  @override
  String get ingreso => 'Income';

  @override
  String get movimientoGuardado => 'Transaction saved';

  @override
  String get clienteLabel => 'Client';

  @override
  String get gastoFijoLabel => 'Fixed expense';

  @override
  String get empleadoLabel => 'Employee';

  @override
  String get kashAiTitleSparkle => 'Kash AI ✨';

  @override
  String consultasEsteMes(int n) {
    return '$n queries this month';
  }

  @override
  String get limiteMensualAlcanzado => 'Monthly limit reached';

  @override
  String get sugerenciaAhorro => 'How much can I save?';

  @override
  String get sugerenciaGastoMayor => 'What do I spend the most on?';

  @override
  String get sugerenciaQuePasaSi => 'What if I spend €50 more?';

  @override
  String get sugerenciaAnalizaMes => 'Analyze my month';

  @override
  String get kashAiEmptyState => 'Ask me anything\nabout your finances';

  @override
  String get preguntaKashAiHint => 'Ask Kash AI...';

  @override
  String get kashAiSinApiKey =>
      'Set up your Anthropic API key in Settings › Kash AI to start chatting.';

  @override
  String get separadorO => 'or';

  @override
  String get kashProTitle => 'Kash Pro';

  @override
  String get proximamente => 'Coming soon';

  @override
  String get featureSyncDevices => 'Sync across devices';

  @override
  String get featureReportsCSV => 'Reports and CSV export';

  @override
  String get featureUnlimitedEmployees =>
      'Unlimited employees and cash registers';

  @override
  String get featureCustomThemes => 'Custom themes';

  @override
  String get avisarmeDisponible => 'Notify me when available';

  @override
  String get notaOpcionalHint => 'Add a note (optional)';

  @override
  String get misCuentas => 'My accounts';

  @override
  String get tusCuentas => 'YOUR ACCOUNTS';

  @override
  String get soloCuentasIncluidas => 'Only accounts included in the total';

  @override
  String get principal => 'Main';

  @override
  String get incluidaEnTotal => 'Included in total';

  @override
  String get noIncluidaEnTotal => 'Not included in total';

  @override
  String get icono => 'ICON';

  @override
  String get nombre => 'NAME';

  @override
  String get nombreCuentaHint => 'Account name';

  @override
  String get actualizarSaldo => 'UPDATE BALANCE';

  @override
  String get ok => 'OK';

  @override
  String get incluirEnPatrimonio => 'Include in total net worth';

  @override
  String get marcarComoPrincipal => 'Set as main account';

  @override
  String get eliminarCuentaTitle => 'Delete account';

  @override
  String eliminarCuentaConfirm(String nombre) {
    return 'Are you sure you want to delete \"$nombre\"? All its transactions will also be deleted.';
  }

  @override
  String get saldoInicialOpcional => 'INITIAL BALANCE (OPTIONAL)';

  @override
  String get cuentaCorrienteEjemplo => 'e.g. Checking account';

  @override
  String get crearCuentaBtn => 'Create account';

  @override
  String get cuentaCreada => 'Account created';

  @override
  String get totalDelMes => 'TOTAL THIS MONTH';

  @override
  String get gastosPorSemana => 'EXPENSES BY WEEK';

  @override
  String get desgloseCategorias => 'BREAKDOWN BY CATEGORY';

  @override
  String get sinGastosEsteMes => 'No expenses this month yet.';

  @override
  String valorEsteMes(String valor) {
    return '$valor this month';
  }

  @override
  String get exportarPdfProTitle => 'Export PDF — Kash Pro';

  @override
  String get exportarPdfProMsg =>
      'Exporting your statistics as a PDF is a Kash Pro feature (one-time payment, €2.99). Unlock it along with the history of previous months and custom budgets.';

  @override
  String get editarCategoria => 'Edit category';

  @override
  String get nuevaCategoria => 'New category';

  @override
  String get nombreHint => 'Name';

  @override
  String get emojiLabel => 'EMOJI';

  @override
  String get editarConcepto => 'Edit entry';

  @override
  String get nuevoConcepto => 'New entry';

  @override
  String get tipoLabel => 'TYPE';

  @override
  String get sinTipo => 'No type';

  @override
  String get descripcionConceptoHint =>
      'Description (e.g. Acme client sale commission)';

  @override
  String get guardarConcepto => 'Save entry';

  @override
  String get eliminarElementoConfirm =>
      'Delete this item? This action cannot be undone.';
}
