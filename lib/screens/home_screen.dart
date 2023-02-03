import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/screens/note_editor.dart';
import 'package:notes/screens/note_reader.dart';
import 'package:notes/style/app_style.dart';
import 'package:notes/widgts/note_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStyle.mainColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text('FireNotes'),
        centerTitle: true,
        backgroundColor: appStyle.mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your recent notes',
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22)),
            SizedBox(height: 20.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Notes')
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    // checking connection state if we still loading data we can display a progress indicator
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      return GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        children: snapshot.data!.docs
                            .map<Widget>((note) => noteCard(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NoteReaderScreen(note),
                                      ));
                                }, note))
                            .toList(),
                      );
                    }

                    return Text(
                      "There are no notes",
                      style: GoogleFonts.nunito(color: Colors.white),
                    );
                  }),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NoteEditorScreen()));
          },
          label: Text("Add Note"),
          icon: Icon(Icons.add)),
    );
  }
}
