import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordle/game/view/widgets/keyboard.dart';
import 'package:wordle/game/view/widgets/language_button.dart';
import 'package:wordle/game/view/widgets/post_game_container.dart';
import 'package:wordle/game/view/widgets/shake_animation.dart';
import 'package:wordle/game/view/widgets/wordle_tile.dart';
import 'package:wordle/instruction/view/insctructions_page.dart';

import 'package:wordle/models/answer_word.dart';
import 'package:wordle/models/wordle_input.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.activeLangs,
    required this.onFinished,
    required this.onLevelStarted,
    required this.menuImage,
  });

  final List<Language> activeLangs;
  final void Function(int) onFinished;
  final void Function() onLevelStarted;
  final Image menuImage;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final answerWords = <AnswerWord>[];
  final guessWords = <String>[];
  final scrollController = ScrollController();
  final hintGlobalKey = GlobalKey();
  final scaffoldState = GlobalKey<ScaffoldState>();

  late Language selectedLang = widget.activeLangs.first;

  AnswerWord? selectedWord;

  late List<WordleInput> inputLetters = generateInputs();
  Map<String, KeyState> keyStates = {};

  late List<AnimationController> animationControllers;
  late List<Animation<double>> shakeAnimations;

  late final TabController tabController;

  int guessedWordsCount = 0;

  bool gameWon = false;
  bool gameLost = false;
  bool isHintVisible = false;

  @override
  void initState() {
    super.initState();
    readJson();
    _fetchCount();
    final animationsList = <Animation<double>>[];
    animationControllers = List.generate(
      36,
      (index) {
        final controller = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 900),
        );
        animationsList.add(
          Tween<double>(begin: 1, end: 0).animate(
            CurvedAnimation(
              parent: controller,
              curve: Curves.bounceOut,
            ),
          ),
        );
        return controller;
      },
    );
    shakeAnimations = animationsList;
    tabController = TabController(length: 2, vsync: this);
  }

  // ignore: unused_element

  Future<void> readJson() async {
    final answersFetch = await rootBundle
        .loadString('packages/wordle/assets/answer_words_$selectedLang.json');
    final answersResult = await json.decode(answersFetch) as List<dynamic>;
    answerWords.clear();
    for (final word in answersResult) {
      answerWords.add(AnswerWord.fromJson(word));
    }

    final guessesFetch = await rootBundle
        .loadString('packages/wordle/assets/guess_words_$selectedLang.json');
    final guessesResult = await json.decode(guessesFetch) as List<dynamic>;

    guessWords
      ..clear()
      ..addAll(List.from(guessesResult));

    selectRandomWord();
  }

  Future<void> changeLanguage(Language lang) async {
    selectedLang = lang;
    await readJson();
    setState(resetGame);
  }

  void resetGame() {
    gameWon = false;
    gameLost = false;
    keyStates.clear();
    selectRandomWord();
    inputLetters = generateInputs();
  }

  void selectRandomWord() {
    widget.onLevelStarted();
    setState(() {
      setState(() {
        selectedWord = (answerWords..shuffle()).first;
        answerWords.shuffle();
      });
    });
  }

  List<WordleInput> generateInputs() {
    return List.generate(
      36,
      (_) => WordleInput(),
    );
  }

  void inputLetter(String letter) {
    setState(() {
      if (letter != '⌫') {
        if (!isWordComplete) {
          inputLetters.firstWhere((i) => i.letter == null).letter = letter;
        }
      } else {
        inputLetters
            .where((i) => i.letter != null && i.state == TileState.empty)
            .last
            .letter = null;
      }
    });
  }

  void submitWord(String _) {
    //* get current word from input
    final currentWordInputs = inputLetters
        .where((i) => i.letter != null && i.state == TileState.empty)
        .toList();

    //* check if word length is correct
    if (currentWordInputs.length != 6) {
      return;
    }

    //* check if word is valid

    if (![...answerWords.map((g) => g.word), ...guessWords]
        .contains(currentWordInputs.map((e) => e.letter).join())) {
      for (final input in currentWordInputs) {
        animationControllers.elementAt(inputLetters.indexOf(input))
          ..reset()
          ..forward();
        input.letter = null;
      }
      setState(() {});
      return;
    }

    for (final input in currentWordInputs) {
      //* check if guessed word contains input letter
      if (selectedWord!.letters.contains(input.letter)) {
        final index = currentWordInputs.indexOf(input);
        input.state = TileState.wrongIndex;
        keyStates[input.letter!] = KeyState.contains;
        //* check if index of letter is correct
        if (selectedWord!.letters[index] == input.letter) {
          input.state = TileState.correct;
          keyStates[input.letter!] = KeyState.correct;
        }
      } else {
        //* guess word does not contain input letter
        keyStates[input.letter!] = KeyState.wrong;
        input.state = TileState.wrong;
      }
    }
    //* check is all input letters are correct
    for (final input in currentWordInputs) {
      if (input.state != TileState.correct) {
        if (hasLost) {
          gameLost = true;
        }
        setState(() {});
        return;
      }
    }
    //* if all letter are correct show win screen
    setState(() => gameWon = true);
    _incrementCount();
    widget.onFinished(
      inputLetters.where((i) => i.state != TileState.empty).length ~/ 6,
    );
  }

  Future<void> _fetchCount() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final count = prefs.getInt('correctGuessCount');
      if (count == null) {
        await prefs.setInt('correctGuessCount', 0);
      }
      setState(
        () => guessedWordsCount = prefs.getInt('correctGuessCount')!,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _incrementCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(
      () => guessedWordsCount = (prefs.getInt('correctGuessCount') ?? 0) + 1,
    );
    await prefs.setInt('correctGuessCount', guessedWordsCount);
  }

  bool get isLoading => selectedWord == null;

  bool get hasLost {
    return inputLetters.length ==
        inputLetters.where((i) => i.state != TileState.empty).length;
  }

  bool get isWordComplete {
    final filledLettersCount = inputLetters
        .where((i) => i.letter != null && i.state == TileState.empty)
        .length;
    return filledLettersCount % 6 == 0 && filledLettersCount != 0;
  }

  bool isTileFocused(int index) {
    if (inputLetters.where((i) => i.letter == null).isEmpty) {
      return false;
    }
    return index ==
            inputLetters.indexOf(
              inputLetters.firstWhere(
                (i) => i.letter == null,
              ),
            ) &&
        !isWordComplete &&
        !gameWon &&
        !gameLost;
  }

  void _showMenu() {
    final screenSize = MediaQuery.of(scaffoldState.currentContext!).size;
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: scaffoldState.currentContext!,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        minWidth: screenSize.width,
        minHeight: screenSize.height,
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 1,
        minChildSize: 1,
        builder: (context, scrollController) => LayoutBuilder(
          builder: (context, constraints) => Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: Navigator.of(context).pop,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36),
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 32,
                    ),
                  ),
                ),
              ),
              Container(
                width: constraints.maxWidth > 1076
                    ? constraints.maxWidth * 0.5
                    : constraints.maxWidth > 576
                        ? constraints.maxWidth * 0.7
                        : constraints.maxWidth,
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    TabBar(
                      controller: tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      tabs: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffE4E4E4),
                              ),
                            ),
                          ),
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Instrukce',
                              style: TextStyle(
                                fontSize: 28,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffE4E4E4),
                              ),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Napoveda',
                              style: TextStyle(
                                fontSize: 28,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: constraints.maxWidth,
                      height: screenSize.height * 0.8 - 68,
                      child: LayoutBuilder(
                        builder: (context, constraints) => TabBarView(
                          controller: tabController,
                          children: [
                            SizedBox(
                              height: constraints.maxHeight,
                              width: constraints.maxWidth,
                              child: const SingleChildScrollView(
                                child: InstructionsView(),
                              ),
                            ),
                            SizedBox(
                              height: constraints.maxHeight,
                              width: constraints.maxWidth,
                              child: SingleChildScrollView(
                                child: Builder(
                                  builder: (context) {
                                    final chunks = <List<AnswerWord>>[];
                                    final chunkSize = answerWords.length ~/ 3;
                                    for (var i = 0;
                                        i < answerWords.length;
                                        i += chunkSize) {
                                      chunks.add(
                                        answerWords.sublist(
                                          i,
                                          i + chunkSize > answerWords.length
                                              ? answerWords.length
                                              : i + chunkSize,
                                        ),
                                      );
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 32),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: chunks
                                            .map(
                                              (ch) => Column(
                                                children: ch
                                                    .map(
                                                      (a) => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(
                                                          2,
                                                        ),
                                                        child: Text(
                                                          a.word,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldState,
      body: Padding(
        padding: screenWidth > 1078
            ? EdgeInsets.symmetric(
                vertical: 32,
                horizontal: screenWidth * 0.35,
              )
            : screenWidth > 768
                ? EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: screenWidth * 0.2,
                  )
                : const EdgeInsets.all(8),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: _showMenu,
                              child: widget.menuImage,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$guessedWordsCount',
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      if (widget.activeLangs.length > 1)
                        LanguageButton(
                          activeLangs: widget.activeLangs,
                          selectedLang: selectedLang,
                          onChangeLang: changeLanguage,
                        ),
                    ],
                  ),
                  if (kDebugMode) Text('word: ${selectedWord!.word}'),
                  if (!kDebugMode) const SizedBox(height: 12),
                  Expanded(
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 6,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      primary: true,
                      children: List.generate(
                        36,
                        (index) => ShakeAnimation(
                          controller: animationControllers[index],
                          animation: shakeAnimations[index],
                          child: WordleTile(
                            letter: inputLetters[index].letter,
                            isFocused: isTileFocused(index),
                            state: inputLetters[index].state,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (gameWon || gameLost)
                    PostGameContainer(
                      onContinue: resetGame,
                      gameWon: gameWon,
                      answerWord: selectedWord!,
                    )
                  else
                    Keyboard(
                      onTap: inputLetter,
                      onSubmitWord: submitWord,
                      canSubmit: isWordComplete,
                      keyStates: keyStates,
                      specialCharsLang: selectedLang.code,
                    ),
                ],
              ),
      ),
    );
  }
}
