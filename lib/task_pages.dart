import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo_app/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {

  int _selectedIndex = 0;
  Database? _database;

  List<Map<String, dynamic>> _tasks = [];

  void _fetchTasks() async{
    List<Map<String, dynamic>> tasksData = [];

    if (_selectedIndex == 0) {
      tasksData = await DatabaseHelper.instance.getAllTasks();
    } else if (_selectedIndex == 1) {
      tasksData = await DatabaseHelper.instance.getDoneTasks();
    } else if (_selectedIndex == 2) {
      tasksData = await DatabaseHelper.instance.getPendingTasks();
    }

    setState(() {
      _tasks = tasksData;
    });

  }

  @override
  void initState(){
    super.initState();
    _fetchTasks();
  }

  final TextEditingController _taskController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _fetchTasks();
    });
  }

  void _addTask(String title) async {
    final newTask = {
      'title': title,
      'status': 0,
    };
    await DatabaseHelper.instance.insertTask(newTask);
    _taskController.clear();
    _fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo App'),
      ),
      body: ListView.builder(
          itemCount: _tasks.length,
          itemBuilder: (BuildContext context, int index)
          {
            final task = _tasks[index];
            return ListTile(
                title: Text(task['title']),
                leading: const Icon(Icons.check_box_outline_blank),
            );
          }
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'All',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pending),
            label: 'Pending',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          showDialog(
            context: context,
            builder: (BuildContext contexr) {
              return AlertDialog(
                title: Text('Add task'),
                content: TextField(
                  controller: _taskController,
                  decoration: InputDecoration(labelText: 'Task'),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: Text('Save'),
                    onPressed: () {
                      _addTask(_taskController.text);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}