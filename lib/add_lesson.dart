import 'lesson.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'calendarClient.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddLesson extends StatefulWidget {
  final Lesson lesson;
  
  AddLesson({Key key, this.lesson}) : super(key: key);

  @override
  _AddLessonState createState() => _AddLessonState();
}

class _AddLessonState extends State<AddLesson> {
  CalendarClient calendarClient = CalendarClient();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String id;
  TextEditingController _chapter;
  TextEditingController _grade;
  TextEditingController _subject;
  DateTime _lessonTimeFrom;
  DateTime _lessonTimeTo;
  DateTime _lessonDate;
   final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  
  //final _key = GlobalKey<ScaffoldState>();
  bool processing;

  @override
  
  void initState() { 
    super.initState();
    _chapter = TextEditingController(
      text: widget.lesson!= null? widget.lesson.chapter: "" );
      _grade = TextEditingController(
        text: widget.lesson!=null? widget.lesson.grade: "");
      _subject = TextEditingController(
        text: widget.lesson!= null? widget.lesson.subject:"");
        _lessonTimeFrom = DateTime.now();
        _lessonTimeTo = DateTime.now().add(Duration(minutes: 45));
        _lessonDate = DateTime.now();
        processing = false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SingleChildScrollView(
            scrollDirection:Axis.vertical,
            child:Form(
    key: _formKey,
    child: Container(
      height: 700.0,
      alignment: Alignment.center,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical:8.0),
            child:TextFormField(
              controller: _grade,
              validator:(value)=>
              (value.isEmpty)? "Please add grade":null,
              style: style,
              decoration: InputDecoration(
                labelText : "Grade",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
              ),
            ) ,),
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical:8.0),
            child:TextFormField(
              controller: _subject,
              validator:(value)=>
              (value.isEmpty)? "Please add subject":null,
              style: style,
              decoration: InputDecoration(
                labelText : "Subject",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
              ),
            ) ,),
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical:8.0),
            child:TextFormField(
              controller: _chapter,
              validator:(value)=>
              (value.isEmpty)? "Please add chapter":null,
              style: style,
              decoration: InputDecoration(
                labelText : "Chapter",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
              ),
            ) ,),
            const SizedBox(height:10.0),
            ListTile(
              title: Text("Date(DD-MM-YYYY)"),
              subtitle: Text("${_lessonDate.day}/ ${_lessonDate.month}/ ${_lessonDate.year}"),
              onTap: ()async{
                DateTime picked = await showDatePicker(context: context, initialDate: _lessonDate, firstDate: DateTime(_lessonDate.year-3), lastDate: DateTime(_lessonDate.year+3));
                if(picked != null){
                  setState(() {
                    _lessonDate = picked;
                  });
                }
              },
            ),
            const SizedBox(height:10.0),
            Row(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
           FlatButton(
                  onPressed: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2020, 10, 5),
                        maxTime: DateTime(2200, 6, 7), onChanged: (date) {
                      print('change $date');
                    }, onConfirm: (date) {
                      setState(() {
                        this._lessonTimeFrom = date;
                      });
                    }, currentTime: DateTime.now());
                  },
                  child: Text(
                    'Start of Class',
                    style: TextStyle(color: Colors.blue),
                  )),
              Text('$_lessonTimeFrom'),]),
            Row(
               children: <Widget>[
            FlatButton(
                  onPressed: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2020, 10, 5),
                        maxTime: DateTime(2200, 6, 7), onChanged: (date) {
                      print('change $date');
                    }, onConfirm: (date) {
                      setState(() {
                        this._lessonTimeTo = date;
                      });
                    }, currentTime: DateTime.now());
                  },
                  child: Text(
                    'End of Class',
                    style: TextStyle(color: Colors.blue),
                  )),
              Text('$_lessonTimeTo'),
        ],),
              

            
           SizedBox(height:10),
            processing
            ?Center(child: CircularProgressIndicator())
            :Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Material(
              elevation: 5.0,
              borderRadius:  BorderRadius.circular(30.0),
              color: Theme.of(context).primaryColor,
              child: MaterialButton(
                onPressed: ()async{
                if(_formKey.currentState.validate()){
                  setState(() {
                    processing = true;
                  });
                  var firebaseUser = FirebaseAuth.instance.currentUser;
                 await db.collection('teachers')
                 .doc(firebaseUser.uid)
                 .collection("lessons")
                 .add({
                   'id': id,
                  'grade': _grade.text,
                  'subject': _subject.text,
                  'chapter': _chapter.text,
                  'lesson_date' : _lessonDate,
                 'lesson_from' : _lessonTimeFrom,
                  'lesson_to' : _lessonTimeTo
                  });
                  calendarClient.insert(
                  _grade.text,
                  _subject.text,
                   _chapter.text,
                 _lessonTimeFrom,
                 _lessonTimeTo,
                );
              
                }
                Navigator.pop(context);
                setState(() {
                  processing = false;
                });
              },
              child: Text("Save",
              style:style.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          
                          ),
              ),
            ),
            ),]
      ),
    )

  ),
            
          
        ),
      
    );
  }
  
@override
  void dispose() {
    _grade.dispose();
    _subject.dispose();
    _chapter.dispose();
    super.dispose();
  }

}
