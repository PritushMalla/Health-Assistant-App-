import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mood_tracker/models/mood_tracker/mooddata.dart';
import 'package:mood_tracker/screen/moodtracker/moodicon.dart';
import 'package:mood_tracker/main.dart';
import 'package:mood_tracker/screen/moodtracker/moodtracklist.dart';
import 'package:mood_tracker/utils/form_database/database_helper.dart';
import 'package:mood_tracker/utils/mood_tracking_database/database_helper_sec.dart';
import 'package:mood_tracker/screen/moodtracker/moodgraph.dart';
// class mymood extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(title: 'Mood Assessment', home: moody());
//   }
// }

class Mood {
  String name;
  String moodimage;
  bool iselected;
  late MoodData mooddata;

  Mood(this.moodimage, this.name, this.iselected);
}

class moody extends StatefulWidget {
  final MoodData mooddata;
  final String Apptitle;
  const moody(this.mooddata, this.Apptitle, {super.key});

  @override
  State<moody> createState() {
    return _moodState(mooddata, this.Apptitle);
  }
}

class _moodState extends State<moody> {
  TextEditingController emotionController = TextEditingController();
  TextEditingController descController = TextEditingController();
  int _selectedIndex = 0;
  List<Widget> pages = [
    moody(MoodData(' ', ' ', ''), ' '),
    Moodlist(),
  ];

  final MoodData mooddata;
  String mood = ''; // To store the selected mood title
  String image = ''; // To store the selected mood image
  int ontapcount = 0;
  DatabaseHelper_Mood databaseHelper = DatabaseHelper_Mood();

  List<Mood> moods = [
    Mood('assets/images/happy.png', 'Happy', false),
    Mood('assets/images/sad.png', 'Sad', false),
    Mood('assets/images/angry.png', 'Angry', false),
    Mood('assets/images/suprised.png', 'Surprised', false),
    Mood('assets/images/meh.png', 'Neutral', false),
  ];

  final _formKey = GlobalKey<FormState>();

  _moodState(this.mooddata, String apptitle);

  @override
  void initState() {
    super.initState();
    emotionController.text = mooddata.moodtitle;
    descController.text = mooddata.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset:false,
        appBar: AppBar(
          title: Text(
            "Mood Assessment",
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Home', icon: Icon(Icons.home)),
              Tab(text: 'Mood History', icon: Icon(Icons.people)),
              Tab(text: 'Mood Graph', icon: Icon(Icons.show_chart)),
            ],
          ),
        ),
        body: TabBarView(children: [
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'How are you feeling today',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rate your mood',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11.0,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: moods.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.all(10),
                                  child: GestureDetector(
                                    child: MoodIcon(
                                      image: moods[index].moodimage,
                                      name: moods[index].name,
                                      colour: moods[index].iselected
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        if (ontapcount == 0 &&
                                            moods[index].iselected != true) {
                                          for (var mood in moods) {
                                            mood.iselected = false;
                                          }

                                          this.mood = moods[index].name;
                                          this.image = moods[index].moodimage;
                                          moods[index].iselected = true;
                                          ontapcount = 1;
                                        } else if ((moods[index].iselected) ||
                                            ontapcount == 1) {
                                          moods[index].iselected = false;
                                          ontapcount = 0;
                                        }
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Describing how you feel',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          TextFormField(
                            controller: descController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please input your feeling';
                              }
                              return null;
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(70)
                            ],
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              hintText: "describe your feeling",
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                            ),
                            minLines: 6,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30.0),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _save(); // Save the selected mood
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                      //         Row(
                      //           children: [

                      //               pages[_selectedIndex],

                      //       ],
                      //     ),
                      //        ] ),
                    ]),
              )),
          Moodlist(),
          MoodGraph(prepareGraphData())
        ]),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> prepareGraphData() async {
    var moodDataList = await mooddbhelper.getMoodtitleMapList();
    print("Mood Data Retrieved: $moodDataList");
    List<Map<String, dynamic>> graphData = [];
    int entryIndex = 0;

    DateTime today = DateTime.now();
    for (var moodData in moodDataList) {
      String moodTitle =
          moodData['moodtitle'] as String? ?? "unknown"; // Extract mood title
      String date = moodData['date'] as String? ?? "unknown";
      DateTime moodDate = DateTime.tryParse(date) ?? DateTime.now();// Extract date
      print("Processing Mood Title: $moodTitle, Date: $date"); // Debugging line
      // Get the score for the current mood
      if (moodDate.isAfter(today.subtract(Duration(days: 7)))) {
        // Debugging output
        print("Processing Mood Title: $moodTitle, Date: $date");







      int score = getMoodScore(moodTitle);
      print("score is $score" );

      // Add the score and date to the graph data list
      graphData.add({
        'x': entryIndex++,
        'date': date,
        'score': score,
      });
    }}

    return graphData;
  }

  int getMoodScore(String moodTitle) {
    print("eval moodtitle is $moodTitle");
    // Convert to lowercase and trim
    String normalizedMoodTitle = moodTitle.toLowerCase().trim();
    print("Normalized mood title: '$normalizedMoodTitle'"); // Log normalized title

    switch (moodTitle.toLowerCase().trim()) {

      case 'happy':
        return 5;
      break;
      case 'neutral':
        return 3;
        break;
      case 'sad':
        return 1;
        break;
      case 'angry':
        return 2;
        break;
      case 'surprised':
        return 4;
        break;
      default:
        return 0;
        break;// Unknown mood
    }
  }

  void _save() async {
    if (mood.isEmpty) {
      _showAlertDialog('Status', 'Please select a mood');
      return;
    }

    mooddata.moodtitle = mood;
    mooddata.description = descController.text;

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    mooddata.date = formattedDate;

    int result;
    try {
      if (mooddata.id == null) {
        result = await databaseHelper.insertMood(mooddata);
        await databaseHelper.printSchema();
      } else {
        result = await databaseHelper.updateMood(mooddata);
      }

      if (result != 0) {
        Navigator.pop(context, true);
        _showAlertDialog('Status', 'Mood saved successfully');
      } else {
        _showAlertDialog('Status', 'Error saving mood');
      }
    } catch (e) {
      print('Error saving mood: $e'); // Log the error
      _showAlertDialog('Status', 'Error saving mood: $e');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }
}
