import 'package:multi_quiz_s_t_tt9/modules/true_false/question.dart';

class QuizBrain {
  int _questionNumber = 0;

  final List<Question> _questionBank = [
    Question(
      'You can lead a cow down stairs but not up stairs.',
      false,
    ),
    Question('Approximately one quarter of human bones are in the feet.', true),
    Question('A slug\'s blood is green.', true),
  ];

  String getQuestionText() {
    return _questionBank[_questionNumber].questionText;
  }

  bool getQuestionAnswer() {
    return _questionBank[_questionNumber].questionAnswer;
  }

  void nextQuestion() {
    if (_questionNumber < _questionBank.length - 1) {
      _questionNumber++;
    }
  }

  bool isFinished() {
    if (_questionNumber >= _questionBank.length - 1) {
      return true;
    } else {
      return false;
    }
  }

  int getLength() {
    return _questionBank.length;
  }

  void reset() {
    _questionNumber = 0;
  }

////
  int getQuestionNumber() {
    return _questionNumber + 1;
  }
}
