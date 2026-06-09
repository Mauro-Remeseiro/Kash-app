class KashCountry {
  final String code;
  final String nombre;
  final String emoji;
  final String moneda;
  final String simbolo;
  final String locale;

  const KashCountry({
    required this.code,
    required this.nombre,
    required this.emoji,
    required this.moneda,
    required this.simbolo,
    required this.locale,
  });
}

const List<KashCountry> kPaises = [
  // Europa
  KashCountry(code: 'ES', nombre: 'España',         emoji: '🇪🇸', moneda: 'EUR', simbolo: '€',  locale: 'es_ES'),
  KashCountry(code: 'DE', nombre: 'Alemania',        emoji: '🇩🇪', moneda: 'EUR', simbolo: '€',  locale: 'de_DE'),
  KashCountry(code: 'FR', nombre: 'Francia',         emoji: '🇫🇷', moneda: 'EUR', simbolo: '€',  locale: 'fr_FR'),
  KashCountry(code: 'IT', nombre: 'Italia',          emoji: '🇮🇹', moneda: 'EUR', simbolo: '€',  locale: 'it_IT'),
  KashCountry(code: 'PT', nombre: 'Portugal',        emoji: '🇵🇹', moneda: 'EUR', simbolo: '€',  locale: 'pt_PT'),
  KashCountry(code: 'NL', nombre: 'Países Bajos',    emoji: '🇳🇱', moneda: 'EUR', simbolo: '€',  locale: 'nl_NL'),
  KashCountry(code: 'BE', nombre: 'Bélgica',         emoji: '🇧🇪', moneda: 'EUR', simbolo: '€',  locale: 'fr_BE'),
  KashCountry(code: 'GB', nombre: 'Reino Unido',     emoji: '🇬🇧', moneda: 'GBP', simbolo: '£',  locale: 'en_GB'),
  KashCountry(code: 'CH', nombre: 'Suiza',           emoji: '🇨🇭', moneda: 'CHF', simbolo: 'Fr', locale: 'de_CH'),
  KashCountry(code: 'PL', nombre: 'Polonia',         emoji: '🇵🇱', moneda: 'PLN', simbolo: 'zł', locale: 'pl_PL'),
  // América Latina
  KashCountry(code: 'MX', nombre: 'México',          emoji: '🇲🇽', moneda: 'MXN', simbolo: '\$', locale: 'es_MX'),
  KashCountry(code: 'AR', nombre: 'Argentina',       emoji: '🇦🇷', moneda: 'ARS', simbolo: '\$', locale: 'es_AR'),
  KashCountry(code: 'CO', nombre: 'Colombia',        emoji: '🇨🇴', moneda: 'COP', simbolo: '\$', locale: 'es_CO'),
  KashCountry(code: 'CL', nombre: 'Chile',           emoji: '🇨🇱', moneda: 'CLP', simbolo: '\$', locale: 'es_CL'),
  KashCountry(code: 'PE', nombre: 'Perú',            emoji: '🇵🇪', moneda: 'PEN', simbolo: 'S/', locale: 'es_PE'),
  KashCountry(code: 'BR', nombre: 'Brasil',          emoji: '🇧🇷', moneda: 'BRL', simbolo: 'R\$', locale: 'pt_BR'),
  KashCountry(code: 'UY', nombre: 'Uruguay',         emoji: '🇺🇾', moneda: 'UYU', simbolo: '\$', locale: 'es_UY'),
  KashCountry(code: 'VE', nombre: 'Venezuela',       emoji: '🇻🇪', moneda: 'VES', simbolo: 'Bs', locale: 'es_VE'),
  KashCountry(code: 'EC', nombre: 'Ecuador',         emoji: '🇪🇨', moneda: 'USD', simbolo: '\$', locale: 'es_EC'),
  KashCountry(code: 'BO', nombre: 'Bolivia',         emoji: '🇧🇴', moneda: 'BOB', simbolo: 'Bs', locale: 'es_BO'),
  KashCountry(code: 'PY', nombre: 'Paraguay',        emoji: '🇵🇾', moneda: 'PYG', simbolo: '₲', locale: 'es_PY'),
  // América del Norte
  KashCountry(code: 'US', nombre: 'Estados Unidos',  emoji: '🇺🇸', moneda: 'USD', simbolo: '\$', locale: 'en_US'),
  KashCountry(code: 'CA', nombre: 'Canadá',          emoji: '🇨🇦', moneda: 'CAD', simbolo: '\$', locale: 'en_CA'),
  // Resto del mundo
  KashCountry(code: 'AU', nombre: 'Australia',       emoji: '🇦🇺', moneda: 'AUD', simbolo: '\$', locale: 'en_AU'),
  KashCountry(code: 'JP', nombre: 'Japón',           emoji: '🇯🇵', moneda: 'JPY', simbolo: '¥',  locale: 'ja_JP'),
  KashCountry(code: 'CN', nombre: 'China',           emoji: '🇨🇳', moneda: 'CNY', simbolo: '¥',  locale: 'zh_CN'),
  KashCountry(code: 'IN', nombre: 'India',           emoji: '🇮🇳', moneda: 'INR', simbolo: '₹',  locale: 'hi_IN'),
  KashCountry(code: 'AE', nombre: 'Emiratos Árabes', emoji: '🇦🇪', moneda: 'AED', simbolo: 'د.إ', locale: 'ar_AE'),
  KashCountry(code: 'SA', nombre: 'Arabia Saudí',    emoji: '🇸🇦', moneda: 'SAR', simbolo: '﷼',  locale: 'ar_SA'),
  KashCountry(code: 'MA', nombre: 'Marruecos',       emoji: '🇲🇦', moneda: 'MAD', simbolo: 'د.م', locale: 'ar_MA'),
];

KashCountry? kPaisPorCodigo(String code) {
  try {
    return kPaises.firstWhere((p) => p.code == code);
  } catch (_) {
    return null;
  }
}
