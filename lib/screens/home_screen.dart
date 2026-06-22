import 'package:daily_notes_app/screens/add_note.dart';
import 'package:daily_notes_app/services/utils.dart';
import 'package:daily_notes_app/widgets/drawer.dart';
import 'package:daily_notes_app/widgets/input_field.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbref = FirebaseDatabase.instance.ref('notes');
  final searchController = TextEditingController();
  final titleUpdateController = TextEditingController();
  final descUpdateController = TextEditingController();

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
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                setState(() {});
              },
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: FirebaseAnimatedList(
                  query: dbref,
                  itemBuilder: (context, snapshot, animation, index) {
                    final title = snapshot.child('title').value.toString();
                    final description =
                        snapshot.child('description').value.toString();
                    if (searchController.text.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          trailing: PopupMenuButton(
                              itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 1,
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pop(context);
                                          myDialogue(
                                              title,
                                              snapshot
                                                  .child('id')
                                                  .value
                                                  .toString(),
                                              description);
                                        },
                                        leading: Icon(Icons.edit),
                                        title: Text('Edit'),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 2,
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pop(context);
                                          dbref
                                              .child(snapshot
                                                  .child('id')
                                                  .value
                                                  .toString())
                                              .remove();
                                        },
                                        leading: Icon(Icons.delete_forever),
                                        title: Text('Delete'),
                                      ),
                                    )
                                  ]),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.black),
                          ),
                          tileColor:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          title: Text(
                            snapshot.child('title').value.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            snapshot.child('description').value.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    } else if (title
                            .toString()
                            .contains(searchController.text) ||
                        description
                            .toString()
                            .contains(searchController.text)) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          trailing: PopupMenuButton(
                              itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 1,
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pop(context);
                                          myDialogue(
                                              title,
                                              snapshot
                                                  .child('id')
                                                  .value
                                                  .toString(),
                                              description);
                                        },
                                        leading: Icon(Icons.edit),
                                        title: Text('Edit'),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 2,
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pop(context);
                                          dbref
                                              .child(snapshot
                                                  .child('id')
                                                  .value
                                                  .toString())
                                              .remove();
                                        },
                                        leading: Icon(Icons.delete_forever),
                                        title: Text('Delete'),
                                      ),
                                    )
                                  ]),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.black),
                          ),
                          tileColor:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          title: Text(
                            snapshot.child('title').value.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            snapshot.child('description').value.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
            )
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

  Future<void> myDialogue(String title, String id, String description) async {
    return showDialog(
        context: context,
        builder: (context) {
          titleUpdateController.text = title;
          descUpdateController.text = description;
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            title: Text('Update Note'),
            content: SizedBox(
              height: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                children: [
                  InputField(
                      hintText: 'Title',
                      labelText: 'Title',
                      controller: titleUpdateController,
                      keyboardType: TextInputType.text,
                      prefixIcon: Icons.title),
                  SizedBox(
                    height: 10,
                  ),
                  InputField(
                    hintText: 'Description',
                    labelText: 'Description',
                    controller: descUpdateController,
                    keyboardType: TextInputType.text,
                    prefixIcon: Icons.description,
                    maxLines: 3,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  dbref.child(id).update({
                    'title': titleUpdateController.text,
                    'description': descUpdateController.text,
                  }).then((value) {
                    Utils().showToast('Note was updated!');
                    Navigator.pop(context);
                  }).onError((error, StackTrace) {
                    Utils().showToast(error.toString());
                  });
                },
                child: Text('Update'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              )
            ],
          );
        });
  }
}
