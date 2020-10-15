import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ViewLessons extends StatefulWidget {
  ViewLessons({Key key}) : super(key: key);

  @override
  _ViewLessonsState createState() => _ViewLessonsState();
}

class _ViewLessonsState extends State<ViewLessons>with TickerProviderStateMixin  {
 
  DateTime _now = DateTime.now();
  DateTime _start;
  DateTime _end;
    var firebaseUser = FirebaseAuth.instance.currentUser;
  

  
  @override
  void initState() {
    super.initState();
    
   _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
   _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        scrollDirection: Axis.vertical,
        
       child:Column(
         
         children: <Widget>[
           Padding(padding: EdgeInsets.all(0),
          child: Container(height:160,
           width: 450,
           child: Card(
             color: Colors.deepOrange[300],
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft:Radius.circular(30.0) ,bottomRight:Radius.circular(30.0) )),
            child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top:50.0,left:10),
              child:Column(
                children: <Widget>[
                  Text('Timetable',style:TextStyle(fontSize: 22.0,
            fontWeight: FontWeight.bold),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Let us have a look at your classes today',style:TextStyle(fontSize: 16.0,
            ),),
              ),
                ],
              ),),
             
            
            ],
          ),
                ), ),),
          
          StreamBuilder(
            
    stream: FirebaseFirestore.instance.collection('teachers')
    .doc(firebaseUser.uid)
    .collection("lessons")
    .where('lesson_date', isGreaterThanOrEqualTo: _start) 
    .where('lesson_date', isLessThanOrEqualTo: _end) 
    .orderBy('lesson_date')
    .snapshots(),
    //builder: (context, snapshot) {},);
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
      if(!snapshot.hasData){
        return Center(
          child: Text("You do not have any classes today!"),
        );
      }
      if(snapshot.hasData){
        
      }

      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: snapshot.data.docs.map((document) {
          

          return Padding(padding: EdgeInsets.only(left:15, right:15),
           child:Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              //width: MediaQuery.of(context).size.width / 10,
              //height: MediaQuery.of(context).size.height / 6,
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 89,
                        color: Colors.cyanAccent,
                        child:Padding(
                        padding: EdgeInsets.only(top:25, left:10, right:5.0),
                        child: Text(DateFormat.jm().format(DateTime.parse(document['lesson_from'].toDate().toString())),

                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                      ),),
                      Container(
                        width: 89,
                        height: 72,
                        color: Colors.cyanAccent,
                      child:Padding(
                        padding: EdgeInsets.only(top:5, left:10, right: 5.0),
                        child: Text(DateFormat.jm().format(DateTime.parse(document['lesson_to'].toDate().toString())),
                        style: TextStyle(fontSize: 15)),
                      ),),
                      
                      
                      
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left:10),
                  child:Column(
                    
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      
                       Text(document['grade'],style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(document['subject'],style: TextStyle(fontSize: 16)),
                      Text(document['chapter'],style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic))
                    ],),),
                  
                    ],
                  )
                
               
                ),
            ),
          
          );
        }).toList(),
      );
    }
  )
         ],),
     ),
      );
  }
  
}