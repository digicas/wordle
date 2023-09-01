import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordle/app_locale.dart';
import 'package:wordle/game/view/widgets/keyboard.dart';
import 'package:wordle/game/view/widgets/language_button.dart';
import 'package:wordle/game/view/widgets/post_game_container.dart';
import 'package:wordle/game/view/widgets/shake_animation.dart';
import 'package:wordle/game/view/widgets/wordle_tile.dart';
import 'package:wordle/instruction/view/instructions_page.dart';

import 'package:wordle/models/answer_word.dart';
import 'package:wordle/models/wordle_input.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.activeLangs,
    required this.onFinished,
    required this.onLevelStarted,
    required this.menuImage,
    required this.langsWithHints,
    required this.showTranslation,
  });

  final List<Language> activeLangs;
  final List<Language> langsWithHints;
  final void Function(int) onFinished;
  final void Function() onLevelStarted;
  final Image menuImage;
  final bool showTranslation;

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

    _loadAnimationControllers();

    tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  // ignore: unused_element

  void _loadAnimationControllers() {
    final animationsList = <Animation<double>>[];
    animationControllers = List.generate(
      tilesCount * 6,
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

    print(shakeAnimations.length);
  }

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
    _loadAnimationControllers();
    await Future<void>.delayed(const Duration(milliseconds: 100));
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
      tilesCount * 6,
      (_) => WordleInput(),
    );
  }

  void inputLetter(String letter) {
    if (letter == '') return;
    setState(() {
      if (letter != '⌫') {
        if (!isWordComplete) {
          inputLetters.firstWhere((i) => i.letter == null).letter = letter;
        }
      } else {
        final usedTiles = inputLetters
            .where((i) => i.letter != null && i.state == TileState.empty);
        if (usedTiles.isNotEmpty) {
          usedTiles.last.letter = null;
        }
      }
    });
  }

  void submitWord() {
    //* get current word from input
    final currentWordInputs = inputLetters
        .where((i) => i.letter != null && i.state == TileState.empty)
        .toList();

    //* check if word length is correct
    if (currentWordInputs.length != tilesCount) {
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

      if (selectedWord!.letters.contains(input.letter!.toLowerCase())) {
        final index = currentWordInputs.indexOf(input);

        if (keyStates[input.letter!] != KeyState.correct) {
          keyStates[input.letter!] = KeyState.contains;
        }
        if (selectedWord!.charCount(input.letter!) >
            currentWordInputs
                .where(
                  (i) =>
                      i.letter == input.letter &&
                      (i.state == TileState.wrongIndex ||
                          i.state == TileState.correct),
                )
                .length) {
          input.state = TileState.wrongIndex;
        }
        //* check if index of letter is correct

        if (selectedWord!.letters[index] == input.letter) {
          if (currentWordInputs
                  .where((i) =>
                      i.letter == input.letter &&
                      (i.state == TileState.wrongIndex ||
                          i.state == TileState.correct))
                  .length >=
              selectedWord!.charCount(input.letter!)) {
            currentWordInputs.reversed
                .firstWhere(
                  (i) =>
                      i.letter == input.letter &&
                      i.state == TileState.wrongIndex,
                )
                .state = TileState.wrong;
          }
          input.state = TileState.correct;
          keyStates[input.letter!] = KeyState.correct;
        } else if (input.state == TileState.empty) {
          input.state = TileState.wrong;
        }
      } else {
        //* guess word does not contain input letter
        keyStates[input.letter!] = KeyState.wrong;
        input.state = TileState.wrong;
      }
    }
    //* check is all input letters are correct
    for (final input in currentWordInputs) {
      if (input.state == TileState.empty) {
        input.state = TileState.wrong;
      }
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
      inputLetters.where((i) => i.state != TileState.empty).length ~/
          tilesCount,
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
    return filledLettersCount % tilesCount == 0 && filledLettersCount != 0;
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

  int get tilesCount => selectedLang == Language.german ? 6 : 5;

  double sizePadding(double size) {
    if (size > 3500) return size / 2;
    if (size > 1800) return size / 3;
    if (size > 976) return size / 4;
    if (size > 576) return 32;
    if (size > 476) return 16;
    return 4;
  }

  void _showMenu() {
    final screenSize = MediaQuery.of(scaffoldState.currentContext!).size;
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: scaffoldState.currentContext!,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      // barrierColor: Colors.red,
      builder: (context) => LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: Navigator.of(context).pop,
          child: Container(
            width: constraints.maxWidth,
            color: Colors.transparent,
            child: Column(
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
                GestureDetector(
                  onTap: () {},
                  child: Container(
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
                    child: widget.langsWithHints.contains(selectedLang)
                        ? Column(
                            children: [
                              TabBar(
                                controller: tabController,
                                physics: const NeverScrollableScrollPhysics(),
                                tabs: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Color(0xffE4E4E4),
                                        ),
                                      ),
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        AppLocale.howToPlay.getString(context),
                                        style: const TextStyle(
                                          fontSize: 28,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Color(0xffE4E4E4),
                                        ),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        AppLocale.hint.getString(context),
                                        style: const TextStyle(
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
                                        child: SingleChildScrollView(
                                          child: InstructionsView(
                                            activeLang: selectedLang,
                                            showTranslate:
                                                widget.showTranslation,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: constraints.maxHeight,
                                        width: constraints.maxWidth,
                                        child: SingleChildScrollView(
                                          child: Builder(
                                            builder: (context) {
                                              final chunks =
                                                  <List<AnswerWord>>[];
                                              final chunkSize =
                                                  answerWords.length ~/ 3;
                                              for (var i = 0;
                                                  i < answerWords.length;
                                                  i += chunkSize) {
                                                chunks.add(
                                                  answerWords.sublist(
                                                    i,
                                                    i + chunkSize >
                                                            answerWords.length
                                                        ? answerWords.length
                                                        : i + chunkSize,
                                                  ),
                                                );
                                              }
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 32,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
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
                                                                      fontSize:
                                                                          18,
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
                          )
                        : SingleChildScrollView(
                            child: InstructionsView(
                              activeLang: selectedLang,
                              showTranslate: widget.showTranslation,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
        //   ),
        // ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldState,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              width: size.width,
              height: size.height,
              child: Column(
                children: [
                  SizedBox(
                    width: size.width,
                    height: size.height,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 52,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: _showMenu,
                                    child: Row(
                                      children: [
                                        widget.menuImage,
                                        const SizedBox(width: 4),
                                        Text(
                                          // '$guessedWordsCount',
                                          AppLocale.rules.getString(context),
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (guessedWordsCount > 0)
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
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
                          ),
                        ),
                        if (kDebugMode)
                          Text(
                            'word: ${selectedWord!.word}',
                            style: const TextStyle(fontSize: 8),
                          ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: sizePadding(size.width),
                              ),
                              child: Column(
                                children: List.generate(
                                  6,
                                  (index) => LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children:
                                            List.generate(tilesCount, (i) {
                                          final currentIndex =
                                              i + (index * tilesCount);
                                          return ShakeAnimation(
                                            controller: animationControllers[i],
                                            animation: shakeAnimations[i],
                                            child: Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: WordleTile(
                                                letter:
                                                    inputLetters[currentIndex]
                                                        .letter,
                                                isFocused:
                                                    isTileFocused(currentIndex),
                                                state:
                                                    inputLetters[currentIndex]
                                                        .state,
                                                size: Size(
                                                  constraints.maxWidth /
                                                      (tilesCount + 1),
                                                  70,
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      );
                                    },
                                  ),
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
                            showTranslation: widget.showTranslation,
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
                ],
              ),
            ),
    );
  }
}
