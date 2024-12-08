import 'package:clarisco/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String selected = "Task";
  String recurring = "Never";
  String priority = "High";
  DateTime? _selectedDateTime;
  bool isLoading = false;
  int year = 0;

  Future<void> selectDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      setState(() {
        year = pickedDate.year;
      });
      if (pickedTime != null) {
        final newDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          _selectedDateTime = newDateTime;
        });
      }
    }
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Select a time';
    return DateFormat('EEE, MMM d hh:mm a').format(dateTime);
  }

  TextEditingController tittle = TextEditingController();
  TextEditingController location = TextEditingController();


  @override
  Widget build(BuildContext context) {
    TextEditingController datecontroller = TextEditingController(text: _selectedDateTime == null ? '' : formatDateTime(_selectedDateTime));

    Future<void> addTask() async {
      setState(() {
        isLoading = true;
      });
      try {
        CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');

        await tasks.add({
          'type':selected,
          'tittle': tittle.text,
          'time':datecontroller.text,
          'location':location.text,
          'priority':priority,
          'recurring':recurring,
          'year':year
        });

        Navigator.push(context, MaterialPageRoute(builder: (_) => const BottomNavigation()));
      }catch(error) {
        debugPrint("Error: $error");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
    void errorMsg(msg) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.white, content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.black),), behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 2),));
    }
    
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 238, 238),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque, 
                    onTap: () {
                      Navigator.pop(context);
                    }, 
                    child: const Icon(Icons.arrow_back_ios)
                  ),
                  const Text('New task', style: TextStyle(color: Color.fromARGB(255, 8, 104, 248), fontWeight: FontWeight.bold, fontSize: 18)),
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
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Enter a tittle', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 12),),
                          const SizedBox(height: 10,),
                          TextField(
                            controller: tittle,
                            minLines: 1,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Enter a tittle',
                              hintStyle: const TextStyle(color: Color.fromARGB(255, 208, 207, 207)),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(12)
                              )
                            ),
                          ),
                          const SizedBox(height: 15,),
                          const Text('Select a time', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 12),),
                          const SizedBox(height: 10,),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              selectDateTime(context);
                            },
                            child: TextField(
                              controller: datecontroller,
                              enabled: false,                          
                              decoration: InputDecoration(  
                                hintText: 'Select a time',
                                hintStyle: const TextStyle(color: Color.fromARGB(255, 208, 207, 207)),                                                  
                                fillColor: Colors.white,
                                filled: true,
                                suffixIcon: const Icon(Icons.calendar_month),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(12)
                                )
                              ),
                            ),
                          ),
                          const SizedBox(height: 15,),
                          const Text('Enter a location (optional)', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 12),),
                          const SizedBox(height: 10,),
                          TextField(
                            controller: location,
                            decoration: InputDecoration(
                              hintText: 'Enter a location',
                              hintStyle: const TextStyle(color: Color.fromARGB(255, 208, 207, 207)),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(12)
                              )
                            ),
                          ),
                          const SizedBox(height: 15,),
                          const Row(
                            children: [
                              Text('Set priority', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 12),),
                              SizedBox(width: 5,),
                              Icon(Icons.info_outline_rounded, size: 15, color: Colors.grey,)
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        priority = "High";
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: priority == "High" ? Colors.black : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'High',
                                        style: TextStyle(
                                          color: priority == "High" ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        priority = "Moderate";
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: priority == "Moderate" ? Colors.black : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Moderate',
                                        style: TextStyle(
                                          color: priority == "Moderate" ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        priority = "Low";
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: priority == "Low" ? Colors.black : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Low',
                                        style: TextStyle(
                                          color: priority == "Low" ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 15,),
                          const Row(
                            children: [
                              Text('Make recurring', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 12),),
                              SizedBox(width: 5,),
                              Icon(Icons.info_outline_rounded, size: 15, color: Colors.grey,)
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        recurring = "Never";
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: recurring == "Never" ? Colors.black : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Never',
                                        style: TextStyle(
                                          color: recurring == "Never" ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        recurring = "Daily";
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: recurring == "Daily" ? Colors.black : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Daily',
                                        style: TextStyle(
                                          color: recurring == "Daily" ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        recurring = "Weekly";
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: recurring == "Weekly" ? Colors.black : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Weekly',
                                        style: TextStyle(
                                          color: recurring == "Weekly" ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        recurring = "Monthly";
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: recurring == "Monthly" ? Colors.black : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Monthly',
                                        style: TextStyle(
                                          color: recurring == "Monthly" ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40,),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                if (tittle.text == '') {
                                  errorMsg('tittle is required');
                                } else if(datecontroller.text == '') {
                                  errorMsg('time is required');
                                } else {
                                  addTask();
                                }
                              },
                              child: Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(40)
                                ),
                                child: const Center(
                                  child: Text('Save task', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}