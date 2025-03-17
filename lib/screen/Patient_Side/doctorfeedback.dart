import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FeedbackListScreen extends StatefulWidget {
  const FeedbackListScreen({super.key});

  @override
  State<FeedbackListScreen> createState() => _FeedbackListScreenState();
}

class _FeedbackListScreenState extends State<FeedbackListScreen> {
  List<Map<String, dynamic>> feedbackList = [];

  @override
  void initState() {
    super.initState();
    fetchFeedbackForPatient();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Patient Feedback"),
      ),
      body: feedbackList.isEmpty
          ? Center(child: Text('No feedback found for this patient.'))
          : ListView.builder(
              itemCount: feedbackList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> feedback = feedbackList[index];
                return Card(
                  child: ListTile(
                    title: Text(feedback['Feedback']),
                    subtitle: Text('Submitted by: ${feedback['doctor name']}'),
                  ),
                );
              },
            ),
    );
  }

  Future<void> fetchFeedbackForPatient() async {
    String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    print(currentUserUid);

    try {
      // Query the Feedback collection for the patient ID (currentUserUid)
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Feedback')
          .where('PatientId', isEqualTo: currentUserUid)
          .get();

      print(querySnapshot);

      // Convert the query result into a list of feedback maps
      List<Map<String, dynamic>> feedbackData = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      print(feedbackData);

      setState(() {
        feedbackList = feedbackData;
      });
    } catch (e) {
      print("Error fetching feedback: $e");
    }
  }
}
