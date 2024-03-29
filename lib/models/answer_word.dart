// ignore_for_file: avoid_dynamic_calls

class AnswerWord {
  const AnswerWord({
    required this.word,
     this.czechTr,
  });

  factory AnswerWord.fromJson(dynamic json) {
    return AnswerWord(
      word: (json['word'] as String).toLowerCase(),
      czechTr: json['czechTranslate'] as String?,
    );
  }
  final String word;
  final String? czechTr;

  bool containsLetter(String letter) => word.split('').contains(letter);
  bool letterCorrectIndex(String letter, int index) =>
      containsLetter(letter) && word.split('').elementAt(index) == letter;

  List<String> get letters => word.toLowerCase().split('');

  int charCount(String char) {
    var count = 0;
    for(final letter in letters) {
      if(letter.toLowerCase() == char.toLowerCase()) count++;
    }
    return count;
  }

  @override
  String toString() {
    return '{ $word, $czechTr }';
  }
}
