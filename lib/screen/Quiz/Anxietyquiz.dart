import 'package:flutter/material.dart';
import 'package:mood_tracker/main.dart';

void main() => runApp(AnxietyQuizApp());

class AnxietyQuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anxiety Quiz',
      home: AnxietyQuizScreen(),
    );
  }
}

class AnxietyQuizScreen extends StatefulWidget {
  @override
  _AnxietyQuizScreenState createState() => _AnxietyQuizScreenState();
}

class _AnxietyQuizScreenState extends State<AnxietyQuizScreen> {
  // creating a list to store all the responses
  final List<int> _responses = List<int>.filled(7, 0); // GAD-7 has 7 questions
// creating a list of questions
  final List<String> _questions = [
    "Feeling nervous, anxious, or on edge?",
    "Not being able to stop or control worrying?",
    "Worrying too much about different things?",
    "Trouble relaxing?",
    "Being so restless that it's hard to sit still?",
    "Becoming easily annoyed or irritable?",
    "Feeling afraid as if something awful might happen?",
  ];

  // function to store the final (total ) score
  void _submitQuiz() {
    //reduce function is used to perform an operation using all the values of a list
    // here all the list values are added
    int totalScore = _responses.reduce((a, b) => a + b);

    String result;
    if (totalScore >= 15) {
      result = 'Severe Anxiety';
    } else if (totalScore >= 10) {
      result = 'Moderate Anxiety';
    } else if (totalScore >= 5) {
      result = 'Mild Anxiety';
    } else {
      result = 'Minimal Anxiety';
    }

    // showDialog() function is used to show dialog popups
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Quiz Result"),
        content: Text("Your anxiety score is $totalScore: $result"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AnxietyQuizApp()), // Replace with your quiz screen widget
                (route) => false, // Remove all previous routes
              );
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Anxiety Quiz")),
      drawer: Drawers(),
      body: ListView.builder(
        //itemcount is the total no. of questions in the questions list
        itemCount: _questions.length,
        // index is the index  of the current  item
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    // show the questions at the current index
                    _questions[index],
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Slider(
                  value: _responses[index].toDouble(),
                  min: 0,
                  max: 3,
                  divisions: 3,
                  label: _responses[index].toString(),
                  onChanged: (value) {
                    setState(() {
                      _responses[index] = value.toInt();
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("Not at all"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("Sometimes"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("Nearly every day"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitQuiz,
        child: Icon(Icons.check),
      ),
    );
  }
}
