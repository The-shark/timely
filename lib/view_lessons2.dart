import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timely_timetable/lesson_firestore.dart';

import 'lesson.dart';

class ViewLessons2 extends StatefulWidget {
  ViewLessons2({Key key}) : super(key: key);

  @override
  _ViewLessonsState createState() => _ViewLessonsState();
}

class _ViewLessonsState extends State<ViewLessons2>with TickerProviderStateMixin  {
  AnimationController _animationController;
  CalendarController _calendarController;
  Map<DateTime, List<dynamic>>_events;
  List<dynamic> _selectedEvents;
  Stream _stream;

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }
  @override
  void initState() {
    super.initState();
     
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  
   _events= {};
    _selectedEvents = [];
    _stream = lessonDBS.streamList();

  }
  Map<DateTime, List<dynamic>> _groupLessons(List<Lesson> allLessons) {
    Map<DateTime, List<dynamic>> data = {};
    allLessons.forEach((event) {
      DateTime date = DateTime(event.lessonDate.year, event.lessonDate.month,
      event.lessonDate.day, 24);
      if(data[date] == null) data[date]=[];
      data[date].add(event);
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:StreamBuilder<List<Lesson>>(
        //initialData: <Lesson>[],
        stream: _stream,
        builder: (context, snapshot) {
          if(snapshot.hasError){
            Text('Error: ${snapshot.error}');
          }
          
          if(!snapshot.hasData){
            Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.hasData){
            List<Lesson> allLessons = snapshot.data;
            if(allLessons.isNotEmpty){
              //print(data );
             _events = _groupLessons(allLessons);
            }
            else {
                _events = {};
                _selectedEvents = [];
              }
          }
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            
           child:Column(
             
             children: <Widget>[
               Padding(padding: EdgeInsets.only(top:40),
              child: Container(height:385,
               //width: 350,
               child: Card(
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft:Radius.circular(30.0) ,bottomRight:Radius.circular(30.0) )),
                child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top:12.0),
                  child:Text('Timetable',style:TextStyle(fontSize: 22.0,
                fontWeight: FontWeight.bold),),),
                  
                 TableCalendar(
                  calendarController: _calendarController,
                  events:_events,
                  initialCalendarFormat: CalendarFormat.week,
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
                    selectedDayBuilder: (context, date, events) {
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
                    todayDayBuilder: (context, date,events) {
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
                  ),
                  onDaySelected: (date, events) {
                    print(date.toIso8601String());
                   setState(() {
                              _selectedEvents = events;
                            });
                    _animationController.forward(from: 0.0);
                  },
                  onVisibleDaysChanged: _onVisibleDaysChanged,
                  onCalendarCreated: _onCalendarCreated,
                ),
                ],
              ),
                    ), ),),
            
          ..._selectedEvents.map((event) => ListView(
            shrinkWrap: true,
            children: <Widget>[
            Padding(padding: EdgeInsets.only(left:15, right:15),
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
                            width: 84,
                            color: Colors.cyanAccent,
                            child:Padding(
                            padding: EdgeInsets.only(top:25, left:10, right:5.0),
                            child: Text(event.lesson_from, 
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                          ),),
                          Container(
                            width: 84,
                            height: 72,
                            color: Colors.cyanAccent,
                          child:Padding(
                            padding: EdgeInsets.only(top:5, left:10, right: 5.0),
                            child: Text(event.lesson_to, style: TextStyle(fontSize: 15)),
                          ),),
                          
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left:10),
                      child:Column(
                        
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          
                           Text(event.grade,style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(event.subject,style: TextStyle(fontSize: 16)),
                          Text(event.chapter,style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic))
                        ],),),
                      
                        ],
                      )
                    
                   
                    ),
                ),
              
              ),
            ]
            ),
            ),
             
    
             ],),
     );
        }
      ),
      );
  }
 
}