import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Get current user ID
  String? get userId => _auth.currentUser?.uid;

  /// Sign in user anonymously if not already signed in
  Future<UserCredential?> signInAnonymously() async {
    try {
      if (_auth.currentUser == null) {
        final credential = await _auth.signInAnonymously();
        return credential;
      }
      return null;
    } catch (e) {
      debugPrint("FirebaseService: Error signing in anonymously: $e");
      return null;
    }
  }

  /// Reference to the current user's document path
  DocumentReference get _userDocRef {
    final uid = userId;
    if (uid == null) {
      throw StateError("Cannot get user document reference when user is not signed in.");
    }
    return _db.collection('artifacts').doc('tawazon-95f97').collection('users').doc(uid);
  }

  /// Saves the daily mood selection
  Future<void> saveMood(String moodLabel, String emoji) async {
    try {
      final uid = userId;
      if (uid == null) return;
      
      await _userDocRef.collection('moods').add({
        'mood': moodLabel,
        'emoji': emoji,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("FirebaseService: Error saving mood: $e");
      rethrow;
    }
  }

  /// Saves a journal entry (both text entry and simulated voice recording text logs)
  Future<void> saveJournal({
    required String type, // 'text' or 'voice'
    required String content,
    int? durationSeconds,
  }) async {
    try {
      final uid = userId;
      if (uid == null) return;

      await _userDocRef.collection('journals').add({
        'type': type,
        'content': content,
        'durationSeconds': durationSeconds,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("FirebaseService: Error saving journal: $e");
      rethrow;
    }
  }

  /// Reads current lesson states from Firestore on load.
  /// Returns a Set of completed lesson indices.
  Future<Set<int>> getCompletedLessons() async {
    try {
      final uid = userId;
      if (uid == null) return {};

      final snapshot = await _userDocRef.collection('cbtProgress').get();
      final completed = <int>{};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data['completed'] == true) {
          final index = int.tryParse(doc.id);
          if (index != null) {
            completed.add(index);
          }
        }
      }
      return completed;
    } catch (e) {
      debugPrint("FirebaseService: Error loading CBT progress: $e");
      return {};
    }
  }

  /// Saves/updates CBT progress to Firestore on completion state toggle
  Future<void> saveCbtProgress(int lessonIndex, bool completed) async {
    try {
      final uid = userId;
      if (uid == null) return;

      await _userDocRef
          .collection('cbtProgress')
          .doc(lessonIndex.toString())
          .set({
        'completed': completed,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("FirebaseService: Error saving CBT progress: $e");
      rethrow;
    }
  }

  /// Deletes all Firestore documents under `/artifacts/tawazon-95f97/users/{userId}` to honor data privacy
  Future<void> deleteUserData() async {
    try {
      final uid = userId;
      if (uid == null) return;

      final docRef = _userDocRef;

      // Helper function to delete all documents in a subcollection
      Future<void> deleteCollection(String name) async {
        final snap = await docRef.collection(name).get();
        for (var doc in snap.docs) {
          await doc.reference.delete();
        }
      }

      await deleteCollection('moods');
      await deleteCollection('journals');
      await deleteCollection('cbtProgress');
      await deleteCollection('quiz_results');
      await docRef.delete();
    } catch (e) {
      debugPrint("FirebaseService: Error deleting user data: $e");
      rethrow;
    }
  }
}
