import 'package:daily_notes_app/constants/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NoteDetails extends StatelessWidget {
  const NoteDetails({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final noteRef = FirebaseDatabase.instance.ref('notes').child(id);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
        ),
        title: Text(
          'Note Details',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: noteRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final raw = snapshot.data?.snapshot.value;
          if (raw == null) {
            return const Center(child: Text('Note not found'));
          }

          final value = Map<String, dynamic>.from(raw as Map);
          final title = value[NoteFields.title]?.toString() ?? '';
          final description = value[NoteFields.description]?.toString() ?? '';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                titleCase(title),
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ).copyWith(),
                ),
                const SizedBox(height: 6),
                Text(
                  capitalize(description),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ).copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}