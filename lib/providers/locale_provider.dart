import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/currency_service.dart';
import '../utils/countries.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('es');
  KashCountry _pais = kPaises.firstWhere((p) => p.code == 'ES');

  Locale get locale => _locale;
  KashCountry get pais => _pais;

  Future<void> init() async {
    final prefs     = await SharedPreferences.getInstance();
    final langCode  = prefs.getString('kash_lang')    ?? 'es';
    final paisCode  = prefs.getString('kash_country') ?? 'ES';
    _locale = Locale(langCode);
    _pais   = kPaisPorCodigo(paisCode) ?? kPaises.first;
    CurrencyService.configure(_pais);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('kash_lang', locale.languageCode);
    notifyListeners();
  }

  Future<void> setPais(KashCountry pais) async {
    _pais = pais;
    CurrencyService.configure(pais);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('kash_country', pais.code);
    notifyListeners();
  }
}
