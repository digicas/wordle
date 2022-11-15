import 'package:wordle/game/view/widgets/wordle_tile.dart';

class WordleInput {
  WordleInput({this.letter, this.state = TileState.empty});

  String? letter;
  TileState state;
}
