import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timely_timetable/class_assignment.dart';
import 'package:timely_timetable/homePage.dart';
import 'package:timely_timetable/view_lessons.dart';



class BottomNavigation extends StatefulWidget{
  BottomNavigation({Key key}) : super(key: key);
   
@override

  _BottomNavigationState createState()=> _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation>{
  SharedPreferences preferences;
  String userId;
   User currentUser;
    @override
   void initState() { 
     super.initState();
    
   }
   
   void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser;
  }
GlobalKey _bottomNavigationKey = GlobalKey();
  int _selectedPage= 0;
  final _pageOptions=[
  MyHomePage(),
  ViewLessons(),
  ClassAssignment(),


  ];
  @override
  Widget build(BuildContext context){
    return Scaffold(
        //appBar: AppBar(title: Text('Maternal Bot'),),
       
        body:Container( 
          color: Colors.white,
          child: Center(
          child: _pageOptions[_selectedPage],
        ),
        ),
      bottomNavigationBar: SizedBox(
         height: 65,
          child: CurvedNavigationBar(
          key: _bottomNavigationKey,
          //currentIndex : _selectedPage,
          index: 0,
          height: 50.0,
          onTap : (int index) {
            setState(() {
              _selectedPage = index;
            });
          },
        
        items:<Widget> [
         Icon(Icons.home,size: 30),
         Icon(Icons.calendar_view_day,size: 30),
         Icon(Icons.assignment,size: 30),
        
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.cyan,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        
      ),
      ),
        
        );
      
  
  }
}