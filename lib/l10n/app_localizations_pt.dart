// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Kash';

  @override
  String get bienvenido => 'Bem-vindo ao Kash';

  @override
  String get elegirIdioma => 'Escolha seu idioma';

  @override
  String get elegirPais => 'Em qual país você está?';

  @override
  String get ajustaMoneda => 'Definimos sua moeda automaticamente';

  @override
  String get continuar => 'Continuar';

  @override
  String get comoUsarasKash => 'Como você usará o Kash?';

  @override
  String get modoPersonalDesc => 'Controle seus gastos e receitas do dia a dia';

  @override
  String get modoEmpresaDesc =>
      'Gerencie finanças, funcionários e contas do seu negócio';

  @override
  String get empezar => 'Começar';

  @override
  String get protegeApp => 'Proteja seu app';

  @override
  String get soloTuPodras => 'Só você poderá ver suas finanças';

  @override
  String get activarHuella => 'Ativar impressão digital / Face ID';

  @override
  String get crearPin => 'Crie um PIN de backup';

  @override
  String get finalizarConfig => 'Finalizar configuração';

  @override
  String get ahoraNO => 'Agora não';

  @override
  String get gastos => 'Gastos';

  @override
  String get ingresos => 'Receitas';

  @override
  String get balance => 'Saldo';

  @override
  String get gastadoEsteMes => 'GASTO ESTE MÊS';

  @override
  String get balanceEsteMes => 'SALDO DO MÊS';

  @override
  String get ultimosMovimientos => 'ÚLTIMAS TRANSAÇÕES';

  @override
  String get nuevaCuenta => 'Nova conta';

  @override
  String get guardar => 'Salvar';

  @override
  String get cancelar => 'Cancelar';

  @override
  String get eliminar => 'Excluir';

  @override
  String get editar => 'Editar';

  @override
  String get ajustes => 'Configurações';

  @override
  String get preferencias => 'PREFERÊNCIAS';

  @override
  String get seguridad => 'SEGURANÇA';

  @override
  String get idioma => 'Idioma';

  @override
  String get pais => 'País';

  @override
  String get moneda => 'Moeda';

  @override
  String get paisYMoneda => 'País e moeda';

  @override
  String get inicio => 'Início';

  @override
  String get estadisticas => 'Stats';

  @override
  String get estadisticasTitle => 'Estatísticas';

  @override
  String get cuentas => 'Contas';

  @override
  String get categorias => 'Categorias';

  @override
  String get empleados => 'Funcionários';

  @override
  String get modoPersonal => 'Pessoal';

  @override
  String get modoEmpresa => 'Empresa';

  @override
  String get sinMovimientos => 'Ainda não há transações neste período';

  @override
  String get crearPrimero => 'Crie sua primeira conta para começar';

  @override
  String get patrimonio => 'Patrimônio total';

  @override
  String get presupuesto => 'ORÇAMENTO MENSAL';

  @override
  String get exportarPdf => 'Exportar PDF';

  @override
  String get proFeature => 'Função Pro';

  @override
  String get bloqueoApp => 'Bloqueio biométrico';

  @override
  String get cambiarPin => 'Alterar PIN';

  @override
  String get desbloquear => 'Usar biometria';

  @override
  String get pinIncorrecto => 'PIN incorreto';

  @override
  String intentosRestantes(int n) {
    return '$n tentativas restantes';
  }

  @override
  String bloqueadoSegundos(int s) {
    return 'Bloqueado ${s}s';
  }

  @override
  String get tusFinanzas => 'Suas finanças, protegidas';

  @override
  String get modoPodrasCambiar =>
      'Você pode mudar isso depois em Configurações';

  @override
  String get tuMonedaSera => 'Sua moeda será';

  @override
  String get buscarPais => 'Buscar país...';

  @override
  String get modoDeUso => 'Modo';

  @override
  String get sinPresupuesto => 'Sem orçamento mensal definido';

  @override
  String get tocarParaEditar => 'Toque para editar';

  @override
  String get presupuestoMensual => 'Orçamento mensal';

  @override
  String get tema => 'TEMA';

  @override
  String get modoApp => 'MODO DO APP';

  @override
  String get bloqueoCapturas => 'Bloquear capturas de tela';

  @override
  String get pantallaNegraMultitarea => 'Tela preta no alternador de apps';

  @override
  String get desactivarProteccion => 'Desativar proteção';

  @override
  String get desactivarProteccionMsg =>
      'O app não pedirá mais PIN nem biometria ao abrir. Continuar?';

  @override
  String get desactivar => 'Desativar';

  @override
  String get pinActualizado => 'PIN atualizado';

  @override
  String get pinActual => 'PIN atual';

  @override
  String get nuevoPin => 'Novo PIN';

  @override
  String get confirmarPin => 'Confirmar PIN';

  @override
  String get pinesNoCoinciden => 'Os PINs não coincidem';

  @override
  String get crear => 'Criar';

  @override
  String get pinGuardadoCheck => '✓ PIN salvo';

  @override
  String get bloqueado => 'Bloqueado';

  @override
  String get filtroSemana => 'Semana';

  @override
  String get filtroMes => 'Mês';

  @override
  String get filtroTodo => 'Tudo';

  @override
  String gastadoDeTotal(String gastado, String total) {
    return '$gastado de $total';
  }

  @override
  String get sinPresupuestoDefinido => 'Sem orçamento definido';

  @override
  String get confirmarEliminarMovimiento =>
      'Eliminar este movimento? Esta ação não pode ser desfeita.';

  @override
  String get movimientoEliminado => 'Movimento eliminado';

  @override
  String get sinMovimientosPeriodo => 'Sem movimentos neste período';

  @override
  String get sistemaTema => 'Sistema';

  @override
  String get claroTema => 'Claro';

  @override
  String get oscuroTema => 'Escuro';

  @override
  String get categoriasLabel => 'CATEGORIAS';

  @override
  String get misCategorias => 'Minhas categorias';

  @override
  String get kashAiLabel => 'KASH AI';

  @override
  String get huellaOFaceId => 'Digital ou Face ID ao entrar';

  @override
  String get claveApiAnthropic => 'Chave de API da Anthropic';

  @override
  String kashAiActivo(int n) {
    return 'O Kash AI está ativado. $n consultas restantes este mês.';
  }

  @override
  String get kashAiInactivo =>
      'Introduz a tua chave para ativar o assistente Kash AI.';

  @override
  String get skAntHint => 'sk-ant-...';

  @override
  String get apiKeyGuardada => 'Chave de API guardada';

  @override
  String get apiKeyEliminada => 'Chave de API eliminada';

  @override
  String get entendido => 'Entendido';

  @override
  String get hintImporte => '0,00';

  @override
  String get sinCategoriasAun => 'Ainda não tens categorias.';

  @override
  String get eliminarCategoriaTitle => 'Eliminar categoria';

  @override
  String eliminarCategoriaConfirm(String nombre) {
    return 'Tens a certeza de que queres eliminar \"$nombre\"?';
  }

  @override
  String get categoriaPersonalizada => 'Personalizada';

  @override
  String get sinMovimientosCategoria => 'Sem movimentos';

  @override
  String get unMovimiento => '1 movimento';

  @override
  String nMovimientos(int n) {
    return '$n movimentos';
  }

  @override
  String get moverMovimientosTitle => 'Mover movimentos para...';

  @override
  String reasignarMovimientosMsg(String nombre) {
    return '\"$nombre\" tem movimentos associados. Escolhe para que categoria queres movê-los antes de a eliminar.';
  }

  @override
  String get totalEsteMes => 'TOTAL ESTE MÊS';

  @override
  String get eliminarConceptoTitle => 'Eliminar conceito';

  @override
  String get eliminarConceptoConfirm =>
      'Tens a certeza de que queres eliminar este conceito?';

  @override
  String get tipoSueldo => 'Salário';

  @override
  String get tipoComision => 'Comissão';

  @override
  String get tipoBonus => 'Bónus';

  @override
  String get tipoDieta => 'Ajuda de custo';

  @override
  String get tipoOtro => 'Outro';

  @override
  String get concepto => 'Conceito';

  @override
  String get conceptosLabel => 'CONCEITOS';

  @override
  String get sinConceptosAun => 'Ainda não há conceitos para este funcionário.';

  @override
  String get pendiente => 'Pendente';

  @override
  String get aprobarTodos => 'Aprovar todos';

  @override
  String get pendienteDeAprobar => 'PENDENTE DE APROVAÇÃO';

  @override
  String get tuEquipo => 'A TUA EQUIPA';

  @override
  String get sinEmpleadosAun => 'Ainda não adicionaste nenhum funcionário.';

  @override
  String get exportarInforme => 'Exportar relatório';

  @override
  String get proTag => 'PRO';

  @override
  String get exportarInformeProTitle => 'Exportar relatório — Kash Pro';

  @override
  String get exportarInformeProMsg =>
      'Exportar o relatório de funcionários em PDF é uma funcionalidade do Kash Pro (pagamento único, 2,99 €). Desbloqueia-a junto com o histórico de meses anteriores e os orçamentos personalizados.';

  @override
  String get aprobado => 'Aprovado';

  @override
  String get nuevoMovimiento => 'Novo movimento';

  @override
  String get categoriaLabel => 'CATEGORIA';

  @override
  String get cuentaLabel => 'CONTA';

  @override
  String get crearCuentaPrimero =>
      'Cria primeiro uma conta para poderes guardar movimentos.';

  @override
  String get asignarAEmpleado => 'ATRIBUIR A FUNCIONÁRIO';

  @override
  String get sinAsignar => 'Sem atribuição';

  @override
  String get conceptoHint => 'Conceito (p. ex. Fatura de fornecedor)';

  @override
  String get gasto => 'Despesa';

  @override
  String get ingreso => 'Receita';

  @override
  String get movimientoGuardado => 'Movimento guardado';

  @override
  String get clienteLabel => 'Cliente';

  @override
  String get gastoFijoLabel => 'Despesa fixa';

  @override
  String get empleadoLabel => 'Funcionário';

  @override
  String get kashAiTitleSparkle => 'Kash AI ✨';

  @override
  String consultasEsteMes(int n) {
    return '$n consultas este mês';
  }

  @override
  String get limiteMensualAlcanzado => 'Limite mensal atingido';

  @override
  String get sugerenciaAhorro => 'Quanto posso poupar?';

  @override
  String get sugerenciaGastoMayor => 'Em que gasto mais?';

  @override
  String get sugerenciaQuePasaSi => 'O que acontece se eu gastar mais 50 €?';

  @override
  String get sugerenciaAnalizaMes => 'Analisa o meu mês';

  @override
  String get kashAiEmptyState =>
      'Pergunta-me o que quiseres\nsobre as tuas finanças';

  @override
  String get preguntaKashAiHint => 'Pergunta ao Kash AI...';

  @override
  String get kashAiSinApiKey =>
      'Configura a tua chave de API da Anthropic em Definições › Kash AI para começares a conversar.';

  @override
  String get separadorO => 'ou';

  @override
  String get kashProTitle => 'Kash Pro';

  @override
  String get proximamente => 'Brevemente';

  @override
  String get featureSyncDevices => 'Sincronização entre dispositivos';

  @override
  String get featureReportsCSV => 'Relatórios e exportação CSV';

  @override
  String get featureUnlimitedEmployees => 'Funcionários e caixas ilimitados';

  @override
  String get featureCustomThemes => 'Temas personalizados';

  @override
  String get avisarmeDisponible => 'Avisar-me quando estiver disponível';

  @override
  String get notaOpcionalHint => 'Adicionar uma nota (opcional)';

  @override
  String get misCuentas => 'As minhas contas';

  @override
  String get tusCuentas => 'AS TUAS CONTAS';

  @override
  String get soloCuentasIncluidas => 'Apenas contas incluídas no total';

  @override
  String get principal => 'Principal';

  @override
  String get incluidaEnTotal => 'Incluída no total';

  @override
  String get noIncluidaEnTotal => 'Não incluída no total';

  @override
  String get icono => 'ÍCONE';

  @override
  String get nombre => 'NOME';

  @override
  String get nombreCuentaHint => 'Nome da conta';

  @override
  String get actualizarSaldo => 'ATUALIZAR SALDO';

  @override
  String get ok => 'OK';

  @override
  String get incluirEnPatrimonio => 'Incluir no património total';

  @override
  String get marcarComoPrincipal => 'Marcar como conta principal';

  @override
  String get eliminarCuentaTitle => 'Eliminar conta';

  @override
  String eliminarCuentaConfirm(String nombre) {
    return 'Tens a certeza de que queres eliminar \"$nombre\"? Todos os seus movimentos também serão eliminados.';
  }

  @override
  String get saldoInicialOpcional => 'SALDO INICIAL (OPCIONAL)';

  @override
  String get cuentaCorrienteEjemplo => 'p. ex. Conta corrente';

  @override
  String get crearCuentaBtn => 'Criar conta';

  @override
  String get cuentaCreada => 'Conta criada';

  @override
  String get totalDelMes => 'TOTAL DO MÊS';

  @override
  String get gastosPorSemana => 'DESPESAS POR SEMANA';

  @override
  String get desgloseCategorias => 'DETALHE POR CATEGORIA';

  @override
  String get sinGastosEsteMes => 'Ainda não há despesas este mês.';

  @override
  String valorEsteMes(String valor) {
    return '$valor este mês';
  }

  @override
  String get exportarPdfProTitle => 'Exportar PDF — Kash Pro';

  @override
  String get exportarPdfProMsg =>
      'Exportar as tuas estatísticas em PDF é uma funcionalidade do Kash Pro (pagamento único, 2,99 €). Desbloqueia-a junto com o histórico de meses anteriores e os orçamentos personalizados.';

  @override
  String get editarCategoria => 'Editar categoria';

  @override
  String get nuevaCategoria => 'Nova categoria';

  @override
  String get nombreHint => 'Nome';

  @override
  String get emojiLabel => 'EMOJI';

  @override
  String get editarConcepto => 'Editar conceito';

  @override
  String get nuevoConcepto => 'Novo conceito';

  @override
  String get tipoLabel => 'TIPO';

  @override
  String get sinTipo => 'Sem tipo';

  @override
  String get descripcionConceptoHint =>
      'Descrição (ex. comissão venda cliente Acme)';

  @override
  String get guardarConcepto => 'Guardar conceito';

  @override
  String get eliminarElementoConfirm =>
      'Eliminar este elemento? Esta ação não pode ser desfeita.';
}
