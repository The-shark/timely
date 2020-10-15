import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timely_timetable/add_lesson.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timely_timetable/assign_class.dart';
import 'lesson.dart';
import 'package:firebase_auth/firebase_auth.dart';


// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],
};


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.lesson}) : super(key: key);

  final String title;
  final Lesson lesson;
  
 
 

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  User currentUser;
   
DateTime _now = DateTime.now();
  DateTime _start;
 Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }
  
  @override
  void initState() {
    super.initState();

     
    _start = DateTime.now();
      //_end = DateTime(_now.year, _now.month, _now.day, _now.minute +45);
      this.getCurrentUser();
    final _selectedDay = DateTime.now();
    //final diff_mn = currentTime.difference(startTime).inMinutes;
    
    _events = {
      _selectedDay.subtract(Duration(days: 30)): ['Event A0', 'Event B0', 'Event C0'],
      _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
      _selectedDay.subtract(Duration(days: 20)): ['Event A2', 'Event B2', 'Event C2', 'Event D2'],
      _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
      _selectedDay.subtract(Duration(days: 10)): ['Event A4', 'Event B4', 'Event C4'],
      _selectedDay.subtract(Duration(days: 4)): ['Event A5', 'Event B5', 'Event C5'],
      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
      _selectedDay.add(Duration(days: 1)): ['Event A8', 'Event B8', 'Event C8', 'Event D8'],
      _selectedDay.add(Duration(days: 3)): Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
      _selectedDay.add(Duration(days: 7)): ['Event A10', 'Event B10', 'Event C10'],
      _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
      _selectedDay.add(Duration(days: 17)): ['Event A12', 'Event B12', 'Event C12', 'Event D12'],
      _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
      _selectedDay.add(Duration(days: 26)): ['Event A14', 'Event B14', 'Event C14'],
    };

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }
  Map<DateTime, List<dynamic>> _groupEvents(List<Lesson> allEvents) {
    Map<DateTime, List<dynamic>> data = {};
    allEvents.forEach((event) {
      DateTime date = DateTime(
          event.lessonDate.year, event.lessonDate.month, event.lessonDate.day, 12);
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });
    return data;
  }
  @override
  void getCurrentUser() async{
    currentUser= await FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      appBar: AppBar(
        title: Text("Timely"),
      ),
      body: SingleChildScrollView( 
     child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _greetings(),
          const SizedBox(height: 8.0),
        StreamBuilder(
          stream: FirebaseFirestore.instance.collection("lessons")
          .where('lesson_from', isGreaterThanOrEqualTo: _start) 
          //.where('lesson_to', isLessThanOrEqualTo: _end) 
          .limit(1)
          .snapshots(),
           
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
               if(!snapshot.hasData){
                return Container(
                  height: 100,
                  width: 330,
                  child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top:10.0, left:15.0),
                  child:Text(
                'Ongoing Class',
                textScaleFactor: 1.1,
              ),
                ),
                Padding(
                padding: EdgeInsets.only(top:5.0, left:15.0),
                  child:Text('You are free!',
                    style:TextStyle(fontSize: 20.0,
                fontWeight: FontWeight.bold),
                
                
              ),
                ),],),
                Padding(
                padding: EdgeInsets.only(top:10.0, left:45.0),
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      
                      ),
                      color: Colors.blue,
                      textColor: Colors.white,
                      
                      onPressed: (){},
                      child: Padding(
                padding: EdgeInsets.only(top:5.0, left:4.0, bottom: 5.0),
                child:Text("Can't make it \n to my class"),),
                      ),
                      ),
                    ],
                
                ),

                ),
                );
              }
              if(snapshot.hasData){
                
              }
              //var subject = snapshot.data;
              return ListView(
        shrinkWrap: true,
        
        physics: const NeverScrollableScrollPhysics(),
        children: snapshot.data.docs.map((document) {
                return Container(
                  height: 100,
                  //width: 300,
                  margin: EdgeInsets.only(right:18, left:18),
                  child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top:10.0, left:15.0),
                  child:Text(
                'Ongoing Class',
                textScaleFactor: 1.1,
              ),
                ),
                Padding(
                padding: EdgeInsets.only(top:5.0, left:15.0),
                  child:Text(document['subject'],
                    style:TextStyle(fontSize: 20.0,
                fontWeight: FontWeight.bold),
                
                
              ),
                ),],),
                Padding(
                padding: EdgeInsets.only(top:10.0, left:35.0),
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      
                      ),
                      color: Colors.blue,
                      textColor: Colors.white,
                      
                      onPressed: (){Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AssignClass()),
  );},
                      child: Padding(
                padding: EdgeInsets.only(top:5.0, left:4.0, bottom: 5.0),
                child:Text("Can't make it \n to my class"),),
                      ),
                      ),
                    ],
                
                ),

                ),
                );}).toList());
               }),
            
          
          const SizedBox(height: 8.0),
          
           _buildTableCalendarWithBuilders(),
          
          const SizedBox(height: 8.0),
          
        ],
      ),
     ),
     floatingActionButton:FloatingActionButton(
  onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AddLesson()),
  );
  },
  child: Icon(Icons.add),
),
      );
  }

 Widget _greetings(){
   return Container(
     height: 70,
     width: 400,
     child: Padding(
       padding: EdgeInsets.only(top:30, left:20),
     child:Text(
       'Greetings',
       style: TextStyle(fontSize: 20,
       fontWeight: FontWeight.bold,color: hexToColor("#F2A03D")
       ),
      )
      ),
   );
 }
  

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
     
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date) ? Colors.brown[300] : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }


  }