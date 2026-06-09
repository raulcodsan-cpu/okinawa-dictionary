class WordItem {
  WordItem({
    required this.id,
    required this.word,
    required this.ipa,
    required this.kana,
    required this.meaning1,
    this.meaning2 = '',
    this.meaning3 = '',
  });
  final int id;
  final String word;
  final String ipa;
  final String meaning1;
  String meaning2;
  String meaning3;
  String kana;
}
