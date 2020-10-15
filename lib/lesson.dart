import 'package:cloud_firestore/cloud_firestore.dart';

class Lesson{
  final String id;
   final String grade;
   final String subject;
   final String chapter;
   final DateTime lessonDate;
   final String lessonTimeFrom;
   final String lessonTimeTo ;

   Lesson({this.chapter,this.grade,this.id,this.lessonTimeFrom,this.lessonTimeTo,this.lessonDate,this.subject}):super();

factory Lesson.fromMap(Map data){
     return Lesson(
       grade: data['grade'],
       subject: data['subject'],
       chapter: data['chapter'],
      lessonDate: data['lesson_date'],
       lessonTimeFrom: data['lesson_from'],
        lessonTimeTo: data['lesson_to'],
      
     );
   }
   factory Lesson.fromDS(String id, Map<String, dynamic> data){
     return Lesson(
        id: id,
        grade: data['grade'],
       subject: data['subject'],
       chapter: data['chapter'],
       lessonDate: data['lesson_date'].toDate(),
       lessonTimeFrom: data['lesson_from'],
        lessonTimeTo: data['lesson_to'],
      
       );}
Map<String, dynamic> toMap(){
     return{
       "id" : id,
       "chapter":chapter,
       "grade": grade,
       "subject": subject,
       "lesson_from": lessonTimeFrom,
       "lesson_to": lessonTimeTo,
       "lesson_date": lessonDate,
       
     };
   }
   factory Lesson.fromDocument(DocumentSnapshot doc){
    return Lesson(
       grade: doc['grade'],
       subject: doc['subject'],
       chapter: doc['chapter'],
      lessonDate: doc['lesson_date'],
       lessonTimeFrom: doc['lesson_from'],
        lessonTimeTo: doc['lesson_to'],  );
  }
}