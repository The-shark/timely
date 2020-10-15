import 'lesson.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AssignClass extends StatefulWidget {
  final Lesson lesson;
  
  AssignClass({Key key, this.lesson}) : super(key: key);

  @override
  _AssignClassState createState() => _AssignClassState();
}

class _AssignClassState extends State<AssignClass> {

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String id;
  TextEditingController _teacherName;
  TextEditingController _chapter;
  
  TextEditingController _grade;
  DateTime _lessonTimeFrom;
  DateTime _lessonTimeTo;
  DateTime _lessonDate;
   final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  int _value=1;
  //final _key = GlobalKey<ScaffoldState>();
  bool processing;
  List<String> _subjects = <String>[
    'Mathematics',
    'English',
    'Science',
    'Kiswahili',
    'Social Studies'
  ];
  var  selectedType;

  @override
  
  void initState() { 
    super.initState();
    _teacherName = new TextEditingController();
    _chapter = new TextEditingController();
   
    _grade =new TextEditingController();
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
      height: 800.0,
     
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical:8.0),
            
               child: TextFormField(
                  
                  controller: _teacherName,
                  validator:(value)=>
                  (value.isEmpty)? "Please add name":null,
                  style: style,
                  decoration: InputDecoration(
                    hintText : "Your name",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                  ),
                ),
              
          ),
                  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical:8.0),
            child:
                TextFormField(
                  controller: _grade,
                  validator:(value)=>
                  (value.isEmpty)? "Please add grade":null,
                  style: style,
                  decoration: InputDecoration(
                    hintText : "Grade",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                  ),
                ),
              ),
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical:8.0),
            child:Container(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              
              border: Border.all()),
          child: DropdownButtonHideUnderline(
              child:  DropdownButton(
                 items: _subjects
                        .map((value) => DropdownMenuItem(
                              child: Text(
                                value,
                                
                              ),
                              value: value,
                            ))
                        .toList(),
                    onChanged: (selectedSubject) {
                      print('$selectedSubject');
                      setState(() {
                        selectedType = selectedSubject;
                      });
                    },
                    value: selectedType,
                    isExpanded: false,
                    hint: Text(
                      'Select Subject',
                      
                    ),),),),
              ),
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical:8.0),
            child:TextFormField(
                  controller: _chapter,
                  validator:(value)=>
                  (value.isEmpty)? "Please add chapter":null,
                  style: style,
                  decoration: InputDecoration(
                    hintText : "Chapter",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                  ),
                ),
             ),
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
                  //var firebaseUser = FirebaseAuth.instance.currentUser;
                 await db.collection('classes')
                
                 .add({
                   'id': id,
                  'grade': _grade.text,
                  'subject' : selectedType,
                  'teacher': _teacherName.text,
                  'chapter': _chapter.text,
                  'lesson_date' : _lessonDate,
                 'lesson_from' : _lessonTimeFrom,
                  'lesson_to' : _lessonTimeTo
                  });
                 
                }
                Navigator.pop(context);
                setState(() {
                  processing = false;
                });
              },
              child: Text("Send Request",
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
    _teacherName.dispose();
    _chapter.dispose();
    super.dispose();
  }

}
