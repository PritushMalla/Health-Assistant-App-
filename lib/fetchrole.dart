import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class RoleController extends GetxController {
  var isDoctor = false.obs;
  String? currentUserUid;

  @override
  void onInit() {
    super.onInit();

    // Listen for authentication state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        getRole(); // Fetch role when user logs in
      } else {
        isDoctor.value = false; // Reset role when logged out
      }
    });

    getRole();
  }

  Future<void> getRole() async {
    try {
      currentUserUid = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserUid == null) return;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUserUid)
          .get();

      if (userDoc.exists) {
        String role = userDoc['role'];
        isDoctor.value = role == 'Doctor';
        print("User role updated: $role");
      } else {
        isDoctor.value = false;
        print("User document not found.");
      }
    } catch (e) {
      Get.snackbar('Error', '$e');
    }
  }
}
