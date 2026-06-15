// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'Kash';

  @override
  String get bienvenido => 'Benvenuto su Kash';

  @override
  String get elegirIdioma => 'Scegli la tua lingua';

  @override
  String get elegirPais => 'In quale paese sei?';

  @override
  String get ajustaMoneda => 'Impostiamo la tua valuta automaticamente';

  @override
  String get continuar => 'Continua';

  @override
  String get comoUsarasKash => 'Come userai Kash?';

  @override
  String get modoPersonalDesc =>
      'Tieni traccia delle tue spese e entrate quotidiane';

  @override
  String get modoEmpresaDesc =>
      'Gestisci finanze, dipendenti e conti della tua azienda';

  @override
  String get empezar => 'Inizia';

  @override
  String get protegeApp => 'Proteggi la tua app';

  @override
  String get soloTuPodras => 'Solo tu potrai vedere le tue finanze';

  @override
  String get activarHuella => 'Attiva impronta / Face ID';

  @override
  String get crearPin => 'Crea un PIN di backup';

  @override
  String get finalizarConfig => 'Completa la configurazione';

  @override
  String get ahoraNO => 'Non ora';

  @override
  String get gastos => 'Spese';

  @override
  String get ingresos => 'Entrate';

  @override
  String get balance => 'Saldo';

  @override
  String get gastadoEsteMes => 'SPESO QUESTO MESE';

  @override
  String get balanceEsteMes => 'SALDO DEL MESE';

  @override
  String get ultimosMovimientos => 'ULTIME TRANSAZIONI';

  @override
  String get nuevaCuenta => 'Nuovo conto';

  @override
  String get guardar => 'Salva';

  @override
  String get cancelar => 'Annulla';

  @override
  String get eliminar => 'Elimina';

  @override
  String get editar => 'Modifica';

  @override
  String get ajustes => 'Impostazioni';

  @override
  String get preferencias => 'PREFERENZE';

  @override
  String get seguridad => 'SICUREZZA';

  @override
  String get idioma => 'Lingua';

  @override
  String get pais => 'Paese';

  @override
  String get moneda => 'Valuta';

  @override
  String get paisYMoneda => 'Paese e valuta';

  @override
  String get inicio => 'Home';

  @override
  String get estadisticas => 'Stats';

  @override
  String get estadisticasTitle => 'Statistiche';

  @override
  String get cuentas => 'Conti';

  @override
  String get categorias => 'Categorie';

  @override
  String get empleados => 'Dipendenti';

  @override
  String get modoPersonal => 'Personale';

  @override
  String get modoEmpresa => 'Azienda';

  @override
  String get sinMovimientos => 'Ancora nessuna transazione in questo periodo';

  @override
  String get crearPrimero => 'Crea il tuo primo conto per iniziare';

  @override
  String get patrimonio => 'Patrimonio totale';

  @override
  String get presupuesto => 'BUDGET MENSILE';

  @override
  String get exportarPdf => 'Esporta PDF';

  @override
  String get proFeature => 'Funzione Pro';

  @override
  String get bloqueoApp => 'Blocco biometrico';

  @override
  String get cambiarPin => 'Cambia PIN';

  @override
  String get desbloquear => 'Usa biometria';

  @override
  String get pinIncorrecto => 'PIN errato';

  @override
  String intentosRestantes(int n) {
    return '$n tentativi rimasti';
  }

  @override
  String bloqueadoSegundos(int s) {
    return 'Bloccato ${s}s';
  }

  @override
  String get tusFinanzas => 'Le tue finanze, protette';

  @override
  String get modoPodrasCambiar => 'Puoi cambiarlo dopo nelle Impostazioni';

  @override
  String get tuMonedaSera => 'La tua valuta sarà';

  @override
  String get buscarPais => 'Cerca paese...';

  @override
  String get modoDeUso => 'Modalità';

  @override
  String get sinPresupuesto => 'Nessun budget mensile definito';

  @override
  String get tocarParaEditar => 'Tocca per modificare';

  @override
  String get presupuestoMensual => 'Budget mensile';

  @override
  String get tema => 'TEMA';

  @override
  String get modoApp => 'MODALITÀ APP';

  @override
  String get bloqueoCapturas => 'Blocca screenshot';

  @override
  String get pantallaNegraMultitarea => 'Schermo nero nel cambio app';

  @override
  String get desactivarProteccion => 'Disattiva protezione';

  @override
  String get desactivarProteccionMsg =>
      'L\'app non chiederà più PIN né biometria all\'apertura. Continuare?';

  @override
  String get desactivar => 'Disattiva';

  @override
  String get pinActualizado => 'PIN aggiornato';

  @override
  String get pinActual => 'PIN attuale';

  @override
  String get nuevoPin => 'Nuovo PIN';

  @override
  String get confirmarPin => 'Conferma PIN';

  @override
  String get pinesNoCoinciden => 'I PIN non corrispondono';

  @override
  String get crear => 'Crea';

  @override
  String get pinGuardadoCheck => '✓ PIN salvato';

  @override
  String get bloqueado => 'Bloccato';

  @override
  String get filtroSemana => 'Settimana';

  @override
  String get filtroMes => 'Mese';

  @override
  String get filtroTodo => 'Tutto';

  @override
  String gastadoDeTotal(String gastado, String total) {
    return '$gastado di $total';
  }

  @override
  String get sinPresupuestoDefinido => 'Nessun budget impostato';

  @override
  String get confirmarEliminarMovimiento =>
      'Eliminare questo movimento? Questa azione non può essere annullata.';

  @override
  String get movimientoEliminado => 'Movimento eliminato';

  @override
  String get sinMovimientosPeriodo => 'Nessun movimento in questo periodo';

  @override
  String get sistemaTema => 'Sistema';

  @override
  String get claroTema => 'Chiaro';

  @override
  String get oscuroTema => 'Scuro';

  @override
  String get categoriasLabel => 'CATEGORIE';

  @override
  String get misCategorias => 'Le mie categorie';

  @override
  String get kashAiLabel => 'KASH AI';

  @override
  String get huellaOFaceId => 'Impronta o Face ID all\'accesso';

  @override
  String get claveApiAnthropic => 'Chiave API di Anthropic';

  @override
  String kashAiActivo(int n) {
    return 'Kash AI è attivo. $n richieste rimaste questo mese.';
  }

  @override
  String get kashAiInactivo =>
      'Inserisci la tua chiave per attivare l\'assistente Kash AI.';

  @override
  String get skAntHint => 'sk-ant-...';

  @override
  String get apiKeyGuardada => 'Chiave API salvata';

  @override
  String get apiKeyEliminada => 'Chiave API eliminata';

  @override
  String get entendido => 'Capito';

  @override
  String get hintImporte => '0,00';

  @override
  String get sinCategoriasAun => 'Non hai ancora categorie.';

  @override
  String get eliminarCategoriaTitle => 'Elimina categoria';

  @override
  String eliminarCategoriaConfirm(String nombre) {
    return 'Vuoi davvero eliminare \"$nombre\"?';
  }

  @override
  String get categoriaPersonalizada => 'Personalizzata';

  @override
  String get sinMovimientosCategoria => 'Nessun movimento';

  @override
  String get unMovimiento => '1 movimento';

  @override
  String nMovimientos(int n) {
    return '$n movimenti';
  }

  @override
  String get moverMovimientosTitle => 'Sposta movimenti in...';

  @override
  String reasignarMovimientosMsg(String nombre) {
    return '\"$nombre\" ha movimenti associati. Scegli in quale categoria spostarli prima di eliminarla.';
  }

  @override
  String get totalEsteMes => 'TOTALE QUESTO MESE';

  @override
  String get eliminarConceptoTitle => 'Elimina voce';

  @override
  String get eliminarConceptoConfirm => 'Vuoi davvero eliminare questa voce?';

  @override
  String get tipoSueldo => 'Stipendio';

  @override
  String get tipoComision => 'Commissione';

  @override
  String get tipoBonus => 'Bonus';

  @override
  String get tipoDieta => 'Indennità';

  @override
  String get tipoOtro => 'Altro';

  @override
  String get concepto => 'Voce';

  @override
  String get conceptosLabel => 'VOCI';

  @override
  String get sinConceptosAun => 'Ancora nessuna voce per questo dipendente.';

  @override
  String get pendiente => 'In sospeso';

  @override
  String get aprobarTodos => 'Approva tutti';

  @override
  String get pendienteDeAprobar => 'IN ATTESA DI APPROVAZIONE';

  @override
  String get tuEquipo => 'IL TUO TEAM';

  @override
  String get sinEmpleadosAun => 'Non hai ancora aggiunto nessun dipendente.';

  @override
  String get exportarInforme => 'Esporta report';

  @override
  String get proTag => 'PRO';

  @override
  String get exportarInformeProTitle => 'Esporta report — Kash Pro';

  @override
  String get exportarInformeProMsg =>
      'Esportare il report dei dipendenti in PDF è una funzione di Kash Pro (pagamento unico, 2,99 €). Sbloccala insieme allo storico dei mesi precedenti e ai budget personalizzati.';

  @override
  String get aprobado => 'Approvato';

  @override
  String get nuevoMovimiento => 'Nuovo movimento';

  @override
  String get categoriaLabel => 'CATEGORIA';

  @override
  String get cuentaLabel => 'CONTO';

  @override
  String get crearCuentaPrimero =>
      'Crea prima un conto per poter salvare i movimenti.';

  @override
  String get asignarAEmpleado => 'ASSEGNA A DIPENDENTE';

  @override
  String get sinAsignar => 'Non assegnato';

  @override
  String get conceptoHint => 'Descrizione (es. Fattura fornitore)';

  @override
  String get gasto => 'Spesa';

  @override
  String get ingreso => 'Entrata';

  @override
  String get movimientoGuardado => 'Movimento salvato';

  @override
  String get clienteLabel => 'Cliente';

  @override
  String get gastoFijoLabel => 'Spesa fissa';

  @override
  String get empleadoLabel => 'Dipendente';

  @override
  String get kashAiTitleSparkle => 'Kash AI ✨';

  @override
  String consultasEsteMes(int n) {
    return '$n richieste questo mese';
  }

  @override
  String get limiteMensualAlcanzado => 'Limite mensile raggiunto';

  @override
  String get sugerenciaAhorro => 'Quanto posso risparmiare?';

  @override
  String get sugerenciaGastoMayor => 'In cosa spendo di più?';

  @override
  String get sugerenciaQuePasaSi => 'Cosa succede se spendo altri 50 €?';

  @override
  String get sugerenciaAnalizaMes => 'Analizza il mio mese';

  @override
  String get kashAiEmptyState => 'Chiedimi quello che vuoi\nsulle tue finanze';

  @override
  String get preguntaKashAiHint => 'Chiedi a Kash AI...';

  @override
  String get kashAiSinApiKey =>
      'Configura la tua chiave API di Anthropic in Impostazioni › Kash AI per iniziare a chattare.';

  @override
  String get separadorO => 'o';

  @override
  String get kashProTitle => 'Kash Pro';

  @override
  String get proximamente => 'Prossimamente';

  @override
  String get featureSyncDevices => 'Sincronizzazione tra dispositivi';

  @override
  String get featureReportsCSV => 'Report ed esportazione CSV';

  @override
  String get featureUnlimitedEmployees => 'Dipendenti e casse illimitati';

  @override
  String get featureCustomThemes => 'Temi personalizzati';

  @override
  String get avisarmeDisponible => 'Avvisami quando disponibile';

  @override
  String get notaOpcionalHint => 'Aggiungi una nota (opzionale)';

  @override
  String get misCuentas => 'I miei conti';

  @override
  String get tusCuentas => 'I TUOI CONTI';

  @override
  String get soloCuentasIncluidas => 'Solo i conti inclusi nel totale';

  @override
  String get principal => 'Principale';

  @override
  String get incluidaEnTotal => 'Incluso nel totale';

  @override
  String get noIncluidaEnTotal => 'Non incluso nel totale';

  @override
  String get icono => 'ICONA';

  @override
  String get nombre => 'NOME';

  @override
  String get nombreCuentaHint => 'Nome del conto';

  @override
  String get actualizarSaldo => 'AGGIORNA SALDO';

  @override
  String get ok => 'OK';

  @override
  String get incluirEnPatrimonio => 'Includi nel patrimonio totale';

  @override
  String get marcarComoPrincipal => 'Imposta come conto principale';

  @override
  String get eliminarCuentaTitle => 'Elimina conto';

  @override
  String eliminarCuentaConfirm(String nombre) {
    return 'Vuoi davvero eliminare \"$nombre\"? Verranno eliminati anche tutti i suoi movimenti.';
  }

  @override
  String get saldoInicialOpcional => 'SALDO INIZIALE (OPZIONALE)';

  @override
  String get cuentaCorrienteEjemplo => 'es. Conto corrente';

  @override
  String get crearCuentaBtn => 'Crea conto';

  @override
  String get cuentaCreada => 'Conto creato';

  @override
  String get totalDelMes => 'TOTALE DEL MESE';

  @override
  String get gastosPorSemana => 'SPESE PER SETTIMANA';

  @override
  String get desgloseCategorias => 'RIPARTIZIONE PER CATEGORIA';

  @override
  String get sinGastosEsteMes => 'Ancora nessuna spesa questo mese.';

  @override
  String valorEsteMes(String valor) {
    return '$valor questo mese';
  }

  @override
  String get exportarPdfProTitle => 'Esporta PDF — Kash Pro';

  @override
  String get exportarPdfProMsg =>
      'Esportare le tue statistiche in PDF è una funzione di Kash Pro (pagamento unico, 2,99 €). Sbloccala insieme allo storico dei mesi precedenti e ai budget personalizzati.';

  @override
  String get editarCategoria => 'Modifica categoria';

  @override
  String get nuevaCategoria => 'Nuova categoria';

  @override
  String get nombreHint => 'Nome';

  @override
  String get emojiLabel => 'EMOJI';

  @override
  String get editarConcepto => 'Modifica voce';

  @override
  String get nuevoConcepto => 'Nuova voce';

  @override
  String get tipoLabel => 'TIPO';

  @override
  String get sinTipo => 'Nessun tipo';

  @override
  String get descripcionConceptoHint =>
      'Descrizione (es. commissione vendita cliente Acme)';

  @override
  String get guardarConcepto => 'Salva voce';

  @override
  String get eliminarElementoConfirm =>
      'Eliminare questo elemento? Questa azione non può essere annullata.';
}
