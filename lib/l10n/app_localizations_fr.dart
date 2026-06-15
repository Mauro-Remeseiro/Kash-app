// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Kash';

  @override
  String get bienvenido => 'Bienvenue sur Kash';

  @override
  String get elegirIdioma => 'Choisissez votre langue';

  @override
  String get elegirPais => 'Dans quel pays êtes-vous ?';

  @override
  String get ajustaMoneda => 'Nous configurons votre devise automatiquement';

  @override
  String get continuar => 'Continuer';

  @override
  String get comoUsarasKash => 'Comment utiliserez-vous Kash ?';

  @override
  String get modoPersonalDesc => 'Contrôlez vos dépenses et revenus quotidiens';

  @override
  String get modoEmpresaDesc =>
      'Gérez les finances, les employés et les comptes de votre entreprise';

  @override
  String get empezar => 'Commencer';

  @override
  String get protegeApp => 'Protégez votre app';

  @override
  String get soloTuPodras => 'Seul vous pourrez voir vos finances';

  @override
  String get activarHuella => 'Activer l\'empreinte / Face ID';

  @override
  String get crearPin => 'Créez un PIN de secours';

  @override
  String get finalizarConfig => 'Terminer la configuration';

  @override
  String get ahoraNO => 'Pas maintenant';

  @override
  String get gastos => 'Dépenses';

  @override
  String get ingresos => 'Revenus';

  @override
  String get balance => 'Solde';

  @override
  String get gastadoEsteMes => 'DÉPENSÉ CE MOIS';

  @override
  String get balanceEsteMes => 'SOLDE DU MOIS';

  @override
  String get ultimosMovimientos => 'DERNIÈRES TRANSACTIONS';

  @override
  String get nuevaCuenta => 'Nouveau compte';

  @override
  String get guardar => 'Enregistrer';

  @override
  String get cancelar => 'Annuler';

  @override
  String get eliminar => 'Supprimer';

  @override
  String get editar => 'Modifier';

  @override
  String get ajustes => 'Paramètres';

  @override
  String get preferencias => 'PRÉFÉRENCES';

  @override
  String get seguridad => 'SÉCURITÉ';

  @override
  String get idioma => 'Langue';

  @override
  String get pais => 'Pays';

  @override
  String get moneda => 'Devise';

  @override
  String get paisYMoneda => 'Pays et devise';

  @override
  String get inicio => 'Accueil';

  @override
  String get estadisticas => 'Stats';

  @override
  String get estadisticasTitle => 'Statistiques';

  @override
  String get cuentas => 'Comptes';

  @override
  String get categorias => 'Catégories';

  @override
  String get empleados => 'Employés';

  @override
  String get modoPersonal => 'Personnel';

  @override
  String get modoEmpresa => 'Entreprise';

  @override
  String get sinMovimientos => 'Pas encore de transactions sur cette période';

  @override
  String get crearPrimero => 'Créez votre premier compte pour commencer';

  @override
  String get patrimonio => 'Patrimoine total';

  @override
  String get presupuesto => 'BUDGET MENSUEL';

  @override
  String get exportarPdf => 'Exporter PDF';

  @override
  String get proFeature => 'Fonctionnalité Pro';

  @override
  String get bloqueoApp => 'Verrou biométrique';

  @override
  String get cambiarPin => 'Changer le PIN';

  @override
  String get desbloquear => 'Utiliser la biométrie';

  @override
  String get pinIncorrecto => 'PIN incorrect';

  @override
  String intentosRestantes(int n) {
    return '$n tentatives restantes';
  }

  @override
  String bloqueadoSegundos(int s) {
    return 'Verrouillé ${s}s';
  }

  @override
  String get tusFinanzas => 'Vos finances, protégées';

  @override
  String get modoPodrasCambiar => 'Vous pourrez le changer dans Paramètres';

  @override
  String get tuMonedaSera => 'Votre devise sera';

  @override
  String get buscarPais => 'Rechercher un pays...';

  @override
  String get modoDeUso => 'Mode';

  @override
  String get sinPresupuesto => 'Aucun budget mensuel défini';

  @override
  String get tocarParaEditar => 'Toucher pour modifier';

  @override
  String get presupuestoMensual => 'Budget mensuel';

  @override
  String get tema => 'THÈME';

  @override
  String get modoApp => 'MODE DE L\'APP';

  @override
  String get bloqueoCapturas => 'Bloquer les captures d\'écran';

  @override
  String get pantallaNegraMultitarea =>
      'Écran noir dans le gestionnaire d\'apps';

  @override
  String get desactivarProteccion => 'Désactiver la protection';

  @override
  String get desactivarProteccionMsg =>
      'L\'app ne demandera plus le PIN ni la biométrie. Continuer ?';

  @override
  String get desactivar => 'Désactiver';

  @override
  String get pinActualizado => 'PIN mis à jour';

  @override
  String get pinActual => 'PIN actuel';

  @override
  String get nuevoPin => 'Nouveau PIN';

  @override
  String get confirmarPin => 'Confirmer le PIN';

  @override
  String get pinesNoCoinciden => 'Les PINs ne correspondent pas';

  @override
  String get crear => 'Créer';

  @override
  String get pinGuardadoCheck => '✓ PIN enregistré';

  @override
  String get bloqueado => 'Verrouillé';

  @override
  String get filtroSemana => 'Semaine';

  @override
  String get filtroMes => 'Mois';

  @override
  String get filtroTodo => 'Tout';

  @override
  String gastadoDeTotal(String gastado, String total) {
    return '$gastado sur $total';
  }

  @override
  String get sinPresupuestoDefinido => 'Aucun budget défini';

  @override
  String get confirmarEliminarMovimiento =>
      'Supprimer ce mouvement ? Cette action est irréversible.';

  @override
  String get movimientoEliminado => 'Mouvement supprimé';

  @override
  String get sinMovimientosPeriodo => 'Aucun mouvement sur cette période';

  @override
  String get sistemaTema => 'Système';

  @override
  String get claroTema => 'Clair';

  @override
  String get oscuroTema => 'Sombre';

  @override
  String get categoriasLabel => 'CATÉGORIES';

  @override
  String get misCategorias => 'Mes catégories';

  @override
  String get kashAiLabel => 'KASH AI';

  @override
  String get huellaOFaceId => 'Empreinte ou Face ID à l\'ouverture';

  @override
  String get claveApiAnthropic => 'Clé API Anthropic';

  @override
  String kashAiActivo(int n) {
    return 'Kash AI est activé. $n requêtes restantes ce mois-ci.';
  }

  @override
  String get kashAiInactivo =>
      'Saisissez votre clé pour activer l\'assistant Kash AI.';

  @override
  String get skAntHint => 'sk-ant-...';

  @override
  String get apiKeyGuardada => 'Clé API enregistrée';

  @override
  String get apiKeyEliminada => 'Clé API supprimée';

  @override
  String get entendido => 'Compris';

  @override
  String get hintImporte => '0,00';

  @override
  String get sinCategoriasAun => 'Vous n\'avez encore aucune catégorie.';

  @override
  String get eliminarCategoriaTitle => 'Supprimer la catégorie';

  @override
  String eliminarCategoriaConfirm(String nombre) {
    return 'Voulez-vous vraiment supprimer « $nombre » ?';
  }

  @override
  String get categoriaPersonalizada => 'Personnalisée';

  @override
  String get sinMovimientosCategoria => 'Aucun mouvement';

  @override
  String get unMovimiento => '1 mouvement';

  @override
  String nMovimientos(int n) {
    return '$n mouvements';
  }

  @override
  String get moverMovimientosTitle => 'Déplacer les mouvements vers...';

  @override
  String reasignarMovimientosMsg(String nombre) {
    return '« $nombre » contient des mouvements associés. Choisissez la catégorie vers laquelle les déplacer avant de la supprimer.';
  }

  @override
  String get totalEsteMes => 'TOTAL CE MOIS-CI';

  @override
  String get eliminarConceptoTitle => 'Supprimer l\'élément';

  @override
  String get eliminarConceptoConfirm =>
      'Voulez-vous vraiment supprimer cet élément ?';

  @override
  String get tipoSueldo => 'Salaire';

  @override
  String get tipoComision => 'Commission';

  @override
  String get tipoBonus => 'Prime';

  @override
  String get tipoDieta => 'Indemnité';

  @override
  String get tipoOtro => 'Autre';

  @override
  String get concepto => 'Élément';

  @override
  String get conceptosLabel => 'ÉLÉMENTS';

  @override
  String get sinConceptosAun =>
      'Aucun élément pour cet employé pour l\'instant.';

  @override
  String get pendiente => 'En attente';

  @override
  String get aprobarTodos => 'Tout approuver';

  @override
  String get pendienteDeAprobar => 'EN ATTENTE D\'APPROBATION';

  @override
  String get tuEquipo => 'VOTRE ÉQUIPE';

  @override
  String get sinEmpleadosAun => 'Vous n\'avez encore ajouté aucun employé.';

  @override
  String get exportarInforme => 'Exporter le rapport';

  @override
  String get proTag => 'PRO';

  @override
  String get exportarInformeProTitle => 'Exporter le rapport — Kash Pro';

  @override
  String get exportarInformeProMsg =>
      'Exporter le rapport des employés en PDF est une fonctionnalité de Kash Pro (paiement unique de 2,99 €). Débloquez-la avec l\'historique des mois précédents et les budgets personnalisés.';

  @override
  String get aprobado => 'Approuvé';

  @override
  String get nuevoMovimiento => 'Nouveau mouvement';

  @override
  String get categoriaLabel => 'CATÉGORIE';

  @override
  String get cuentaLabel => 'COMPTE';

  @override
  String get crearCuentaPrimero =>
      'Créez d\'abord un compte pour pouvoir enregistrer des mouvements.';

  @override
  String get asignarAEmpleado => 'ASSIGNER À UN EMPLOYÉ';

  @override
  String get sinAsignar => 'Non assigné';

  @override
  String get conceptoHint => 'Libellé (p. ex. Facture fournisseur)';

  @override
  String get gasto => 'Dépense';

  @override
  String get ingreso => 'Revenu';

  @override
  String get movimientoGuardado => 'Mouvement enregistré';

  @override
  String get clienteLabel => 'Client';

  @override
  String get gastoFijoLabel => 'Dépense fixe';

  @override
  String get empleadoLabel => 'Employé';

  @override
  String get kashAiTitleSparkle => 'Kash AI ✨';

  @override
  String consultasEsteMes(int n) {
    return '$n requêtes ce mois-ci';
  }

  @override
  String get limiteMensualAlcanzado => 'Limite mensuelle atteinte';

  @override
  String get sugerenciaAhorro => 'Combien puis-je économiser ?';

  @override
  String get sugerenciaGastoMayor => 'Sur quoi dépensé-je le plus ?';

  @override
  String get sugerenciaQuePasaSi =>
      'Que se passe-t-il si je dépense 50 € de plus ?';

  @override
  String get sugerenciaAnalizaMes => 'Analyse mon mois';

  @override
  String get kashAiEmptyState => 'Posez-moi vos questions\nsur vos finances';

  @override
  String get preguntaKashAiHint => 'Demandez à Kash AI...';

  @override
  String get kashAiSinApiKey =>
      'Configurez votre clé API Anthropic dans Réglages › Kash AI pour commencer à discuter.';

  @override
  String get separadorO => 'ou';

  @override
  String get kashProTitle => 'Kash Pro';

  @override
  String get proximamente => 'Bientôt disponible';

  @override
  String get featureSyncDevices => 'Synchronisation entre appareils';

  @override
  String get featureReportsCSV => 'Rapports et export CSV';

  @override
  String get featureUnlimitedEmployees => 'Employés et caisses illimités';

  @override
  String get featureCustomThemes => 'Thèmes personnalisés';

  @override
  String get avisarmeDisponible => 'Me prévenir quand ce sera disponible';

  @override
  String get notaOpcionalHint => 'Ajouter une note (facultatif)';

  @override
  String get misCuentas => 'Mes comptes';

  @override
  String get tusCuentas => 'VOS COMPTES';

  @override
  String get soloCuentasIncluidas => 'Seuls les comptes inclus dans le total';

  @override
  String get principal => 'Principal';

  @override
  String get incluidaEnTotal => 'Inclus dans le total';

  @override
  String get noIncluidaEnTotal => 'Exclu du total';

  @override
  String get icono => 'ICÔNE';

  @override
  String get nombre => 'NOM';

  @override
  String get nombreCuentaHint => 'Nom du compte';

  @override
  String get actualizarSaldo => 'METTRE À JOUR LE SOLDE';

  @override
  String get ok => 'OK';

  @override
  String get incluirEnPatrimonio => 'Inclure dans le patrimoine total';

  @override
  String get marcarComoPrincipal => 'Définir comme compte principal';

  @override
  String get eliminarCuentaTitle => 'Supprimer le compte';

  @override
  String eliminarCuentaConfirm(String nombre) {
    return 'Voulez-vous vraiment supprimer « $nombre » ? Tous ses mouvements seront également supprimés.';
  }

  @override
  String get saldoInicialOpcional => 'SOLDE INITIAL (FACULTATIF)';

  @override
  String get cuentaCorrienteEjemplo => 'p. ex. Compte courant';

  @override
  String get crearCuentaBtn => 'Créer un compte';

  @override
  String get cuentaCreada => 'Compte créé';

  @override
  String get totalDelMes => 'TOTAL DU MOIS';

  @override
  String get gastosPorSemana => 'DÉPENSES PAR SEMAINE';

  @override
  String get desgloseCategorias => 'RÉPARTITION PAR CATÉGORIE';

  @override
  String get sinGastosEsteMes => 'Aucune dépense ce mois-ci pour l\'instant.';

  @override
  String valorEsteMes(String valor) {
    return '$valor ce mois-ci';
  }

  @override
  String get exportarPdfProTitle => 'Exporter le PDF — Kash Pro';

  @override
  String get exportarPdfProMsg =>
      'Exporter vos statistiques en PDF est une fonctionnalité de Kash Pro (paiement unique de 2,99 €). Débloquez-la avec l\'historique des mois précédents et les budgets personnalisés.';

  @override
  String get editarCategoria => 'Modifier la catégorie';

  @override
  String get nuevaCategoria => 'Nouvelle catégorie';

  @override
  String get nombreHint => 'Nom';

  @override
  String get emojiLabel => 'EMOJI';

  @override
  String get editarConcepto => 'Modifier l\'élément';

  @override
  String get nuevoConcepto => 'Nouvel élément';

  @override
  String get tipoLabel => 'TYPE';

  @override
  String get sinTipo => 'Aucun type';

  @override
  String get descripcionConceptoHint =>
      'Description (ex. commission vente client Acme)';

  @override
  String get guardarConcepto => 'Enregistrer l\'élément';

  @override
  String get eliminarElementoConfirm =>
      'Supprimer cet élément ? Cette action est irréversible.';
}
