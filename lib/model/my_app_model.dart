import 'package:flutter/material.dart';
import 'dart:math' as math;

class MyAPPModel with ChangeNotifier {
  int currentQuestionCount = 1;
  List<String> quizList = [];
  List<bool> answerList = [];
  int points = 0;
  String title;
  final int maxPoint = 100;
  final int maxQuizLength = 5;
  final int maxImageLength = 10;
  final Map<int, String> titles = {0: '逆にイヌスキー', 20: '嫌犬家', 40: 'イヌスキー', 60: 'イヌラバー', 80: '飼い主', 100: '犬公方'};
  final List<String> imageTypes = ["aiken", "inu"];

  void incrementQuestionCount() {
    currentQuestionCount++;
    notifyListeners();
  }
  void resetQuestionCount() {
    currentQuestionCount = 1;
    notifyListeners();
  }

  void generateQuizList() {
    for(int count = 0; count < maxQuizLength; count++) {
      var rand1 = new math.Random();
      var rand2 = new math.Random();
      int randInt1 = rand1.nextInt(maxImageLength - 1) + 1;
      int randInt2 = rand2.nextInt(2);
      String imageType = imageTypes[randInt2];
      String fileName = imageType + randInt1.toString();
      quizList.contains(fileName) == false ? quizList.add(fileName) : count--;
    }
  }
  void resetQuizList() {
    quizList.clear();
  }

  void setAnswerList(bool isLike) {
    answerList.add(isLike);
  }
  void resetAnswerList() {
    answerList.clear();
  }

  void checkAnswer() {
    final int pointPerAnswer = maxPoint ~/ maxQuizLength;
    var answerConvertedList = answerList.map((answer) => answer == true ? imageTypes[0] : imageTypes[1]).toList();
    for(int checkCount = 0; checkCount < maxQuizLength; checkCount++) {
      if(quizList[checkCount].startsWith(answerConvertedList[checkCount])) {
        points += pointPerAnswer;
      }
    }
    title = titles[points];
  }
  void resetPoint() {
    points = 0;
  }
}