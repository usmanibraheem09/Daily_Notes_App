
import 'package:daily_notes_app/screens/auth/login_screen.dart';
import 'package:daily_notes_app/services/auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotesDrawer extends StatefulWidget {
  const NotesDrawer({super.key, required Column child});

  @override
  State<NotesDrawer> createState() => _NotesDrawerState();
}

class _NotesDrawerState extends State<NotesDrawer> {

  final user= FirebaseAuth.instance.currentUser;
    
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      width: MediaQuery.of(context).size.width*0.5,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName?? 'Guest'),
            accountEmail: Text(user?.email?? 'No email availabe'),
            currentAccountPicture: CircleAvatar(
              radius: 30,
              child: Icon(Icons.person),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.white,),
            title: Text('Home', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary),),
            onTap: (){
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.star, color: Colors.white,),
            title: Text('Favourites', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary),),
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.white,),
            title: Text('LogOut', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary),),
            onTap: (){
              AuthMethods().signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=>LoginScreen()));
            },
          )
        ],
        ),
    );
  }
}