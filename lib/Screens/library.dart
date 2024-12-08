import 'package:clarisco/Widgets/goals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Widgets/task.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  List taskList = [];
  List goalList = [];
  bool loaded = false;
  String selected = "Task";

  Future<void> processTasks() async {
    try {
      final tasksCollection = FirebaseFirestore.instance.collection('tasks');
      QuerySnapshot snapshot = await tasksCollection.orderBy('time', descending: false).get();

      List<QueryDocumentSnapshot> tasks = snapshot.docs;
        tasks.sort((a, b) {
        String timeStrA = a['time']; 
        String timeStrB = b['time'];
        DateTime timeA = DateFormat("EEE, MMM d hh:mm a").parse(timeStrA);
        DateTime timeB = DateFormat("EEE, MMM d hh:mm a").parse(timeStrB);
        return timeA.compareTo(timeB);
      });

      for (var doc in tasks) {
        String type = doc['type'];
        if (type == 'Task') {
          setState(() {
            taskList.add(doc);
          });
        } else if (type == 'Goal') {
          setState(() {
            goalList.add(doc);
          });
        }
      }
      setState(() {
        loaded = true;
      });
    } catch (e) {
      debugPrint("Error processing tasks: $e");
    }
  }
  @override
  void initState() {
    super.initState();
    processTasks();
  }
  @override
  Widget build(BuildContext context) {
    return loaded ? Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Library', style: TextStyle(color: Color.fromARGB(255, 8, 104, 248), fontWeight: FontWeight.bold, fontSize: 20),),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = "Task";
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected == "Task" ? Colors.black : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Task',
                        style: TextStyle(
                          color: selected == "Task" ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = "Goal";
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected == "Goal" ? Colors.black : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Goal',
                        style: TextStyle(
                          color: selected == "Goal" ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10,),
          selected == 'Task' ? Container(
            height: 30,
            width: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12)
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sort by time',style: TextStyle(fontWeight: FontWeight.w500),),
                Icon(Icons.arrow_drop_down)
              ],
            ),
          ) : 
          Container(
            height: 30,
            width: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12)
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sort by progress',style: TextStyle(fontWeight: FontWeight.w500),),
                Icon(Icons.arrow_drop_down)
              ],
            ),
          ),
          selected == 'Task' ? Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: GridView.builder(
                primary: false,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: taskList.length,
                itemBuilder: (context, index) {
                  return Task(time: taskList[index]['time'], tittle: taskList[index]['tittle'], priority: taskList[index]['priority'], year: taskList[index]['year'],);
                },
              ),
            ),
          ) : Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: GridView.builder(
                primary: false,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: goalList.length,
                itemBuilder: (context, index) {
                  return Goals(time: goalList[index]['time'], tittle: goalList[index]['tittle'], progress: 0, year: goalList[index]['year'],);
                },
              ),
            ),
          )
        ],
      ),
    ): const Center(
      child: CircularProgressIndicator(),
    );
  }
}