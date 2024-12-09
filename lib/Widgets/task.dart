import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Task extends StatelessWidget {
  final String time;
  final String tittle;
  final String priority;
  final int year;

  const Task({
    super.key,
    required this.time,
    required this.tittle,
    required this.priority,
    required this.year,
  });

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.015),
      child: Container(
        height: screenHeight * 0.2,
        width: screenWidth * 0.45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: screenHeight * 0.035,
                width: screenWidth * 0.35,
                decoration: BoxDecoration(
                  color: getRandomColor(),
                  borderRadius: BorderRadius.circular(screenWidth * 0.015),
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
              Text(
                tittle,
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
              const Spacer(),
              Text('Priority: $priority', style: TextStyle(fontSize: screenWidth * 0.035),),
              Row(
                children: [
                  Text(
                    'Time left: ',
                    style: TextStyle(fontSize: screenWidth * 0.035),
                  ),
                  Text(
                    timeRemaining(time, year),
                    style: TextStyle(
                      color: timeRemaining(time, year) == 'Overdue'
                          ? Colors.red
                          : Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
