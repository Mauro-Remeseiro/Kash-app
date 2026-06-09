/// Claves conocidas de la tabla `ajustes`.
class ClaveAjuste {
  static const String modoApp               = 'modo_app';
  static const String tema                  = 'tema';
  static const String presupuestoMensual    = 'presupuesto_mensual';
  static const String moneda                = 'moneda';
  static const String onboardingCompletado  = 'onboarding_completado';
}

/// Valores posibles para el ajuste `tema`.
class TemaAjuste {
  static const String system = 'system';
  static const String dark = 'dark';
  static const String light = 'light';
}

class Ajuste {
  final String clave;
  final String valor;

  const Ajuste({required this.clave, required this.valor});

  factory Ajuste.fromMap(Map<String, Object?> map) {
    return Ajuste(
      clave: map['clave'] as String,
      valor: map['valor'] as String,
    );
  }

  Map<String, Object?> toMap() {
    return {'clave': clave, 'valor': valor};
  }

  Ajuste copyWith({String? clave, String? valor}) {
    return Ajuste(clave: clave ?? this.clave, valor: valor ?? this.valor);
  }
}
