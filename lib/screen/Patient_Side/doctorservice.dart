import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorService {
  Future<List<Map<String, dynamic>>> fetchDoctors() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('role', isEqualTo: 'Doctor') // Fetch only doctors
          .get();

      return querySnapshot.docs.map((doc) {
        return {
          'id': doc.id, // Firestore document ID
          'name': doc['name'],
          'email': doc['email']
        };
      }).toList();
    } catch (e) {
      print('Error fetching doctors: $e');
      return [];
    }
  }
}
