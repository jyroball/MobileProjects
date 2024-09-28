class QuizQuestion {

  const QuizQuestion(this.text, this.answers);

  final String text;
  final List<String> answers;

  //shuffle() method changes original list so make a method to keep original list
  List<String> getShuffledAnswers() {

    //coppies list then shuffles
    final shuffledList = List.of(answers);
    shuffledList.shuffle();

    return shuffledList;

  }

}