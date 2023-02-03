import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/style/app_style.dart';
import 'package:intl/intl.dart'; 

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key});
  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  int colorId = Random().nextInt(appStyle.cardsColor.length);
  String date = DateFormat.yMd().add_jm().format(DateTime.now()).toString();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _mainController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appStyle.cardsColor[colorId],
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: appStyle.cardsColor[colorId],
          elevation: 0.0,
          title: Text('Add a new Note',
          style: TextStyle(color: Colors.black)),
          
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Note Title',
                ),
                style:appStyle.mainTitle
              ),
              SizedBox(height: 8.0,),
              Text(date,
              style: appStyle.dateTitle,),
              SizedBox(height:28.0),
              TextField(
                controller: _mainController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Note Content',
                ),
                style:appStyle.mainContent
              ),

  
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: appStyle.accentColor,
          onPressed: () async{
            FirebaseFirestore.instance.collection("Notes").add({
              'note_title':_titleController.text,
              'creation_date':date,
              'note_content':_mainController.text,
              'color_id' : colorId
            }).then((value) {
              print(value.id);
              Navigator.pop(context);
            } ).catchError((err)=>print('failed to add note due to error = $err'));
          },
          child: Icon(Icons.save),
        ),
        );
        
        
  }
}
