import 'package:flutter/material.dart';
import 'package:shifting_tabbar/shifting_tabbar.dart';
import 'package:timely_timetable/assign_class.dart';
import 'package:timely_timetable/view_requests.dart';



class ClassAssignment extends StatefulWidget{
  @override
  _ClassAssignmentState createState()=>_ClassAssignmentState();
}

class _ClassAssignmentState extends State<ClassAssignment >{
 build(context) {
  
    return Scaffold(
      appBar: new AppBar(
       title:new Text("Assigned Classes"),
       centerTitle: true,
       elevation: 0.0,
       backgroundColor:Colors.cyan,),
      // Define a controller for TabBar and TabBarViews
      body: DefaultTabController(
        length: 2,
        
        child: Scaffold(
          // Use ShiftingTabBar instead of appBar
          appBar: ShiftingTabBar(
            // Specify a color to background or it will pick it from primaryColor of your app ThemeData
            color: Colors.cyan,
            // You can change brightness manually to change text color style to dark and light or 
            // it will decide based on your background color
            // brightness: Brightness.dark,
            tabs: [
              // Also you should use ShiftingTab widget instead of Tab widget to get shifting animation
              ShiftingTab(
                icon: Icon(Icons.assignment),
                text: "Assign Class",
              ),
              ShiftingTab(
                icon: Icon(Icons.message),
                text: "View Requests"
              ),
              
            ],
          ),
          // Other parts of the app are exacly same as default TabBar widget
          body:
           TabBarView(
            children: <Widget>[
           AssignClass(),
            ViewRequests(),
            ],
          ),
        ),
      ),
    );
  }
}