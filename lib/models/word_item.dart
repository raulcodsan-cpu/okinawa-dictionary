class WordItem {
  WordItem({
    required this.id,
    required this.word,
    required this.ipa,
    required this.kana,
    required this.meanings,
  });
  final int id;
  final String word;
  final String ipa;
  final List<String> meanings;
  String kana;
}
