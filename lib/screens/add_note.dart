import 'package:daily_notes_app/services/utils.dart';
import 'package:daily_notes_app/widgets/input_field.dart';
import 'package:daily_notes_app/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

  final titleController= TextEditingController();
  final descriptionController= TextEditingController();
  bool isLoading= false;
  final dbRef = FirebaseDatabase.instance.ref('notes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new, color: Colors.white,)),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: Text('Add Note', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onPrimary),),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          width: MediaQuery.of(context).size.width* 0.9,
          child: Column(
            children: [
              InputField(
              hintText: 'Add Title', 
              labelText: 'Title', 
              controller: titleController, 
              keyboardType: TextInputType.text, 
              prefixIcon: Icons.title
              ),
              SizedBox(height: 15,),
              InputField(
              hintText: 'Enter Description', 
              labelText: 'Description', 
              controller: descriptionController, 
              keyboardType: TextInputType.text, 
              prefixIcon: Icons.description,
              maxLines: 3,
              ),
              SizedBox(height: 15,),
              RoundButton(
                isLoading: isLoading,
                onTap: () {
                  setState(() {
                  isLoading= true;
                });
                String id= DateTime.now().millisecondsSinceEpoch.toString();
                dbRef.child(id).set({
                  'id': id,
                  'title': titleController.text.toString(),
                  'description': descriptionController.text.toString(),
                }).then((value){
                  Navigator.pop(context);
                  setState(() {
                    isLoading= false;
                  });
                }).onError((error, StackTrace){
                  Utils().showToast(error.toString());
                  setState(() {
                    isLoading= false;
                  });
                });
                },
                btnText: 'Add Note', 
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                
                )
            ],
          ),
        ),
      ),
    );
  }
  Future<void> addNote() async {
    String id= DateTime.now().millisecondsSinceEpoch.toString();
    dbRef.child(id).set({
      'id': id,
      'title': titleController.text.toString(),
      'description': descriptionController.text.toString(),
    });
  }
}