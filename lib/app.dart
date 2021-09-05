import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wasteagram/screens/list_screen.dart';
import 'package:wasteagram/screens/new_entry_screen.dart';

class App extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  bool _initialized = false;
  bool _error = false;

  void initState() {
    super.initState();
    initFirebase();
  }

  void initFirebase() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Journal',
        theme: ThemeData.dark(),
        routes: {
          '/': (context) => ListScreen(),
          'new_entry': (context) => NewEntryScreen(),
        }
    );
  }
}