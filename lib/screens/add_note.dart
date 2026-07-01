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
  bool isEnabled = false;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Consumer<NotesProvider>(
            builder: (context, notesProvider, child) {
              return Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    children: [
                      Column(
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
                            maxLines: 2,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: Colors.black)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Enable Reminder',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Switch(
                                    value: isEnabled,
                                    onChanged: (value) => {
                                          setState(() {
                                            isEnabled = value;
                                          })
                                        }),
                              ],
                            ),
                            if (isEnabled) ...[
                              SizedBox(height: 10),
                              Text(selectedDate == null
                                  ? 'Reminder is enabled'
                                  : 'Reminder set for ${selectedDate!.toLocal().toString().split(' ')[0]}'),
                              const SizedBox(
                                height: 10,
                              ),
                              OutlinedButton(
                                  onPressed: () async {
                                    await _pickDate();

                                    if (selectedDate != null) {
                                      await _pickTime();
                                    }
                                  },
                                  child: Text('Pick Date'))
                            ]
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
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
                              SnackBar(
                                  content: Text(notesProvider.errorMessage!)),
                            );
                          } else {
                            Navigator.pop(context);
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
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }
}
