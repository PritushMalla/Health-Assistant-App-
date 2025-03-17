import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Patientdata {
  Future<List<Map<String, dynamic>>> fetchPatients() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('role', isEqualTo: 'Patient') // Fetch only Patient users
          .get();
      return querySnapshot.docs.map((doc) {
        return {
          'id': doc.id, // Firestore document ID
          'name': doc['name'],
          'email': doc['email']
        };
      }).toList();
    } catch (e) {
      print('Error fetching conditions: $e');
      return [];
    }
  }
}
