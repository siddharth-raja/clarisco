import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Task extends StatelessWidget {
  final String time;
  final String tittle;
  final String priority;
  final int year;
  const Task({super.key, required this.time, required this.tittle, required this.priority, required this.year});

  Color getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  String timeRemaining(time, currentYear) {
    String updatedTime = "$time, $currentYear";
    DateTime givenTime = DateFormat("EEE, MMM d hh:mm a, yyyy").parse(updatedTime);
    DateTime now = DateTime.now();
    Duration difference = givenTime.difference(now);

    if (difference.isNegative) {
      return 'Overdue';
    } else {
      return _formatDuration(difference);
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return "${duration.inDays} day${duration.inDays > 1 ? 's' : ''}";
    } else if (duration.inHours > 0) {
      return "${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}";
    } else if (duration.inMinutes > 0) {
      return "${duration.inMinutes} minute${duration.inMinutes > 1 ? 's' : ''}";
    } else {
      return "Less than a minute";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.035,
                width: MediaQuery.of(context).size.width * 0.35,
                decoration: BoxDecoration(
                  color: getRandomColor(),
                  borderRadius: BorderRadius.circular(6)
                ),
              ),
              const SizedBox(height: 5,),
              Text(tittle, style: const TextStyle(fontSize: 15),),
              const Spacer(),
              Text('Priority: $priority'),
              Row(
                children: [
                  const Text('Time left: '),
                  Text(timeRemaining(time, year), style: TextStyle(color: timeRemaining(time, year) == 'Overdue' ? Colors.red : Colors.green, fontWeight: FontWeight.w600),)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}