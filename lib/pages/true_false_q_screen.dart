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

  List<Icon> scoreKeeper = [];

  int? userChoice;
  bool? isCorrect;
  int score = 0;

  int counter = 10;
  late Timer timer1;
  Duration duration = const Duration(seconds: 1);

  void checkAnswer(int userChoice) {
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
          userChoice = 0;
          counter = 10;
        });
      });
    }
  }

  @override
  void initState() {
    startTimer();
    super.initState();
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
      userChoice = 0;
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
  void dispose() {
    cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      quizBrain.getQuestionText(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.green),
                    ),
                    child: const Text(
                      'True',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    onPressed: () {
                      //The user picked true.
                      checkAnswer(0);
                      // counter = 0;
                      // timer1.cancel();
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    style: const ButtonStyle().copyWith(
                      backgroundColor:
                          const MaterialStatePropertyAll(Colors.red),
                    ),
                    child: const Text(
                      'False',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      //The user picked false.
                      checkAnswer(1);
                      // counter = 0;
                      // timer1.cancel();
                    },
                  ),
                ),
              ),
              Wrap(
                children: scoreKeeper,
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 24,
              ),
              Opacity(
                opacity: userChoice != 0 ? 1.0 : 0.0,
                child: GestureDetector(
                    onTap: next,
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
