import 'package:clarisco/Screens/profile.dart';
import 'package:clarisco/Widgets/goals.dart';
import 'package:clarisco/Widgets/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List combinedList = [];
  int taskCount = 0;
  int goalCount = 0;
  String username = '';
  String imgurl = '';
  bool loaded = false;
  String selected = "Overview";

  Future<void> processTasks() async {
    try {
      final tasksCollection = FirebaseFirestore.instance.collection('tasks');
      QuerySnapshot snapshot = await tasksCollection.orderBy('time', descending: false).get();
      final user = FirebaseFirestore.instance.collection('user');
      QuerySnapshot userdata = await user.where('id', isEqualTo: 1).get();

      for (var usr in userdata.docs) {
        setState(() {
          username = usr['name'];
          imgurl = usr['imgurl'];
        });
      }

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
        setState(() {
          combinedList.add(doc);
        });
        if (type == 'Task') {
          setState(() {
            taskCount++;
          });
        } else if (type == 'Goal') {
          setState(() {
            goalCount++;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text('Hello,\n$username', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)
                ],
              ),
              const Spacer(),
              const Icon(Icons.notifications_on, size: 33,),
              const SizedBox(width: 15,),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const Profile()));
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle
                  ),
                  child: imgurl != '' ? 
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(
                      image: NetworkImage(imgurl),
                      height: 40, 
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                  ) : 
                  Center(
                    child: Text(username[0]+username[1].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),)
                  ) ,
                ),
              )
            ],
          ),
          const SizedBox(height: 15,),
          const Text('Home', style: TextStyle(color: Color.fromARGB(255, 8, 104, 248), fontWeight: FontWeight.bold, fontSize: 20)),
          const SizedBox(height: 15,),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selected = "Overview";
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected == "Overview" ? Colors.black : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Overview',
                    style: TextStyle(
                      color: selected == "Overview" ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selected = "Upcomming";
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected == "Upcomming" ? Colors.black : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Upcomming',
                    style: TextStyle(
                      color: selected == "Upcomming" ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          selected == 'Overview' ? Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text('Tasks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                              SizedBox(width: 5,),
                              Icon(Icons.info_outline_rounded, size: 20,),
                              Spacer(),
                              Text('Last 7 Days',style: TextStyle(fontWeight: FontWeight.w500),)
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    child: Text('You marked $taskCount tasks as completed in this period.', style: const TextStyle(fontWeight: FontWeight.w500),),
                                  ),
                                  const SizedBox(height: 10,),
                                  Container(
                                    height: 45,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(30)
                                    ),
                                    child: const Center(
                                      child: Text('See all', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),),
                                    ),
                                  )
                                ],
                              ),
                              const Spacer(),
                              const Icon(Icons.task, size: 80, color: Colors.blue,)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text('Goals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                              SizedBox(width: 5,),
                              Icon(Icons.info_outline_rounded, size: 20,),
                              Spacer(),
                              Text('Last 7 Days',style: TextStyle(fontWeight: FontWeight.w500),)
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    child: Text('You checked in to $goalCount goals in this period.', style: const TextStyle(fontWeight: FontWeight.w500),),
                                  ),
                                  const SizedBox(height: 10,),
                                  Container(
                                    height: 45,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 215, 200, 67),
                                      borderRadius: BorderRadius.circular(30)
                                    ),
                                    child: const Center(
                                      child: Text('See all', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),),
                                    ),
                                  )
                                ],
                              ),
                              const Spacer(),
                              const Icon(Icons.adjust_sharp, size: 80, color: Color.fromARGB(255, 215, 200, 67),)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text('Savings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                              SizedBox(width: 5,),
                              Icon(Icons.info_outline_rounded, size: 20,),
                              Spacer(),
                              Text('Last 7 Days',style: TextStyle(fontWeight: FontWeight.w500),)
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    child: const Text('You have saved \$65,000 in this period.', style: TextStyle(fontWeight: FontWeight.w500),),
                                  ),
                                  const SizedBox(height: 10,),
                                  Container(
                                    height: 45,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.greenAccent,
                                      borderRadius: BorderRadius.circular(30)
                                    ),
                                    child: const Center(
                                      child: Text('See all', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),),
                                    ),
                                  )
                                ],
                              ),
                              const Spacer(),
                              const Icon(Icons.money, size: 80, color: Colors.greenAccent,)
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            ),
          ) :
          Row(
            children: [
              const Spacer(),
              Container(
                height: 30,
                width: 120,
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
              )
            ],
          ),
          selected == 'Upcomming' ? Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: GridView.builder(
                primary: false,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: combinedList.length,
                itemBuilder: (context, index) {
                  return combinedList[index]['type'] == 'Task' ? 
                  Task(time: combinedList[index]['time'], tittle: combinedList[index]['tittle'], priority: combinedList[index]['priority'], year: combinedList[index]['year'],) : 
                  Goals(time: combinedList[index]['time'], tittle: combinedList[index]['tittle'], progress: 0, year: combinedList[index]['year'],);
                },
              ),
            ),
          ) : Container()
        ],
      )
    ) : 
    const Center(
      child: CircularProgressIndicator(),
    );
  }
}