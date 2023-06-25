import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../modules/true_false/quizBrain.dart';
import '../widgets/my_outline_btn.dart';
import 'home.dart';

class TrueFalseQuiz extends StatefulWidget {
  const TrueFalseQuiz({super.key});

  @override
  _TrueFalseQuizState createState() => _TrueFalseQuizState();
}

class _TrueFalseQuizState extends State<TrueFalseQuiz> {
  QuizBrain quizBrain = QuizBrain();
  // final player = AudioPlayer(); //
  List<Icon> scoreKeeper = [];
  int score = 0;
  int counter = 10;
  bool? isCorrect;
  bool? userChoice;
  late Timer timer;
  Color favColor = Colors.white;
  double favScal = 1;
  bool counterFinished = false;

  bool showCorrectAnswer = false;

  void checkAnswer() {
    bool correctAnswer = quizBrain.getQuestionAnswer();
    cancelTimer();
    setState(() {
      if (correctAnswer == userChoice) {
        score++;
        print('Score $score');
        isCorrect = true;
        setState(() {
          favScal = 2;
          Timer(Duration(milliseconds: 300), () {
            setState(() {
              favScal = 1;
            });
          });
          Timer(Duration(milliseconds: 1000), () {
            setState(() {
              favColor = Colors.white;
            });
          });

          scoreKeeper.add(
            const Icon(
              Icons.check,
              color: Colors.lightGreen,
              size: 24,
            ),
          );
        });
      } else {
        isCorrect = false;
        scoreKeeper.add(
          const Icon(
            Icons.close,
            color: Colors.redAccent,
            size: 24,
          ),
        );
      }
    });

    if (quizBrain.isFinished()) {
      cancelTimer();
      Timer(Duration(seconds: 1), () {
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
      alert();
      setState(() {
        quizBrain.reset();
        scoreKeeper.clear();
        isCorrect = null;
        userChoice = null;
        counter = 10;
      });
    } else {
      setState(() {
        counterFinished = false;
      });
      counter = 10;
      startTimer();
      setState(() {
        isCorrect = null;
        userChoice = null;
        quizBrain.nextQuestion();
      });
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      setState(() {
        counter--;
      });

      if (counter == 0 && userChoice == null) {
        counterFinished = true;

        timer.cancel();

        // next();
      }
    });
  }

  void cancelTimer() {
    timer.cancel();
  }

  void alert() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Finished',
      desc: 'Score : $score / ${quizBrain.getLength()} ',
      btnOkOnPress: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
          (route) => false,
        );
      },
    ).show();
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kBlueIcon,
              kL2,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 56, left: 20, right: 20, bottom: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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
                        style: TextStyle(
                          fontFamily: 'Sf-Pro-Text',
                          fontSize: 24,
                          color: counter <= 5 ? Colors.redAccent : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white,
                    ),
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        side: const BorderSide(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'question ${quizBrain.getQuestionNumber()} of ${quizBrain.getLength()} ',
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Sf-Pro-Text',
                  color: Colors.white60,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                // maxFontSize: 42,
                quizBrain.getQuestionText(),
                style: const TextStyle(
                  fontSize: 30,
                  fontFamily: 'Sf-Pro-Text',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  onTap: counterFinished
                      ? null
                      : userChoice == null
                          ? () {
                              // print("Index:$index");
                              userChoice = true;
                              checkAnswer();
                            }
                          : null,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                            colors: userChoice != null
                                ? (isCorrect! && userChoice == true)
                                    ? [Colors.green, Colors.green]
                                    : userChoice == true
                                        ? [Colors.red, Colors.red]
                                        : [Colors.white54, Colors.white54]
                                : showCorrectAnswer &&
                                        quizBrain.getQuestionAnswer()
                                    ? [kL3, kL32]
                                    : [Colors.white, Colors.white],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 24,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'True',
                              style: TextStyle(
                                  color: userChoice != null
                                      ? userChoice == true
                                          ? Colors.white
                                          : kL2
                                      : kL2,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                        Icon(
                          userChoice == null
                              ? null
                              : isCorrect! && userChoice == true
                                  ? Icons.check
                                  : userChoice == true
                                      ? Icons.close
                                      : null,
                          color: userChoice != null
                              ? userChoice == true
                                  ? Colors.white
                                  : null
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  // False choice
                  onTap: counterFinished
                      ? null
                      : userChoice == null
                          ? () {
                              // print("Index:$index");
                              userChoice = false;
                              checkAnswer();
                            }
                          : null,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                            colors: userChoice != null
                                ? (isCorrect! && userChoice == false)
                                    ? [Colors.green, Colors.green]
                                    : userChoice == false
                                        ? [Colors.red, Colors.red]
                                        : [Colors.white54, Colors.white54]
                                : showCorrectAnswer &&
                                        !quizBrain.getQuestionAnswer()
                                    ? [Colors.grey, Colors.grey]
                                    : [Colors.white, Colors.white],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 24,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'False',
                              style: TextStyle(
                                  color: userChoice != null
                                      ? userChoice == false
                                          ? Colors.white
                                          : kL2
                                      : kL2,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                        Icon(
                          userChoice == null
                              ? null
                              : isCorrect! && userChoice == false
                                  ? Icons.check
                                  : userChoice == false
                                      ? Icons.close
                                      : null,
                          color: userChoice != null
                              ? userChoice == false
                                  ? Colors.white
                                  : null
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Wrap(
                children: scoreKeeper,
              ),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      next();
                    },
                    child: Text(
                      (userChoice != null && !quizBrain.isFinished() ||
                              userChoice == null && counter == 0)
                          ? userChoice == null &&
                                  counter == 0 &&
                                  quizBrain.isFinished()
                              ? 'Next'
                              : 'Next'
                          : '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
//////
