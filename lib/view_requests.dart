import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ViewRequests extends StatefulWidget {
  ViewRequests({Key key}) : super(key: key);

  @override
  _ViewRequestsState createState() => _ViewRequestsState();
}

class _ViewRequestsState extends State<ViewRequests>with TickerProviderStateMixin  {
 
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
          child: Container(height:0,
           width: 450,
            ),),
          
          StreamBuilder(
            
    stream: FirebaseFirestore.instance.collection('classes')
    
    
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
          

          return Padding(padding: EdgeInsets.only(left:10, right:10),
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
                        height: 94,
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
                       Text(document['teacher'],style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        
                       Text(document['grade'],style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                      Text(document['subject'],style: TextStyle(fontSize: 14)),
                      Text(document['chapter'],style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                      Padding(
          padding: const EdgeInsets.only(top:5.0, bottom: 5.0,left:50.0),
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10.0),
            color: Theme.of(context).primaryColor,
            child: MaterialButton(
                onPressed: () {
                 
                },
                child: Text(
                  "Accept",
                )),
          ),
        ),
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