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

  int? _choice;
  int? userChoice;
  bool? isCorrect;
  int score = 0;

  int counter = 10;
  late Timer timer1;
  Duration duration = const Duration(seconds: 1);

  void checkAnswer(bool userChoice) {
    bool correctAnswer = quizBrain.getQuestionAnswer();
    setState(() {
      if (correctAnswer == userChoice) {
        scoreKeeper.add(
          Icon(
            Icons.check,
            color: Colors.green,
          ),
        );
      } else {
        scoreKeeper.add(
          Icon(
            Icons.close,
            color: Colors.red,
          ),
        );
      }
    });

    if (quizBrain.isFinished()) {
      print('finished');

      timer1 = Timer(duration, () {
        // Alert(context: context, title: "Finished", desc: "you are done").show();
        setState(() {
          quizBrain.reset();
          scoreKeeper.clear();
        });
      });
    } else {
      quizBrain.nextQuestion();
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
  void dispose() {
    cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
                        // Navigator.pop(context);
                        // Navigator.pop(context);

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
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
                          color: Colors.white,
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
                        side: BorderSide(color: Colors.white)),
                  )
                ],
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      quizBrain.getQuestionText(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.green),
                    ),
                    child: Text(
                      'True',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    onPressed: () {
                      //The user picked true.
                      checkAnswer(true);
                      // counter = 0;
                      // timer1.cancel();
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    style: ButtonStyle().copyWith(
                      backgroundColor: MaterialStatePropertyAll(Colors.red),
                    ),
                    child: Text(
                      'False',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      //The user picked false.
                      checkAnswer(false);
                      // counter = 0;
                      // timer1.cancel();
                    },
                  ),
                ),
              ),
              Wrap(
                children: scoreKeeper,
              ),
              SizedBox(
                height: 72,
              )
            ],
          ),
        ),
      ),
    );
  }
}
