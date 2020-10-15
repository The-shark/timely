import 'package:firebase_helpers/firebase_helpers.dart';
import 'lesson.dart';

DatabaseService<Lesson> lessonDBS = DatabaseService<Lesson>
("lessons", fromDS:(id, data)=> Lesson.fromDS(id, data), toMap:
 (lesson)=>lesson.toMap());