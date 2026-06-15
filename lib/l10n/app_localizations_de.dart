// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Kash';

  @override
  String get bienvenido => 'Willkommen bei Kash';

  @override
  String get elegirIdioma => 'Wähle deine Sprache';

  @override
  String get elegirPais => 'In welchem Land bist du?';

  @override
  String get ajustaMoneda => 'Wir stellen deine Währung automatisch ein';

  @override
  String get continuar => 'Weiter';

  @override
  String get comoUsarasKash => 'Wie wirst du Kash nutzen?';

  @override
  String get modoPersonalDesc =>
      'Verwalte deine täglichen Ausgaben und Einnahmen';

  @override
  String get modoEmpresaDesc =>
      'Verwalte Finanzen, Mitarbeiter und Konten deines Unternehmens';

  @override
  String get empezar => 'Loslegen';

  @override
  String get protegeApp => 'Schütze deine App';

  @override
  String get soloTuPodras => 'Nur du kannst deine Finanzen sehen';

  @override
  String get activarHuella => 'Fingerabdruck / Face ID aktivieren';

  @override
  String get crearPin => 'Erstelle einen Backup-PIN';

  @override
  String get finalizarConfig => 'Einrichtung abschließen';

  @override
  String get ahoraNO => 'Nicht jetzt';

  @override
  String get gastos => 'Ausgaben';

  @override
  String get ingresos => 'Einnahmen';

  @override
  String get balance => 'Saldo';

  @override
  String get gastadoEsteMes => 'DIESEN MONAT AUSGEGEBEN';

  @override
  String get balanceEsteMes => 'MONATSSALDO';

  @override
  String get ultimosMovimientos => 'LETZTE TRANSAKTIONEN';

  @override
  String get nuevaCuenta => 'Neues Konto';

  @override
  String get guardar => 'Speichern';

  @override
  String get cancelar => 'Abbrechen';

  @override
  String get eliminar => 'Löschen';

  @override
  String get editar => 'Bearbeiten';

  @override
  String get ajustes => 'Einstellungen';

  @override
  String get preferencias => 'EINSTELLUNGEN';

  @override
  String get seguridad => 'SICHERHEIT';

  @override
  String get idioma => 'Sprache';

  @override
  String get pais => 'Land';

  @override
  String get moneda => 'Währung';

  @override
  String get paisYMoneda => 'Land und Währung';

  @override
  String get inicio => 'Startseite';

  @override
  String get estadisticas => 'Stats';

  @override
  String get estadisticasTitle => 'Statistiken';

  @override
  String get cuentas => 'Konten';

  @override
  String get categorias => 'Kategorien';

  @override
  String get empleados => 'Mitarbeiter';

  @override
  String get modoPersonal => 'Persönlich';

  @override
  String get modoEmpresa => 'Unternehmen';

  @override
  String get sinMovimientos => 'Noch keine Transaktionen in diesem Zeitraum';

  @override
  String get crearPrimero => 'Erstelle dein erstes Konto, um zu beginnen';

  @override
  String get patrimonio => 'Gesamtvermögen';

  @override
  String get presupuesto => 'MONATSBUDGET';

  @override
  String get exportarPdf => 'PDF exportieren';

  @override
  String get proFeature => 'Pro-Funktion';

  @override
  String get bloqueoApp => 'Biometrische Sperre';

  @override
  String get cambiarPin => 'PIN ändern';

  @override
  String get desbloquear => 'Biometrie verwenden';

  @override
  String get pinIncorrecto => 'Falscher PIN';

  @override
  String intentosRestantes(int n) {
    return '$n Versuche verbleibend';
  }

  @override
  String bloqueadoSegundos(int s) {
    return 'Gesperrt ${s}s';
  }

  @override
  String get tusFinanzas => 'Deine Finanzen, geschützt';

  @override
  String get modoPodrasCambiar =>
      'Du kannst das später in den Einstellungen ändern';

  @override
  String get tuMonedaSera => 'Deine Währung wird';

  @override
  String get buscarPais => 'Land suchen...';

  @override
  String get modoDeUso => 'Modus';

  @override
  String get sinPresupuesto => 'Kein Monatsbudget festgelegt';

  @override
  String get tocarParaEditar => 'Tippen zum Bearbeiten';

  @override
  String get presupuestoMensual => 'Monatsbudget';

  @override
  String get tema => 'DESIGN';

  @override
  String get modoApp => 'APP-MODUS';

  @override
  String get bloqueoCapturas => 'Screenshots blockieren';

  @override
  String get pantallaNegraMultitarea =>
      'Schwarzer Bildschirm in der App-Übersicht';

  @override
  String get desactivarProteccion => 'Schutz deaktivieren';

  @override
  String get desactivarProteccionMsg =>
      'Die App fragt nicht mehr nach PIN oder Biometrie. Fortfahren?';

  @override
  String get desactivar => 'Deaktivieren';

  @override
  String get pinActualizado => 'PIN aktualisiert';

  @override
  String get pinActual => 'Aktueller PIN';

  @override
  String get nuevoPin => 'Neuer PIN';

  @override
  String get confirmarPin => 'PIN bestätigen';

  @override
  String get pinesNoCoinciden => 'PINs stimmen nicht überein';

  @override
  String get crear => 'Erstellen';

  @override
  String get pinGuardadoCheck => '✓ PIN gespeichert';

  @override
  String get bloqueado => 'Gesperrt';

  @override
  String get filtroSemana => 'Woche';

  @override
  String get filtroMes => 'Monat';

  @override
  String get filtroTodo => 'Alle';

  @override
  String gastadoDeTotal(String gastado, String total) {
    return '$gastado von $total';
  }

  @override
  String get sinPresupuestoDefinido => 'Kein Budget festgelegt';

  @override
  String get confirmarEliminarMovimiento =>
      'Diese Buchung löschen? Diese Aktion kann nicht widerrufen werden.';

  @override
  String get movimientoEliminado => 'Buchung gelöscht';

  @override
  String get sinMovimientosPeriodo => 'Keine Buchungen in diesem Zeitraum';

  @override
  String get sistemaTema => 'System';

  @override
  String get claroTema => 'Hell';

  @override
  String get oscuroTema => 'Dunkel';

  @override
  String get categoriasLabel => 'KATEGORIEN';

  @override
  String get misCategorias => 'Meine Kategorien';

  @override
  String get kashAiLabel => 'KASH AI';

  @override
  String get huellaOFaceId => 'Fingerabdruck oder Face ID beim Start';

  @override
  String get claveApiAnthropic => 'Anthropic-API-Schlüssel';

  @override
  String kashAiActivo(int n) {
    return 'Kash AI ist aktiviert. $n Abfragen in diesem Monat übrig.';
  }

  @override
  String get kashAiInactivo =>
      'Gib deinen Schlüssel ein, um den Kash-AI-Assistenten zu aktivieren.';

  @override
  String get skAntHint => 'sk-ant-...';

  @override
  String get apiKeyGuardada => 'API-Schlüssel gespeichert';

  @override
  String get apiKeyEliminada => 'API-Schlüssel gelöscht';

  @override
  String get entendido => 'Verstanden';

  @override
  String get hintImporte => '0,00';

  @override
  String get sinCategoriasAun => 'Du hast noch keine Kategorien.';

  @override
  String get eliminarCategoriaTitle => 'Kategorie löschen';

  @override
  String eliminarCategoriaConfirm(String nombre) {
    return 'Möchtest du \"$nombre\" wirklich löschen?';
  }

  @override
  String get categoriaPersonalizada => 'Benutzerdefiniert';

  @override
  String get sinMovimientosCategoria => 'Keine Buchungen';

  @override
  String get unMovimiento => '1 Buchung';

  @override
  String nMovimientos(int n) {
    return '$n Buchungen';
  }

  @override
  String get moverMovimientosTitle => 'Buchungen verschieben nach...';

  @override
  String reasignarMovimientosMsg(String nombre) {
    return '\"$nombre\" enthält zugehörige Buchungen. Wähle aus, in welche Kategorie sie verschoben werden sollen, bevor du sie löschst.';
  }

  @override
  String get totalEsteMes => 'GESAMT DIESEN MONAT';

  @override
  String get eliminarConceptoTitle => 'Eintrag löschen';

  @override
  String get eliminarConceptoConfirm =>
      'Möchtest du diesen Eintrag wirklich löschen?';

  @override
  String get tipoSueldo => 'Gehalt';

  @override
  String get tipoComision => 'Provision';

  @override
  String get tipoBonus => 'Bonus';

  @override
  String get tipoDieta => 'Spesen';

  @override
  String get tipoOtro => 'Sonstiges';

  @override
  String get concepto => 'Eintrag';

  @override
  String get conceptosLabel => 'EINTRÄGE';

  @override
  String get sinConceptosAun => 'Noch keine Einträge für diesen Mitarbeiter.';

  @override
  String get pendiente => 'Ausstehend';

  @override
  String get aprobarTodos => 'Alle genehmigen';

  @override
  String get pendienteDeAprobar => 'GENEHMIGUNG AUSSTEHEND';

  @override
  String get tuEquipo => 'DEIN TEAM';

  @override
  String get sinEmpleadosAun => 'Du hast noch keine Mitarbeiter hinzugefügt.';

  @override
  String get exportarInforme => 'Bericht exportieren';

  @override
  String get proTag => 'PRO';

  @override
  String get exportarInformeProTitle => 'Bericht exportieren — Kash Pro';

  @override
  String get exportarInformeProMsg =>
      'Der Export des Mitarbeiterberichts als PDF ist eine Kash-Pro-Funktion (einmalige Zahlung, 2,99 €). Schalte sie zusammen mit dem Verlauf vergangener Monate und benutzerdefinierten Budgets frei.';

  @override
  String get aprobado => 'Genehmigt';

  @override
  String get nuevoMovimiento => 'Neue Buchung';

  @override
  String get categoriaLabel => 'KATEGORIE';

  @override
  String get cuentaLabel => 'KONTO';

  @override
  String get crearCuentaPrimero =>
      'Erstelle zuerst ein Konto, um Buchungen speichern zu können.';

  @override
  String get asignarAEmpleado => 'MITARBEITER ZUWEISEN';

  @override
  String get sinAsignar => 'Nicht zugewiesen';

  @override
  String get conceptoHint => 'Bezeichnung (z. B. Lieferantenrechnung)';

  @override
  String get gasto => 'Ausgabe';

  @override
  String get ingreso => 'Einnahme';

  @override
  String get movimientoGuardado => 'Buchung gespeichert';

  @override
  String get clienteLabel => 'Kunde';

  @override
  String get gastoFijoLabel => 'Feste Ausgabe';

  @override
  String get empleadoLabel => 'Mitarbeiter';

  @override
  String get kashAiTitleSparkle => 'Kash AI ✨';

  @override
  String consultasEsteMes(int n) {
    return '$n Abfragen diesen Monat';
  }

  @override
  String get limiteMensualAlcanzado => 'Monatslimit erreicht';

  @override
  String get sugerenciaAhorro => 'Wie viel kann ich sparen?';

  @override
  String get sugerenciaGastoMayor => 'Wofür gebe ich am meisten aus?';

  @override
  String get sugerenciaQuePasaSi => 'Was passiert, wenn ich 50 € mehr ausgebe?';

  @override
  String get sugerenciaAnalizaMes => 'Analysiere meinen Monat';

  @override
  String get kashAiEmptyState => 'Frag mich alles\nüber deine Finanzen';

  @override
  String get preguntaKashAiHint => 'Frag Kash AI...';

  @override
  String get kashAiSinApiKey =>
      'Richte deinen Anthropic-API-Schlüssel unter Einstellungen › Kash AI ein, um zu chatten.';

  @override
  String get separadorO => 'oder';

  @override
  String get kashProTitle => 'Kash Pro';

  @override
  String get proximamente => 'Demnächst';

  @override
  String get featureSyncDevices => 'Synchronisierung zwischen Geräten';

  @override
  String get featureReportsCSV => 'Berichte und CSV-Export';

  @override
  String get featureUnlimitedEmployees => 'Unbegrenzte Mitarbeiter und Kassen';

  @override
  String get featureCustomThemes => 'Benutzerdefinierte Themes';

  @override
  String get avisarmeDisponible => 'Benachrichtige mich, wenn verfügbar';

  @override
  String get notaOpcionalHint => 'Notiz hinzufügen (optional)';

  @override
  String get misCuentas => 'Meine Konten';

  @override
  String get tusCuentas => 'DEINE KONTEN';

  @override
  String get soloCuentasIncluidas => 'Nur im Gesamtbetrag enthaltene Konten';

  @override
  String get principal => 'Hauptkonto';

  @override
  String get incluidaEnTotal => 'Im Gesamtbetrag enthalten';

  @override
  String get noIncluidaEnTotal => 'Nicht im Gesamtbetrag enthalten';

  @override
  String get icono => 'SYMBOL';

  @override
  String get nombre => 'NAME';

  @override
  String get nombreCuentaHint => 'Kontoname';

  @override
  String get actualizarSaldo => 'SALDO AKTUALISIEREN';

  @override
  String get ok => 'OK';

  @override
  String get incluirEnPatrimonio => 'Im Gesamtvermögen einbeziehen';

  @override
  String get marcarComoPrincipal => 'Als Hauptkonto festlegen';

  @override
  String get eliminarCuentaTitle => 'Konto löschen';

  @override
  String eliminarCuentaConfirm(String nombre) {
    return 'Möchtest du \"$nombre\" wirklich löschen? Alle zugehörigen Buchungen werden ebenfalls gelöscht.';
  }

  @override
  String get saldoInicialOpcional => 'ANFANGSSALDO (OPTIONAL)';

  @override
  String get cuentaCorrienteEjemplo => 'z. B. Girokonto';

  @override
  String get crearCuentaBtn => 'Konto erstellen';

  @override
  String get cuentaCreada => 'Konto erstellt';

  @override
  String get totalDelMes => 'GESAMT DES MONATS';

  @override
  String get gastosPorSemana => 'AUSGABEN PRO WOCHE';

  @override
  String get desgloseCategorias => 'AUFSCHLÜSSELUNG NACH KATEGORIE';

  @override
  String get sinGastosEsteMes => 'Noch keine Ausgaben in diesem Monat.';

  @override
  String valorEsteMes(String valor) {
    return '$valor diesen Monat';
  }

  @override
  String get exportarPdfProTitle => 'PDF exportieren — Kash Pro';

  @override
  String get exportarPdfProMsg =>
      'Der Export deiner Statistiken als PDF ist eine Kash-Pro-Funktion (einmalige Zahlung, 2,99 €). Schalte sie zusammen mit dem Verlauf vergangener Monate und benutzerdefinierten Budgets frei.';

  @override
  String get editarCategoria => 'Kategorie bearbeiten';

  @override
  String get nuevaCategoria => 'Neue Kategorie';

  @override
  String get nombreHint => 'Name';

  @override
  String get emojiLabel => 'EMOJI';

  @override
  String get editarConcepto => 'Eintrag bearbeiten';

  @override
  String get nuevoConcepto => 'Neuer Eintrag';

  @override
  String get tipoLabel => 'TYP';

  @override
  String get sinTipo => 'Kein Typ';

  @override
  String get descripcionConceptoHint =>
      'Beschreibung (z. B. Provision Verkauf Kunde Acme)';

  @override
  String get guardarConcepto => 'Eintrag speichern';

  @override
  String get eliminarElementoConfirm =>
      'Dieses Element löschen? Diese Aktion kann nicht widerrufen werden.';
}
