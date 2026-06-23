import 'package:daily_notes_app/providers/add_note_provider.dart';
import 'package:daily_notes_app/widgets/input_field.dart';
import 'package:daily_notes_app/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: Text(
          'Add Note',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
        centerTitle: true,
      ),
      body: Consumer<NotesProvider>(
        builder: (context, notesProvider, child) {
          return Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                children: [
                  InputField(
                      hintText: 'Add Title',
                      labelText: 'Title',
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      prefixIcon: Icons.title),
                  SizedBox(
                    height: 15,
                  ),
                  InputField(
                    hintText: 'Enter Description',
                    labelText: 'Description',
                    controller: descriptionController,
                    keyboardType: TextInputType.text,
                    prefixIcon: Icons.description,
                    maxLines: 3,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RoundButton(
                    isLoading: notesProvider.isLoading,
                    onTap: () async {
                      if (titleController.text.isEmpty ||
                          descriptionController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please fill all fields')),
                        );
                        return;
                      }
                      await notesProvider.addNote(
                          titleController.text, descriptionController.text);
                      if (!context.mounted) return;
                      if (notesProvider.errorMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(notesProvider.errorMessage!)),
                        );
                      } else {
                        Navigator.pop(context); // success
                      }
                    },
                    btnText: 'Add Note',
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
