import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create or Update
  Future<void> addUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _db.collection('users').doc(uid).set(data, SetOptions(merge: true));
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  // Read (Stream)
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserData(String uid) {
    return _db.collection('users').doc(uid).snapshots();
  }

  // Read (Future)
  Future<Map<String, dynamic>?> fetchUserData(String uid) async {
    try {
      var doc = await _db.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }

  // Delete
  Future<void> deleteUserData(String uid) async {
    try {
      await _db.collection('users').doc(uid).delete();
    } catch (e) {
      print('Error deleting data: $e');
    }
  }
}
