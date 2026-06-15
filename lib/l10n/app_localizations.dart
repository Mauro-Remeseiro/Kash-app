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

  /// No description provided for @paisYMoneda.
  ///
  /// In es, this message translates to:
  /// **'País y moneda'**
  String get paisYMoneda;

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

  /// No description provided for @estadisticasTitle.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas'**
  String get estadisticasTitle;

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

  /// No description provided for @crear.
  ///
  /// In es, this message translates to:
  /// **'Crear'**
  String get crear;

  /// No description provided for @pinGuardadoCheck.
  ///
  /// In es, this message translates to:
  /// **'✓ PIN guardado'**
  String get pinGuardadoCheck;

  /// No description provided for @bloqueado.
  ///
  /// In es, this message translates to:
  /// **'Bloqueado'**
  String get bloqueado;

  /// No description provided for @filtroSemana.
  ///
  /// In es, this message translates to:
  /// **'Semana'**
  String get filtroSemana;

  /// No description provided for @filtroMes.
  ///
  /// In es, this message translates to:
  /// **'Mes'**
  String get filtroMes;

  /// No description provided for @filtroTodo.
  ///
  /// In es, this message translates to:
  /// **'Todo'**
  String get filtroTodo;

  /// No description provided for @gastadoDeTotal.
  ///
  /// In es, this message translates to:
  /// **'{gastado} de {total}'**
  String gastadoDeTotal(String gastado, String total);

  /// No description provided for @sinPresupuestoDefinido.
  ///
  /// In es, this message translates to:
  /// **'Sin presupuesto definido'**
  String get sinPresupuestoDefinido;

  /// No description provided for @confirmarEliminarMovimiento.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar este movimiento? Esta acción no se puede deshacer.'**
  String get confirmarEliminarMovimiento;

  /// No description provided for @movimientoEliminado.
  ///
  /// In es, this message translates to:
  /// **'Movimiento eliminado'**
  String get movimientoEliminado;

  /// No description provided for @sinMovimientosPeriodo.
  ///
  /// In es, this message translates to:
  /// **'Sin movimientos en este periodo'**
  String get sinMovimientosPeriodo;

  /// No description provided for @sistemaTema.
  ///
  /// In es, this message translates to:
  /// **'Sistema'**
  String get sistemaTema;

  /// No description provided for @claroTema.
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get claroTema;

  /// No description provided for @oscuroTema.
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get oscuroTema;

  /// No description provided for @categoriasLabel.
  ///
  /// In es, this message translates to:
  /// **'CATEGORÍAS'**
  String get categoriasLabel;

  /// No description provided for @misCategorias.
  ///
  /// In es, this message translates to:
  /// **'Mis categorías'**
  String get misCategorias;

  /// No description provided for @kashAiLabel.
  ///
  /// In es, this message translates to:
  /// **'KASH AI'**
  String get kashAiLabel;

  /// No description provided for @huellaOFaceId.
  ///
  /// In es, this message translates to:
  /// **'Huella o Face ID al entrar'**
  String get huellaOFaceId;

  /// No description provided for @claveApiAnthropic.
  ///
  /// In es, this message translates to:
  /// **'Clave de API de Anthropic'**
  String get claveApiAnthropic;

  /// No description provided for @kashAiActivo.
  ///
  /// In es, this message translates to:
  /// **'Kash AI está activado. {n} consultas restantes este mes.'**
  String kashAiActivo(int n);

  /// No description provided for @kashAiInactivo.
  ///
  /// In es, this message translates to:
  /// **'Introduce tu clave para activar el asistente Kash AI.'**
  String get kashAiInactivo;

  /// No description provided for @skAntHint.
  ///
  /// In es, this message translates to:
  /// **'sk-ant-...'**
  String get skAntHint;

  /// No description provided for @apiKeyGuardada.
  ///
  /// In es, this message translates to:
  /// **'Clave de API guardada'**
  String get apiKeyGuardada;

  /// No description provided for @apiKeyEliminada.
  ///
  /// In es, this message translates to:
  /// **'Clave de API eliminada'**
  String get apiKeyEliminada;

  /// No description provided for @entendido.
  ///
  /// In es, this message translates to:
  /// **'Entendido'**
  String get entendido;

  /// No description provided for @hintImporte.
  ///
  /// In es, this message translates to:
  /// **'0,00'**
  String get hintImporte;

  /// No description provided for @sinCategoriasAun.
  ///
  /// In es, this message translates to:
  /// **'Todavía no tienes categorías.'**
  String get sinCategoriasAun;

  /// No description provided for @eliminarCategoriaTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar categoría'**
  String get eliminarCategoriaTitle;

  /// No description provided for @eliminarCategoriaConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres eliminar \"{nombre}\"?'**
  String eliminarCategoriaConfirm(String nombre);

  /// No description provided for @categoriaPersonalizada.
  ///
  /// In es, this message translates to:
  /// **'Personalizada'**
  String get categoriaPersonalizada;

  /// No description provided for @sinMovimientosCategoria.
  ///
  /// In es, this message translates to:
  /// **'Sin movimientos'**
  String get sinMovimientosCategoria;

  /// No description provided for @unMovimiento.
  ///
  /// In es, this message translates to:
  /// **'1 movimiento'**
  String get unMovimiento;

  /// No description provided for @nMovimientos.
  ///
  /// In es, this message translates to:
  /// **'{n} movimientos'**
  String nMovimientos(int n);

  /// No description provided for @moverMovimientosTitle.
  ///
  /// In es, this message translates to:
  /// **'Mover movimientos a...'**
  String get moverMovimientosTitle;

  /// No description provided for @reasignarMovimientosMsg.
  ///
  /// In es, this message translates to:
  /// **'\"{nombre}\" tiene movimientos asociados. Elige a qué categoría quieres moverlos antes de eliminarla.'**
  String reasignarMovimientosMsg(String nombre);

  /// No description provided for @totalEsteMes.
  ///
  /// In es, this message translates to:
  /// **'TOTAL ESTE MES'**
  String get totalEsteMes;

  /// No description provided for @eliminarConceptoTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar concepto'**
  String get eliminarConceptoTitle;

  /// No description provided for @eliminarConceptoConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres eliminar este concepto?'**
  String get eliminarConceptoConfirm;

  /// No description provided for @tipoSueldo.
  ///
  /// In es, this message translates to:
  /// **'Sueldo'**
  String get tipoSueldo;

  /// No description provided for @tipoComision.
  ///
  /// In es, this message translates to:
  /// **'Comisión'**
  String get tipoComision;

  /// No description provided for @tipoBonus.
  ///
  /// In es, this message translates to:
  /// **'Bonus'**
  String get tipoBonus;

  /// No description provided for @tipoDieta.
  ///
  /// In es, this message translates to:
  /// **'Dieta'**
  String get tipoDieta;

  /// No description provided for @tipoOtro.
  ///
  /// In es, this message translates to:
  /// **'Otro'**
  String get tipoOtro;

  /// No description provided for @concepto.
  ///
  /// In es, this message translates to:
  /// **'Concepto'**
  String get concepto;

  /// No description provided for @conceptosLabel.
  ///
  /// In es, this message translates to:
  /// **'CONCEPTOS'**
  String get conceptosLabel;

  /// No description provided for @sinConceptosAun.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay conceptos para este empleado.'**
  String get sinConceptosAun;

  /// No description provided for @pendiente.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get pendiente;

  /// No description provided for @aprobarTodos.
  ///
  /// In es, this message translates to:
  /// **'Aprobar todos'**
  String get aprobarTodos;

  /// No description provided for @pendienteDeAprobar.
  ///
  /// In es, this message translates to:
  /// **'PENDIENTE DE APROBAR'**
  String get pendienteDeAprobar;

  /// No description provided for @tuEquipo.
  ///
  /// In es, this message translates to:
  /// **'TU EQUIPO'**
  String get tuEquipo;

  /// No description provided for @sinEmpleadosAun.
  ///
  /// In es, this message translates to:
  /// **'Todavía no has añadido ningún empleado.'**
  String get sinEmpleadosAun;

  /// No description provided for @exportarInforme.
  ///
  /// In es, this message translates to:
  /// **'Exportar informe'**
  String get exportarInforme;

  /// No description provided for @proTag.
  ///
  /// In es, this message translates to:
  /// **'PRO'**
  String get proTag;

  /// No description provided for @exportarInformeProTitle.
  ///
  /// In es, this message translates to:
  /// **'Exportar informe — Kash Pro'**
  String get exportarInformeProTitle;

  /// No description provided for @exportarInformeProMsg.
  ///
  /// In es, this message translates to:
  /// **'Exportar el informe de empleados en PDF es una función de Kash Pro (pago único, 2,99 €). Desbloquéala junto con el histórico de meses anteriores y los presupuestos personalizados.'**
  String get exportarInformeProMsg;

  /// No description provided for @aprobado.
  ///
  /// In es, this message translates to:
  /// **'Aprobado'**
  String get aprobado;

  /// No description provided for @nuevoMovimiento.
  ///
  /// In es, this message translates to:
  /// **'Nuevo movimiento'**
  String get nuevoMovimiento;

  /// No description provided for @categoriaLabel.
  ///
  /// In es, this message translates to:
  /// **'CATEGORÍA'**
  String get categoriaLabel;

  /// No description provided for @cuentaLabel.
  ///
  /// In es, this message translates to:
  /// **'CUENTA'**
  String get cuentaLabel;

  /// No description provided for @crearCuentaPrimero.
  ///
  /// In es, this message translates to:
  /// **'Crea primero una cuenta para poder guardar movimientos.'**
  String get crearCuentaPrimero;

  /// No description provided for @asignarAEmpleado.
  ///
  /// In es, this message translates to:
  /// **'ASIGNAR A EMPLEADO'**
  String get asignarAEmpleado;

  /// No description provided for @sinAsignar.
  ///
  /// In es, this message translates to:
  /// **'Sin asignar'**
  String get sinAsignar;

  /// No description provided for @conceptoHint.
  ///
  /// In es, this message translates to:
  /// **'Concepto (p. ej. Factura proveedor)'**
  String get conceptoHint;

  /// No description provided for @gasto.
  ///
  /// In es, this message translates to:
  /// **'Gasto'**
  String get gasto;

  /// No description provided for @ingreso.
  ///
  /// In es, this message translates to:
  /// **'Ingreso'**
  String get ingreso;

  /// No description provided for @movimientoGuardado.
  ///
  /// In es, this message translates to:
  /// **'Movimiento guardado'**
  String get movimientoGuardado;

  /// No description provided for @clienteLabel.
  ///
  /// In es, this message translates to:
  /// **'Cliente'**
  String get clienteLabel;

  /// No description provided for @gastoFijoLabel.
  ///
  /// In es, this message translates to:
  /// **'Gasto fijo'**
  String get gastoFijoLabel;

  /// No description provided for @empleadoLabel.
  ///
  /// In es, this message translates to:
  /// **'Empleado'**
  String get empleadoLabel;

  /// No description provided for @kashAiTitleSparkle.
  ///
  /// In es, this message translates to:
  /// **'Kash AI ✨'**
  String get kashAiTitleSparkle;

  /// No description provided for @consultasEsteMes.
  ///
  /// In es, this message translates to:
  /// **'{n} consultas este mes'**
  String consultasEsteMes(int n);

  /// No description provided for @limiteMensualAlcanzado.
  ///
  /// In es, this message translates to:
  /// **'Límite mensual alcanzado'**
  String get limiteMensualAlcanzado;

  /// No description provided for @sugerenciaAhorro.
  ///
  /// In es, this message translates to:
  /// **'¿Cuánto puedo ahorrar?'**
  String get sugerenciaAhorro;

  /// No description provided for @sugerenciaGastoMayor.
  ///
  /// In es, this message translates to:
  /// **'¿En qué gasto más?'**
  String get sugerenciaGastoMayor;

  /// No description provided for @sugerenciaQuePasaSi.
  ///
  /// In es, this message translates to:
  /// **'¿Qué pasa si gasto 50€ más?'**
  String get sugerenciaQuePasaSi;

  /// No description provided for @sugerenciaAnalizaMes.
  ///
  /// In es, this message translates to:
  /// **'Analiza mi mes'**
  String get sugerenciaAnalizaMes;

  /// No description provided for @kashAiEmptyState.
  ///
  /// In es, this message translates to:
  /// **'Pregúntame lo que quieras\nsobre tus finanzas'**
  String get kashAiEmptyState;

  /// No description provided for @preguntaKashAiHint.
  ///
  /// In es, this message translates to:
  /// **'Pregunta a Kash AI...'**
  String get preguntaKashAiHint;

  /// No description provided for @kashAiSinApiKey.
  ///
  /// In es, this message translates to:
  /// **'Configura tu clave de API de Anthropic en Ajustes › Kash AI para empezar a chatear.'**
  String get kashAiSinApiKey;

  /// No description provided for @separadorO.
  ///
  /// In es, this message translates to:
  /// **'o'**
  String get separadorO;

  /// No description provided for @kashProTitle.
  ///
  /// In es, this message translates to:
  /// **'Kash Pro'**
  String get kashProTitle;

  /// No description provided for @proximamente.
  ///
  /// In es, this message translates to:
  /// **'Próximamente'**
  String get proximamente;

  /// No description provided for @featureSyncDevices.
  ///
  /// In es, this message translates to:
  /// **'Sincronización entre dispositivos'**
  String get featureSyncDevices;

  /// No description provided for @featureReportsCSV.
  ///
  /// In es, this message translates to:
  /// **'Informes y exportación CSV'**
  String get featureReportsCSV;

  /// No description provided for @featureUnlimitedEmployees.
  ///
  /// In es, this message translates to:
  /// **'Empleados y cajas ilimitadas'**
  String get featureUnlimitedEmployees;

  /// No description provided for @featureCustomThemes.
  ///
  /// In es, this message translates to:
  /// **'Temas personalizados'**
  String get featureCustomThemes;

  /// No description provided for @avisarmeDisponible.
  ///
  /// In es, this message translates to:
  /// **'Avisarme cuando esté disponible'**
  String get avisarmeDisponible;

  /// No description provided for @notaOpcionalHint.
  ///
  /// In es, this message translates to:
  /// **'Añadir una nota (opcional)'**
  String get notaOpcionalHint;

  /// No description provided for @misCuentas.
  ///
  /// In es, this message translates to:
  /// **'Mis cuentas'**
  String get misCuentas;

  /// No description provided for @tusCuentas.
  ///
  /// In es, this message translates to:
  /// **'TUS CUENTAS'**
  String get tusCuentas;

  /// No description provided for @soloCuentasIncluidas.
  ///
  /// In es, this message translates to:
  /// **'Solo cuentas incluidas en total'**
  String get soloCuentasIncluidas;

  /// No description provided for @principal.
  ///
  /// In es, this message translates to:
  /// **'Principal'**
  String get principal;

  /// No description provided for @incluidaEnTotal.
  ///
  /// In es, this message translates to:
  /// **'Incluida en total'**
  String get incluidaEnTotal;

  /// No description provided for @noIncluidaEnTotal.
  ///
  /// In es, this message translates to:
  /// **'No incluida en total'**
  String get noIncluidaEnTotal;

  /// No description provided for @icono.
  ///
  /// In es, this message translates to:
  /// **'ICONO'**
  String get icono;

  /// No description provided for @nombre.
  ///
  /// In es, this message translates to:
  /// **'NOMBRE'**
  String get nombre;

  /// No description provided for @nombreCuentaHint.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la cuenta'**
  String get nombreCuentaHint;

  /// No description provided for @actualizarSaldo.
  ///
  /// In es, this message translates to:
  /// **'ACTUALIZAR SALDO'**
  String get actualizarSaldo;

  /// No description provided for @ok.
  ///
  /// In es, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @incluirEnPatrimonio.
  ///
  /// In es, this message translates to:
  /// **'Incluir en patrimonio total'**
  String get incluirEnPatrimonio;

  /// No description provided for @marcarComoPrincipal.
  ///
  /// In es, this message translates to:
  /// **'Marcar como cuenta principal'**
  String get marcarComoPrincipal;

  /// No description provided for @eliminarCuentaTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar cuenta'**
  String get eliminarCuentaTitle;

  /// No description provided for @eliminarCuentaConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres eliminar \"{nombre}\"? También se eliminarán todos sus movimientos.'**
  String eliminarCuentaConfirm(String nombre);

  /// No description provided for @saldoInicialOpcional.
  ///
  /// In es, this message translates to:
  /// **'SALDO INICIAL (OPCIONAL)'**
  String get saldoInicialOpcional;

  /// No description provided for @cuentaCorrienteEjemplo.
  ///
  /// In es, this message translates to:
  /// **'p. ej. Cuenta corriente'**
  String get cuentaCorrienteEjemplo;

  /// No description provided for @crearCuentaBtn.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get crearCuentaBtn;

  /// No description provided for @cuentaCreada.
  ///
  /// In es, this message translates to:
  /// **'Cuenta creada'**
  String get cuentaCreada;

  /// No description provided for @totalDelMes.
  ///
  /// In es, this message translates to:
  /// **'TOTAL DEL MES'**
  String get totalDelMes;

  /// No description provided for @gastosPorSemana.
  ///
  /// In es, this message translates to:
  /// **'GASTOS POR SEMANA'**
  String get gastosPorSemana;

  /// No description provided for @desgloseCategorias.
  ///
  /// In es, this message translates to:
  /// **'DESGLOSE POR CATEGORÍA'**
  String get desgloseCategorias;

  /// No description provided for @sinGastosEsteMes.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay gastos este mes.'**
  String get sinGastosEsteMes;

  /// No description provided for @valorEsteMes.
  ///
  /// In es, this message translates to:
  /// **'{valor} este mes'**
  String valorEsteMes(String valor);

  /// No description provided for @exportarPdfProTitle.
  ///
  /// In es, this message translates to:
  /// **'Exportar PDF — Kash Pro'**
  String get exportarPdfProTitle;

  /// No description provided for @exportarPdfProMsg.
  ///
  /// In es, this message translates to:
  /// **'Exportar tus estadísticas en PDF es una función de Kash Pro (pago único, 2,99 €). Desbloquéala junto con el histórico de meses anteriores y los presupuestos personalizados.'**
  String get exportarPdfProMsg;

  /// No description provided for @editarCategoria.
  ///
  /// In es, this message translates to:
  /// **'Editar categoría'**
  String get editarCategoria;

  /// No description provided for @nuevaCategoria.
  ///
  /// In es, this message translates to:
  /// **'Nueva categoría'**
  String get nuevaCategoria;

  /// No description provided for @nombreHint.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get nombreHint;

  /// No description provided for @emojiLabel.
  ///
  /// In es, this message translates to:
  /// **'EMOJI'**
  String get emojiLabel;

  /// No description provided for @editarConcepto.
  ///
  /// In es, this message translates to:
  /// **'Editar concepto'**
  String get editarConcepto;

  /// No description provided for @nuevoConcepto.
  ///
  /// In es, this message translates to:
  /// **'Nuevo concepto'**
  String get nuevoConcepto;

  /// No description provided for @tipoLabel.
  ///
  /// In es, this message translates to:
  /// **'TIPO'**
  String get tipoLabel;

  /// No description provided for @sinTipo.
  ///
  /// In es, this message translates to:
  /// **'Sin tipo'**
  String get sinTipo;

  /// No description provided for @descripcionConceptoHint.
  ///
  /// In es, this message translates to:
  /// **'Descripción (ej. comisión venta cliente Acme)'**
  String get descripcionConceptoHint;

  /// No description provided for @guardarConcepto.
  ///
  /// In es, this message translates to:
  /// **'Guardar concepto'**
  String get guardarConcepto;

  /// No description provided for @eliminarElementoConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar este elemento? Esta acción no se puede deshacer.'**
  String get eliminarElementoConfirm;
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
