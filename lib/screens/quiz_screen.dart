import 'package:flutter/material.dart';
import '../services/quiz_service.dart';
import '../models/quiz_model.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<Quiz> futureQuiz;
  Quiz? quiz;
  int currentQuestionIndex = 0;
  int score = 0;
  int streak = 0;
  late Stopwatch timer;

  @override
  void initState() {
    super.initState();
    futureQuiz = QuizService().fetchQuizData().then((data) {
      setState(() {
        quiz = Quiz.fromJson(data);
      });
      return quiz!;
    });
    timer = Stopwatch()..start();
  }

//for the next question, adds 5 points to the score if the user answers correctly three times in a row
  void nextQuestion(bool isCorrect) {
    if (isCorrect) {
      score += 10;
      streak += 1;
      if (streak >= 3) {
        score += 5; // Bonus points for streak
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Streak Bonus! +5 points')),
        );
      }
    } else {
      streak = 0;
    }

    if (currentQuestionIndex < quiz!.questions.length - 1) {
      setState(() {
        currentQuestionIndex += 1;
      });
    } else {
      timer.stop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            score: score,
            totalQuestions: quiz!.questions.length,
            timeTaken: timer.elapsed, // Pass the timeTaken argument here
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<Quiz>(
        future: futureQuiz,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (quiz != null) {
            var question = quiz!.questions[currentQuestionIndex];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinearProgressIndicator(
                    value: (currentQuestionIndex + 1) / quiz!.questions.length,
                  ),
                  SizedBox(height: 20),
                  Text(
                    question.description,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ...question.options.map((option) {
                    return ListTile(
                      title: Text(option.description),
                      leading: Radio(
                        value: option.isCorrect,
                        groupValue: null,
                        onChanged: (value) => nextQuestion(option.isCorrect),
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 20),
                  Text(
                    'Score: $score',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No Quiz Data Available'));
          }
        },
      ),
    );
  }
}
