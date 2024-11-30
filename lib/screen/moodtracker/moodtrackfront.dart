import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mood_tracker/main.dart';
import 'package:mood_tracker/models/mood_tracker/mooddata.dart';
import 'package:mood_tracker/screen/moodtracker/mood.dart';
import 'package:mood_tracker/screen/moodtracker/moodtracklist.dart';
import 'package:sizer/sizer.dart';

class Moodfront extends StatelessWidget {
  const Moodfront({super.key});

  @override
  Widget build(BuildContext context) {
    MoodData mooddata;
    return Scaffold(
      drawer: Drawers(),
      appBar: AppBar(title: Text('Mood Tracker')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              'How Are You Feeling Today ?',
              style: TextStyle(fontSize: 40),
            ),
          ),
          Container(
            child: Image.asset("assets/images/diary.png"),
          ),
          Container(
            width: 2.inches,
            height: 70,
            child: FloatingActionButton(
                child: Text("Record Your Feelings"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (contexts) =>
                              moody(MoodData(' ', ' ', ''), ' ')));
                }),
          ),
        ],
      ),
    );
  }
}
