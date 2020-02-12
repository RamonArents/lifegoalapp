//Warning!!!!, do not rename this file
//required packages
import 'package:flutter/material.dart';
import 'package:sqllitetest/screens/lifegoal_list.dart';
/*
function main to run the app
@return void
*/
void main() {
  runApp(LifeGoalApp());
}
/*
this class is the main class that runs the app
*/
class LifeGoalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //set title
    return MaterialApp(
      title: 'Lifegoals',
      debugShowCheckedModeBanner: false,
      //set primarySwatch color
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //return the lifegoalList
      home: LifegoalList(),
    );
  }
}
