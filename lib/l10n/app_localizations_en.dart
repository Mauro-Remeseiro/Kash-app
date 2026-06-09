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
  String get inicio => 'Home';

  @override
  String get estadisticas => 'Stats';

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
  String get bloqueado => 'Locked';
}
