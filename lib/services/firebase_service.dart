import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Auth helpers
  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> createUserWithEmail(
      String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  // Firestore helpers (basic example for `notes` collection)
  CollectionReference<Map<String, dynamic>> get notesCollection =>
      _firestore.collection('notes');

  Future<DocumentReference<Map<String, dynamic>>> addNote(
      Map<String, dynamic> data) async {
    return await notesCollection.add(data);
  }

  Future<void> setNote(String id, Map<String, dynamic> data) async {
    await notesCollection.doc(id).set(data, SetOptions(merge: true));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> notesStreamForUser(String uid) {
    return notesCollection.where('uid', isEqualTo: uid).snapshots();
  }

  Future<void> deleteNote(String id) async {
    await notesCollection.doc(id).delete();
  }

  // Generic helpers for reminders
  CollectionReference<Map<String, dynamic>> get remindersCollection =>
      _firestore.collection('reminders');

  Future<DocumentReference<Map<String, dynamic>>> addReminder(
      Map<String, dynamic> data) async {
    return await remindersCollection.add(data);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> remindersStreamForUser(
      String uid) {
    return remindersCollection.where('uid', isEqualTo: uid).snapshots();
  }
}
