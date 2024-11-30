import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mood_tracker/main.dart';

class Depressionquiz extends StatelessWidget {
  const Depressionquiz({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Depression Quiz',
      home: DepressionQuizScreen(),
    );
  }
}

class DepressionQuizScreen extends StatefulWidget {
  const DepressionQuizScreen({super.key});

  @override
  State<DepressionQuizScreen> createState() => _DepressionQuizScreenState();
}

class _DepressionQuizScreenState extends State<DepressionQuizScreen> {
  double? _sliderValue;
  final List<int> _responses = List<int>.filled(20, 0); // GAD-7 has 7 questions
// creating a list of questions
  final List<String> _questions = [
    " I generally feel down and unhappy.",
    " I have less interest in other people than I used to.",
    "It takes a lot of effort to start working on something new.",
    "I don't get as much satisfaction out of things as I used to.?",
    " I have headaches or back pain for no apparent reason",
    " I easily get impatient, frustrated, or angry",
    "I feel lonely, and that people aren't that interested in me.",
    "I feel like I have nothing to look forward to.",
    "I have episodes of crying that are hard to stop.",
    "I have trouble getting to sleep or I sleep in too late.",
    "I feel like my life has been a failure or a disappointment.",
    "I have trouble staying focused on what I'm supposed to be doing.",
    "I blame myself for my faults and mistakes.",
    "I feel like I've slowed down; sometimes I don't have the energy to get anything done.",
    "I have trouble finishing books, movies, or TV shows.",
    "I put off making decisions more often than I used to.",
    "When I feel down, friends and family can't cheer me up.",
    "I think about people being better off without me.",
    " I'm eating much less (or much more) than normal and it's affecting my weight.",
    "I have less interest in Physical Activities than I used to and feel lethargic ",
  ];
  void _submitQuiz() {
    //reduce function is used to perform an operation using all the values of a list
    // here all the list values are added
    int totalScore = _responses.reduce((a, b) => a + b);

    String result;
    if (totalScore >= 81) {
      result = 'Extremely Severe Depression';
    } else if (totalScore >= 61) {
      result = 'Severe Depression';
    } else if (totalScore >= 41) {
      result = 'Moderate depression';
    } else if (totalScore >= 21) {
      result = 'Mild depression';
    } else
      result = 'Minimal or no depression';

    // showDialog() function is used to show dialog popups
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Quiz Result"),
        content: Text("Your depression score is $totalScore: $result"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DepressionQuizScreen()), // Replace with your quiz screen widget
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
      appBar: AppBar(title: Text("Depression Quiz")),
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
                  max: 5,
                  divisions: 5,
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
                      child: Text("Disagree"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("agree"),
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
