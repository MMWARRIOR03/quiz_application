class Quiz {
  final String title;
  final List<Question> questions;

  Quiz({required this.title, required this.questions});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    var questionList = json['questions'] as List;
    List<Question> questions =
        questionList.map((q) => Question.fromJson(q)).toList();
    return Quiz(title: json['title'], questions: questions);
  }
}

class Question {
  final String description;
  final List<Option> options;

  Question({required this.description, required this.options});

  factory Question.fromJson(Map<String, dynamic> json) {
    var optionList = json['options'] as List;
    List<Option> options = optionList.map((o) => Option.fromJson(o)).toList();
    return Question(description: json['description'], options: options);
  }
}

class Option {
  final String description;
  final bool isCorrect;

  Option({required this.description, required this.isCorrect});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
        description: json['description'], isCorrect: json['is_correct']);
  }
}
