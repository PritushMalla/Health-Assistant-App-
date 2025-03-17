import 'package:cloud_firestore/cloud_firestore.dart';

class Condition {
  Future<List<Map<String, dynamic>>> fetchConditions(id) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Condition')
          .where('userId', isEqualTo: id) // Fetch only Patient users
          .get();
      return querySnapshot.docs.map((doc) {
        return {
          // Firestore document ID
          'Name': doc['Name'],
          'Condition': doc['Condition'],
          'userId': doc.id,
          'timestamp': doc['timestamp']
        };
      }).toList();
    } catch (e) {
      print('Error fetching conditions: $e');
      return [];
    }
  }
}
