import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/screens/update_screen.dart';
import 'package:notes/style/app_style.dart';

class NoteReaderScreen extends StatefulWidget {
  NoteReaderScreen(this.doc, {super.key});
  QueryDocumentSnapshot doc;
  
  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {
  
  @override
  Widget build(BuildContext context) {
    int colorId = widget.doc['color_id'];
    return Scaffold(
        backgroundColor: appStyle.cardsColor[colorId],
        appBar: AppBar(
          backgroundColor: appStyle.cardsColor[colorId],
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.doc['note_title'], style: appStyle.mainTitle),
              SizedBox(height: 4.0),
              Text(widget.doc['creation_date'], style: appStyle.dateTitle),
              SizedBox(
                height: 28.0,
              ),
              Text(
                widget.doc['note_content'],
                style: appStyle.mainContent,
                
              ),
            ],
          ),
        ),
        floatingActionButton: Wrap(
            //will break to another line on overflow
            direction: Axis.vertical, //use vertical to show  on vertical axis
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Container(
                    margin: EdgeInsets.all(10),
                    child: FloatingActionButton.extended(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      (UpdateScreen(widget.doc))));
                        },
                        backgroundColor: Color.fromARGB(255, 50, 61, 148),
                        splashColor: Color.fromARGB(255, 73, 68, 216),
                        icon: Icon(Icons.edit),
                        label: Text('Edit'))),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    final collection =
                        FirebaseFirestore.instance.collection('Notes');

                    collection
                        .doc(widget
                            .doc.reference.id) // <-- Doc ID to be deleted.
                        .delete() // <-- Delete
                        .then((_) {
                      print('Deleted');

                      Navigator.pop(context);
                    }).catchError((error) => print('Delete failed: $error'));
                  },
                  backgroundColor: Colors.red,
                  splashColor: Color.fromRGBO(216, 77, 68, 1),
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                ),
              )
            ]));
  }
}
