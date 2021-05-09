class LanguageConstants {
  static const Map<String, String> _fromEngToRus = {
    "New": "Новинки",
    "Bouquet": "Букеты",
    "Basket": "Корзинки",
  };

  static String fromEngToRus(String eng) => _fromEngToRus[eng];
}
