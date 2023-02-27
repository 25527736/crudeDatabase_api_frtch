import 'package:flutter/material.dart';
import 'package:practice_app/api/api_page.dart';

import 'note_list.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  final Screens = [
    Center(
      child: Text(
        "HOME PAGE",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    ),
    NoteList(),
    ApiPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: Screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          backgroundColor: Colors.blueAccent,
          selectedItemColor: Colors.white,
          iconSize: 28,
          unselectedItemColor: Colors.white70,
          showUnselectedLabels: false,
          onTap: (index) => setState(() => currentIndex = index),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.add_card), label: "CRUD"),
            BottomNavigationBarItem(icon: Icon(Icons.cloud), label: "API"),
          ],
        ),
      ),
    );
  }
}
