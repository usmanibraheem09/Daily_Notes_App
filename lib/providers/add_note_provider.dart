import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NotesProvider extends ChangeNotifier {
  bool isLoading = false;
  final dbRef = FirebaseDatabase.instance.ref('notes');
  String? errorMessage;

  Future<void> addNote(String title, String description) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final newRef = dbRef.push();
      await newRef.set({
        'id': newRef.key,
        'title': title,
        'description': description,
        'createdAt': ServerValue.timestamp
      });
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteNote(String id) {
    return dbRef.child(id).remove().then((_) {
      notifyListeners();
    });
  }
}
