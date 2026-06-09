import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt'),
  ];

  /// No description provided for @appName.
  ///
  /// In es, this message translates to:
  /// **'Kash'**
  String get appName;

  /// No description provided for @bienvenido.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido a Kash'**
  String get bienvenido;

  /// No description provided for @elegirIdioma.
  ///
  /// In es, this message translates to:
  /// **'Elige tu idioma'**
  String get elegirIdioma;

  /// No description provided for @elegirPais.
  ///
  /// In es, this message translates to:
  /// **'¿En qué país estás?'**
  String get elegirPais;

  /// No description provided for @ajustaMoneda.
  ///
  /// In es, this message translates to:
  /// **'Ajustamos la moneda automáticamente'**
  String get ajustaMoneda;

  /// No description provided for @continuar.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get continuar;

  /// No description provided for @comoUsarasKash.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo usarás Kash?'**
  String get comoUsarasKash;

  /// No description provided for @modoPersonalDesc.
  ///
  /// In es, this message translates to:
  /// **'Controla tus gastos e ingresos del día a día'**
  String get modoPersonalDesc;

  /// No description provided for @modoEmpresaDesc.
  ///
  /// In es, this message translates to:
  /// **'Gestiona finanzas, empleados y cuentas de tu negocio'**
  String get modoEmpresaDesc;

  /// No description provided for @empezar.
  ///
  /// In es, this message translates to:
  /// **'Empezar'**
  String get empezar;

  /// No description provided for @protegeApp.
  ///
  /// In es, this message translates to:
  /// **'Protege tu app'**
  String get protegeApp;

  /// No description provided for @soloTuPodras.
  ///
  /// In es, this message translates to:
  /// **'Solo tú podrás ver tus finanzas'**
  String get soloTuPodras;

  /// No description provided for @activarHuella.
  ///
  /// In es, this message translates to:
  /// **'Activar huella / Face ID'**
  String get activarHuella;

  /// No description provided for @crearPin.
  ///
  /// In es, this message translates to:
  /// **'Crea un PIN de respaldo'**
  String get crearPin;

  /// No description provided for @finalizarConfig.
  ///
  /// In es, this message translates to:
  /// **'Finalizar configuración'**
  String get finalizarConfig;

  /// No description provided for @ahoraNO.
  ///
  /// In es, this message translates to:
  /// **'Ahora no'**
  String get ahoraNO;

  /// No description provided for @gastos.
  ///
  /// In es, this message translates to:
  /// **'Gastos'**
  String get gastos;

  /// No description provided for @ingresos.
  ///
  /// In es, this message translates to:
  /// **'Ingresos'**
  String get ingresos;

  /// No description provided for @balance.
  ///
  /// In es, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @gastadoEsteMes.
  ///
  /// In es, this message translates to:
  /// **'GASTADO ESTE MES'**
  String get gastadoEsteMes;

  /// No description provided for @balanceEsteMes.
  ///
  /// In es, this message translates to:
  /// **'BALANCE DEL MES'**
  String get balanceEsteMes;

  /// No description provided for @ultimosMovimientos.
  ///
  /// In es, this message translates to:
  /// **'ÚLTIMOS MOVIMIENTOS'**
  String get ultimosMovimientos;

  /// No description provided for @nuevaCuenta.
  ///
  /// In es, this message translates to:
  /// **'Nueva cuenta'**
  String get nuevaCuenta;

  /// No description provided for @guardar.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get guardar;

  /// No description provided for @cancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancelar;

  /// No description provided for @eliminar.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get eliminar;

  /// No description provided for @editar.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get editar;

  /// No description provided for @ajustes.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get ajustes;

  /// No description provided for @preferencias.
  ///
  /// In es, this message translates to:
  /// **'PREFERENCIAS'**
  String get preferencias;

  /// No description provided for @seguridad.
  ///
  /// In es, this message translates to:
  /// **'SEGURIDAD'**
  String get seguridad;

  /// No description provided for @idioma.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get idioma;

  /// No description provided for @pais.
  ///
  /// In es, this message translates to:
  /// **'País'**
  String get pais;

  /// No description provided for @moneda.
  ///
  /// In es, this message translates to:
  /// **'Moneda'**
  String get moneda;

  /// No description provided for @inicio.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get inicio;

  /// No description provided for @estadisticas.
  ///
  /// In es, this message translates to:
  /// **'Stats'**
  String get estadisticas;

  /// No description provided for @cuentas.
  ///
  /// In es, this message translates to:
  /// **'Cuentas'**
  String get cuentas;

  /// No description provided for @categorias.
  ///
  /// In es, this message translates to:
  /// **'Categorías'**
  String get categorias;

  /// No description provided for @empleados.
  ///
  /// In es, this message translates to:
  /// **'Empleados'**
  String get empleados;

  /// No description provided for @modoPersonal.
  ///
  /// In es, this message translates to:
  /// **'Personal'**
  String get modoPersonal;

  /// No description provided for @modoEmpresa.
  ///
  /// In es, this message translates to:
  /// **'Empresa'**
  String get modoEmpresa;

  /// No description provided for @sinMovimientos.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay movimientos en este periodo'**
  String get sinMovimientos;

  /// No description provided for @crearPrimero.
  ///
  /// In es, this message translates to:
  /// **'Crea tu primera cuenta para empezar'**
  String get crearPrimero;

  /// No description provided for @patrimonio.
  ///
  /// In es, this message translates to:
  /// **'Patrimonio total'**
  String get patrimonio;

  /// No description provided for @presupuesto.
  ///
  /// In es, this message translates to:
  /// **'PRESUPUESTO MENSUAL'**
  String get presupuesto;

  /// No description provided for @exportarPdf.
  ///
  /// In es, this message translates to:
  /// **'Exportar PDF'**
  String get exportarPdf;

  /// No description provided for @proFeature.
  ///
  /// In es, this message translates to:
  /// **'Función Pro'**
  String get proFeature;

  /// No description provided for @bloqueoApp.
  ///
  /// In es, this message translates to:
  /// **'Bloqueo con biometría'**
  String get bloqueoApp;

  /// No description provided for @cambiarPin.
  ///
  /// In es, this message translates to:
  /// **'Cambiar PIN'**
  String get cambiarPin;

  /// No description provided for @desbloquear.
  ///
  /// In es, this message translates to:
  /// **'Usar biometría'**
  String get desbloquear;

  /// No description provided for @pinIncorrecto.
  ///
  /// In es, this message translates to:
  /// **'PIN incorrecto'**
  String get pinIncorrecto;

  /// No description provided for @intentosRestantes.
  ///
  /// In es, this message translates to:
  /// **'{n} intentos restantes'**
  String intentosRestantes(int n);

  /// No description provided for @bloqueadoSegundos.
  ///
  /// In es, this message translates to:
  /// **'Bloqueado {s}s'**
  String bloqueadoSegundos(int s);

  /// No description provided for @tusFinanzas.
  ///
  /// In es, this message translates to:
  /// **'Tus finanzas, protegidas'**
  String get tusFinanzas;

  /// No description provided for @modoPodrasCambiar.
  ///
  /// In es, this message translates to:
  /// **'Puedes cambiarlo después en Ajustes'**
  String get modoPodrasCambiar;

  /// No description provided for @tuMonedaSera.
  ///
  /// In es, this message translates to:
  /// **'Tu moneda será'**
  String get tuMonedaSera;

  /// No description provided for @buscarPais.
  ///
  /// In es, this message translates to:
  /// **'Buscar país...'**
  String get buscarPais;

  /// No description provided for @modoDeUso.
  ///
  /// In es, this message translates to:
  /// **'Modo de uso'**
  String get modoDeUso;

  /// No description provided for @sinPresupuesto.
  ///
  /// In es, this message translates to:
  /// **'Sin presupuesto mensual definido'**
  String get sinPresupuesto;

  /// No description provided for @tocarParaEditar.
  ///
  /// In es, this message translates to:
  /// **'Tocar para editar'**
  String get tocarParaEditar;

  /// No description provided for @presupuestoMensual.
  ///
  /// In es, this message translates to:
  /// **'Presupuesto mensual'**
  String get presupuestoMensual;

  /// No description provided for @tema.
  ///
  /// In es, this message translates to:
  /// **'TEMA'**
  String get tema;

  /// No description provided for @modoApp.
  ///
  /// In es, this message translates to:
  /// **'MODO DE LA APP'**
  String get modoApp;

  /// No description provided for @bloqueoCapturas.
  ///
  /// In es, this message translates to:
  /// **'Bloquear capturas de pantalla'**
  String get bloqueoCapturas;

  /// No description provided for @pantallaNegraMultitarea.
  ///
  /// In es, this message translates to:
  /// **'Pantalla negra en el multitarea'**
  String get pantallaNegraMultitarea;

  /// No description provided for @desactivarProteccion.
  ///
  /// In es, this message translates to:
  /// **'Desactivar protección'**
  String get desactivarProteccion;

  /// No description provided for @desactivarProteccionMsg.
  ///
  /// In es, this message translates to:
  /// **'La app ya no pedirá PIN ni biometría al abrirse. ¿Continuar?'**
  String get desactivarProteccionMsg;

  /// No description provided for @desactivar.
  ///
  /// In es, this message translates to:
  /// **'Desactivar'**
  String get desactivar;

  /// No description provided for @pinActualizado.
  ///
  /// In es, this message translates to:
  /// **'PIN actualizado'**
  String get pinActualizado;

  /// No description provided for @pinActual.
  ///
  /// In es, this message translates to:
  /// **'PIN actual'**
  String get pinActual;

  /// No description provided for @nuevoPin.
  ///
  /// In es, this message translates to:
  /// **'Nuevo PIN'**
  String get nuevoPin;

  /// No description provided for @confirmarPin.
  ///
  /// In es, this message translates to:
  /// **'Confirmar PIN'**
  String get confirmarPin;

  /// No description provided for @pinesNoCoinciden.
  ///
  /// In es, this message translates to:
  /// **'Los PINs no coinciden'**
  String get pinesNoCoinciden;

  /// No description provided for @bloqueado.
  ///
  /// In es, this message translates to:
  /// **'Bloqueado'**
  String get bloqueado;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'pt',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
