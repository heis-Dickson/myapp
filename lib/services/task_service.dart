import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/tasks.dart';

//Define a Task Service to handle Firestore operationss
class TaskService {
  //Firestore instance in an alias
  final FirebaseFirestore db = FirebaseFirestore.instance;

  //Future that returns a list of tasks using factory method defined in Task class
  Future<List<Task>> fetchTasks() async {
    //call get to retrieve all of the documents inside the collection
    final snapshot = await db.collection('tasks').orderBy('timestamp').get();
    //snapshot of all documents is being mapped to factory object template
    return snapshot.docs
        .map((doc) => Task.fromMap(doc.id, doc.data()))
        .toList();
  }

  //another asynchronous Future to add tasks to the firestore
  Future<String> addTask(String name) async {
    final newTask = {
      'name': name,
      'completed': false,
      'timestamp': FieldValue.serverTimestamp(),
    };
    final docRef = await db.collection('tasks').add(newTask);
    return docRef.id;
  }

  //update task future
  Future<void> updateTask(String id, bool completed) async {
    await db.collection('tasks').doc(id).update({'completed': completed});
  }

  //Future is going to delete tasks
  Future<void> deleteTasks(String id) async {
    await db.collection('tasks').doc(id).delete();
  }
}
