import 'dart:ffi'; // Import for FFI

import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore for database
import 'package:flutter/material.dart'; // Flutter UI
import 'package:provider/provider.dart'; // State management
import 'package:table_calendar/table_calendar.dart'; // Calendar widget
import 'package:myapp/models/tasks.dart'; // Task model 
import 'package:myapp/services/task_service.dart'; // Task services
import 'package:myapp/providers/task_provider.dart'; // Task provider

// Main Home Page screen
class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {

  // Controller to read and manage text input for new tasks
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Runs after widget is built, loads tasks from provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Main app layout
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // App logo
            Expanded(child: Image.asset('assets/rdplogo.png', height: 80)),
            // App title text
            const Text(
              'Daily Planner',
              style: TextStyle(
                fontFamily: 'Caveat',
                fontSize: 32,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),

      // Page body
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Calendar widget
                  TableCalendar(
                    calendarFormat: CalendarFormat.month,
                    focusedDay: DateTime.now(),
                    firstDay: DateTime(2025),
                    lastDay: DateTime(2026),
                  ),

                  // Show all tasks using TaskProvider
                  Consumer<TaskProvider>(
                    builder: (context, taskProvider, child) {
                      return buildTaskItem(
                        taskProvider.tasks, // List of tasks
                        taskProvider.removeTask, // Function to remove task
                        taskProvider.updateTask, // Function to update task
                      );
                    },
                  ),

                  // Section to add a new task
                  Consumer<TaskProvider>(
                    builder: (context, taskProvider, child) {
                      return buildAddTaskSection(nameController, () async {
                        // When "Add Task" button is pressed
                        await taskProvider.addTask(nameController.text); // Save new task
                        nameController.clear(); // Clear input field
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(), // Side menu (currently empty)
    );
  }
}

// Builds the section for adding tasks
Widget buildAddTaskSection(nameController, addTask) {
  return Container(
    decoration: BoxDecoration(color: Colors.white),
    child: Row(
      children: [
        // Input field for task name
        Expanded(
          child: Container(
            child: TextField(
              maxLength: 32,
              controller: nameController, // Stores typed task
              decoration: const InputDecoration(
                labelText: 'Add Task',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        // Button to add the task
        ElevatedButton(
          // onPressed: Adds the task when clicked
          onPressed: addTask,
          child: Text('Add Task'),
        ),
      ],
    ),
  );
}

// Builds and displays the task items on screen
Widget buildTaskItem(
  List<Task> tasks, // List of tasks
  Function(int) removeTasks, // Function to remove a task
  Function(int, bool) updateTask, // Function to update (mark complete/incomplete)
) {
  return ListView.builder(
    shrinkWrap: true, // Prevents taking full screen space
    physics: const NeverScrollableScrollPhysics(), // Makes scroll inside parent
    itemCount: tasks.length, // Number of tasks
    itemBuilder: (context, index) {
      final task = tasks[index]; // Current task
      final isEven = index % 2 == 0; // Alternate colors for tasks

      return Padding(
        padding: EdgeInsets.all(1.0),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          tileColor: isEven ? Colors.blue : Colors.green, // Alternate color
          leading: Icon(
            // Shows check icon if completed, else empty circle
            task.completed ? Icons.check_circle : Icons.circle_outlined,
          ),
          title: Text(
            task.name, // Task name text
            style: TextStyle(
              // If completed, strike through text
              decoration: task.completed ? TextDecoration.lineThrough : null,
              fontSize: 22,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Checkbox to mark task complete/incomplete
              Checkbox(
                value: task.completed,
                // When checkbox clicked → updates task status
                onChanged: (value) => {updateTask(index, value!)},
              ),
              // Delete button
              IconButton(
                icon: Icon(Icons.delete),
                // onPressed: Removes the selected task
                onPressed: () => removeTasks(index),
              ),
            ],
          ),
        ),
      );
    },
  );
}
