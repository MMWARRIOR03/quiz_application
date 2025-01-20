import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final Duration timeTaken;

  ResultScreen({
    required this.score,
    required this.totalQuestions,
    required this.timeTaken,
  });

  @override
  Widget build(BuildContext context) {
    String message;
    if (score >= (totalQuestions * 10) * 0.8) {
      message = 'Excellent!';
    } else if (score >= (totalQuestions * 10) * 0.5) {
      message = 'Good Job!';
    } else {
      message = 'Keep Practicing!';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'You scored $score out of ${totalQuestions * 10}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Time taken: ${timeTaken.inMinutes}m ${timeTaken.inSeconds % 60}s',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/quiz');
              },
              child: Text('Restart Quiz'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
