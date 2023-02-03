import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/style/app_style.dart';

class UpdateScreen extends StatefulWidget {
  UpdateScreen(this.doc, {super.key});
  QueryDocumentSnapshot doc;

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  int colorId = Random().nextInt(appStyle.cardsColor.length);
  String date = DateTime.now().toString();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _mainController = TextEditingController();

  var collection = FirebaseFirestore.instance.collection('Notes');
  void initState() {
    _titleController.text = widget.doc['note_title'];
    _mainController.text = widget.doc['note_content'];
    return super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // _titleController.text = widget.doc['note_title'];
    // _mainController.text = widget.doc['note_content'];
    return Scaffold(
      backgroundColor: appStyle.cardsColor[colorId],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: appStyle.cardsColor[colorId],
        elevation: 0.0,
        title: Text('Add a new Note', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                style: appStyle.mainTitle),
            SizedBox(
              height: 8.0,
            ),
            Text(
              date,
              style: appStyle.dateTitle,
            ),
            SizedBox(height: 28.0),
            TextField(
                controller: _mainController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                style: appStyle.mainContent),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: appStyle.accentColor,
        onPressed: () async {
          collection
              .doc(widget
                  .doc.reference.id) // <-- Doc ID where data should be updated.
              .update({
            'note_title': _titleController.text,
            'creation_date': date,
            'note_content': _mainController.text,
          }) // <-- Updated data
              .then((value) {
            Navigator.pop(context);
            Navigator.pop(context);
          }).catchError((error) => print('Update failed: $error'));
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
