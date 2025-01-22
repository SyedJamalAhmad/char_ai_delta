import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirestoreService _instance =
      FirestoreService._internal(); // Singleton instance

  factory FirestoreService() {
    // Factory constructor for access
    return _instance;
  }
  FirestoreService._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'premiumUsers'; // Customizable collection path
  final String _historySubcollectionPath =
      'history'; // Customizable subcollection path

  String UserID = "temp";
}
