import 'package:clarisco/Screens/add_task.dart';
import 'package:clarisco/Screens/home.dart';
import 'package:clarisco/Screens/library.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  String screen = 'home';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 238, 238),
        body: screen == 'home' ? const Home() : const Library(),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30)
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTask()));
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 190, 189, 189),
                        shape: BoxShape.circle
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 30,),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        screen = 'home';
                      });
                    },
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: screen == 'home' ? Colors.black : const Color.fromARGB(255, 190, 189, 189),
                        shape: BoxShape.circle
                      ),
                      child: const Icon(Icons.home, color: Colors.white, size: 50,),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        screen = 'tasks';
                      });
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: screen == 'tasks' ? Colors.black : const Color.fromARGB(255, 190, 189, 189),
                        shape: BoxShape.circle
                      ),
                      child: const Icon(Icons.task_outlined, color: Colors.white, size: 30,),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}