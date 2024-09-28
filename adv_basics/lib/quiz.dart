import 'package:adv_basics/questions_screen.dart';
import 'package:adv_basics/results_screen.dart';
import 'package:flutter/material.dart';
import 'package:adv_basics/start_screen.dart';
import 'package:adv_basics/data/questions.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  //no build method if stateful widget
  @override
  State<Quiz> createState() {
    return _QuizState();
  }

}

// "_" means that class is a private class for the file
class _QuizState extends State<Quiz> {
  //nullable widget for now when intializing
  Widget? activeScreen;
  List<String> selectedAnswers = [];

  //Starts an initialization logic when objects are created
  @override
  void initState() {
    //change widets, make sure variable is a widget since var sets it as a StartScreen object
    activeScreen = StartScreen(switchScreen);
    super.initState();
  }

  //methods
  void switchScreen() {
    setState(() {
      activeScreen = QuestionsScreen(onSelectAnswer: chooseAnswer);
    });
  }

  void chooseAnswer(String answer) {
    selectedAnswers.add(answer);

    if(selectedAnswers.length == questions.length) {
      setState(() {
        activeScreen = ResultsScreen(chooseAnswer: selectedAnswers, onRestart: restartQuiz,);
      });
    }
  }

  void restartQuiz() {
    setState(() {
      //restart answers
      selectedAnswers = [];
      activeScreen = StartScreen(switchScreen);
    });
  }

  @override
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                 Color.fromARGB(255, 76, 8, 159),
                 Color.fromARGB(255, 111, 18, 252)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
              ),
            ),
          child: activeScreen,
        ),
      ),
    );
  }
}