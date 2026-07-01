import 'package:daily_notes_app/constants/constants.dart';
import 'package:daily_notes_app/screens/add_note.dart';
import 'package:daily_notes_app/screens/note_details.dart';
import 'package:daily_notes_app/services/utils.dart';
import 'package:daily_notes_app/widgets/note_card.dart';
import 'package:daily_notes_app/widgets/drawer.dart';
import 'package:daily_notes_app/widgets/input_field.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

Map<String, dynamic>? _parseNotesMap(Object? raw) {
  if (raw is! Map) return null;
  try {
    return Map<String, dynamic>.from(raw);
  } catch (_) {
    return null;
  }
}

List<MapEntry<String, dynamic>> _sortByTimeStamp(
    Map<String, dynamic> notesMap) {
  final validEntries = notesMap.entries.where((e) => e.value is Map).toList();
  validEntries.sort((a, b) {
    final aTime = (a.value as Map)[NoteFields.timestamp] ?? 0;
    final bTime = (b.value as Map)[NoteFields.timestamp] ?? 0;
    return bTime.compareTo(aTime);
  });
  return validEntries;
}

List<MapEntry<String, dynamic>> _filterNotes(
    List<MapEntry<String, dynamic>> entries, String query) {
  if (query.isEmpty) return entries;
  return entries.where((entry) {
    final v = entry.value as Map;
    final title = v[NoteFields.title]?.toString().toLowerCase() ?? '';
    final description =
        v[NoteFields.description]?.toString().toLowerCase() ?? '';
    return title.contains(query) || description.contains(query);
  }).toList();
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbref = FirebaseDatabase.instance.ref('notes');
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: Text(
          'Home Screen',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
        centerTitle: true,
      ),
      drawer: NotesDrawer(child: Column()),
      body: Center(
          child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          children: [
            TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (String value) {
                setState(() {});
              },
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: StreamBuilder<DatabaseEvent>(
                    stream: dbref.onValue,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                            child:
                                Text('Somthing went wrong: ${snapshot.error}'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final notesMap =
                          _parseNotesMap(snapshot.data?.snapshot.value);
                      if (notesMap == null || notesMap.isEmpty) {
                        return Center(
                          child: Text('No notes yet'),
                        );
                      }

                      final sorted = _sortByTimeStamp(notesMap);
                      final query = searchController.text.trim().toLowerCase();
                      final filtered = _filterNotes(sorted, query);

                      if (filtered.isEmpty) {
                        return const Center(
                            child: Text('No matching notes found'));
                      }

                      return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final id = filtered[index].key;
                            final value = Map<String, dynamic>.from(
                                filtered[index].value as Map);
                            return InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => NoteDetails(
                                            id: id,
                                          ))),
                              child: NoteCard(
                                title:
                                    value[NoteFields.title]?.toString() ?? '',
                                description:
                                    value[NoteFields.description]?.toString() ??
                                        '',
                                onEdit: () {
                                  myDialogue(
                                      value[NoteFields.title]?.toString() ?? '',
                                      id,
                                      value[NoteFields.description]
                                              ?.toString() ??
                                          '');
                                },
                                onDelete: () {
                                  dbref.child(id).remove();
                                },
                              ),
                            );
                          });
                    }))
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => AddNote()));
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> myDialogue(
    String title,
    String id,
    String description,
  ) async {
    final titleController = TextEditingController(text: title);
    final descriptionController = TextEditingController(text: description);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: const Text('Update Note'),
          content: SizedBox(
            height: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              children: [
                InputField(
                  hintText: 'Title',
                  labelText: 'Title',
                  controller: titleController,
                  keyboardType: TextInputType.text,
                  prefixIcon: Icons.title,
                ),
                const SizedBox(height: 10),
                InputField(
                  hintText: 'Description',
                  labelText: 'Description',
                  controller: descriptionController,
                  keyboardType: TextInputType.text,
                  prefixIcon: Icons.description,
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                dbref.child(id).update({
                  'title': titleController.text.trim(),
                  'description': descriptionController.text.trim(),
                }).then((value) {
                  Utils().showToast('Note was updated!');
                  Navigator.pop(context);
                });
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
