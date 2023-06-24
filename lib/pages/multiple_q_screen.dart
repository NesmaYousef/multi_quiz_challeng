import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:multi_quiz_s_t_tt9/modules/multipe_choice/quizBrainMultiple.dart';
import 'package:multi_quiz_s_t_tt9/pages/home.dart';
import 'package:multi_quiz_s_t_tt9/widgets/my_outline_btn.dart';

import '../constants.dart';

class MultiQScreen extends StatefulWidget {
  const MultiQScreen({Key? key}) : super(key: key);

  @override
  State<MultiQScreen> createState() => _MultiQScreenState();
}

class _MultiQScreenState extends State<MultiQScreen> {
  int counter = 10;
  late Timer timer1;
  Duration duration = const Duration(seconds: 1);

  int? userChoice;
  bool? isCorrect;
  bool? isFinal;
  List<Icon> scoreKeeper = [];
  int score = 0;

  QuizBrainMulti quizBrain = QuizBrainMulti();

  void checkAnswer() {
    int correctAnswer = quizBrain.getQuestionAnswer();
    cancelTimer();
    setState(() {
      if (correctAnswer == userChoice) {
        isCorrect = true;
        score++;

        scoreKeeper.add(
          const Icon(
            Icons.check,
            color: Colors.green,
          ),
        );
      } else {
        isCorrect = false;
        scoreKeeper.add(
          const Icon(
            Icons.close,
            color: Colors.red,
          ),
        );
      }
    });

    if (quizBrain.isFinished()) {
      print('finished');
      cancelTimer();

      Timer(const Duration(seconds: 1), () {
        alert();
        setState(() {
          quizBrain.reset();
          scoreKeeper.clear();
          isCorrect = null;
          userChoice = null;
          counter = 10;
        });
      });
    }
  }

  void next() {
    if (quizBrain.isFinished()) {
      print('finished, score is $score');
      cancelTimer();
      alert();
    } else {
      counter = 10;
      startTimer();
    }
    setState(() {
      isCorrect = null;
      userChoice = null;
      quizBrain.nextQuestion();
    });
  }

  void startTimer() {
    timer1 = Timer.periodic(duration, (timer) {
      setState(() {
        counter--;
      });
      if (counter == 0) {
        next();
      }
    });
  }

  void cancelTimer() {
    timer1.cancel();
  }

  void alert() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.rightSlide,
      title: 'Finished',
      desc: 'Score : $score / ${quizBrain.getLength()} ',
      btnOkOnPress: () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      },
    ).show();
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var questionNumber = 5;
    // var questionsCount = 10;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kBlueBg,
              kL2,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 74, left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 44,
                    width: 44,
                    child: MYOutlineBtn(
                      icon: Icons.close,
                      iconColor: Colors.white,
                      bColor: Colors.white,
                      function: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 56,
                        width: 56,
                        child: CircularProgressIndicator(
                          value: counter / 10,
                          color: Colors.white,
                          backgroundColor: Colors.white12,
                        ),
                      ),
                      Text(
                        counter.toString(),
                        style: const TextStyle(
                          fontFamily: 'Sf-Pro-Text',
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        side: const BorderSide(color: Colors.white)),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              Expanded(
                child: Center(
                  child: Image.asset('assets/images/ballon-b.png'),
                ),
              ),
              Text(
                'question ${quizBrain.getQuestionNumber()} of ${quizBrain.getLength()} ',
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Sf-Pro-Text',
                  color: Colors.white60,
                ),
              ),
              Center(
                child: Text(
                  quizBrain.getQuestionText(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32.0,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: quizBrain.getOptions().length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ElevatedButton(
                          onPressed: userChoice == null
                              ? () {
                                  userChoice = index;
                                  checkAnswer();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            disabledBackgroundColor: isCorrect == null
                                ? Colors.white60
                                : isCorrect! && userChoice == index
                                    ? Colors.green
                                    : userChoice == index
                                        ? Colors.red
                                        : Colors.white60,
                            backgroundColor: isCorrect == null
                                ? Colors.white
                                : isCorrect! && userChoice == index
                                    ? Colors.green
                                    : userChoice == index
                                        ? Colors.red
                                        : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  quizBrain.getOptions()[index],
                                  style: const TextStyle(
                                      color: kL2,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ),
                              isCorrect == null
                                  ? const SizedBox()
                                  : isCorrect! && userChoice == index
                                      ? const Icon(Icons.check_rounded)
                                      : userChoice == index
                                          ? const Icon(Icons.close)
                                          : const SizedBox(),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              Row(
                children: scoreKeeper,
              ),
              const SizedBox(
                height: 24,
              ),
              Opacity(
                opacity: userChoice != null ? 1.0 : 0.0,
                child: GestureDetector(
                    onTap: next,
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
              ),
              const SizedBox(
                height: 24,
              )
            ],
          ),
        ),
      ),
    );
  }
}
