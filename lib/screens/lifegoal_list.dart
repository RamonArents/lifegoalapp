//required packages
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqllitetest/models/lifegoal.dart';
import 'package:sqllitetest/utils/database_helper.dart';

import 'lifegoal_detail.dart';

/*
  This class displays the list with the LifGoals
*/
class LifegoalList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LifegoalListState();
  }
}

class LifegoalListState extends State<LifegoalList> {
  //initalize variables
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<LifeGoal> lifegoalList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    //check if there are already listitems created
    if (lifegoalList == null) {
      lifegoalList = List<LifeGoal>();
      updateListView();
    }

    return Scaffold(
      //appBar title
      appBar: AppBar(
        title: Text('Lifegoals'),
      ),
      //backgroundcolor of this page
      backgroundColor: Colors.indigo,
      body: getNoteListView(),
      //action button in the right corner of the screen
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(LifeGoal('', '', 1, 0), 'Add Goal');
        },
        tooltip: 'Add one',
        child: Icon(Icons.add),
      ),
    );
  }

  /*
  function to get the noteListView
  @return ListView (with the listitems)
  */
  ListView getNoteListView() {
    //use the textstyle of the primarySwatch
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 0.2,
          child: ListTile(
            //displays the priority of the lifegoals.
            //leading:this.lifegoalList[position].priority == 1 ? CircleAvatar(backgroundColor:Colors.red, child:Icon(Icons.favorite)) : null,
            leading: CircleAvatar(
              backgroundColor:
                  getPriorityColor(this.lifegoalList[position].priority),
              child: getPriorityIcon(this.lifegoalList[position].priority),
            ),
            title: Text(this.lifegoalList[position].title, style: titleStyle),
            subtitle: Text(this.lifegoalList[position].date),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              //shows a check when the lifegoal is completed, else nothing
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Visibility(
                  child: Icon(Icons.check, color: Colors.green),
                  visible: iconCompleted(this.lifegoalList[position].reached),
                ),
              ),
              // trigger the _delete function when the dustbin is clicked
              GestureDetector(
                child: Icon(Icons.delete, color: Colors.grey),
                onTap: () {
                  _delete(context, lifegoalList[position]);
                },
              ),
            ]),
            onTap: () {
              //when the card is tapped, go to the edit mode of the lifegoal_detail page
              navigateToDetail(this.lifegoalList[position], 'Edit Goal');
            },
          ),
        );
      },
    );
  }

  /*
  function to get the color based on priority
  @param priority (integer that determines the priority)
  @return Color (the color to use at the given priority)
  */
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1: //high
        return Colors.red;
        break;
      case 2: //medium
        return Colors.orange;
        break;
      case 3: //low
        return Colors.blue;
        break;
      default:
        return Colors.blue;
    }
  }

  /*
  function to get an icon based on priority
  @param priority (integer that determines the priority)
  @return Icon (a hart icon for high, the others are null)
  */
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1: //high
        return Icon(Icons.favorite);
        break;
      case 2: //medium
        return null;
        break;
      case 3: //low
        return null;
        break;
      default:
        return null;
    }
  }

  /*
  function to check if a lifegoal is completed
  @param completed (integer to determine if the lifegoal is completed)
  @return bool (true when completed, false when not)
  */
  bool iconCompleted(int completed) {
    if (completed == 1) {
      return true;
    } else {
      return false;
    }
  }

  /*
  function to give a pop-up when the delete dustbin is clicked, so the user can cancel the action if it was clicked by accident.
  @param context (context of the build)
  @param lifegoal (the LifeGoal object that must be deleted)
  @return void
  */
  void _delete(BuildContext context, LifeGoal lifegoal) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete goal'),
            content: Text('Are you sure to delete this goal?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Delete'),
                onPressed: () async {
                  int result = await databaseHelper.deleteLifegoal(lifegoal.id);
                  if (result != 0) {
                    updateListView();
                  }
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  // Use this function for snackbars (not used at the moment)
  // void _showSnackBar(BuildContext context, String message) {
  //   final snackBar = SnackBar(content: Text(message));
  //   Scaffold.of(context).showSnackBar(snackBar);
  // }

  /*
    function to navigate to the lifegoal_detail page in case of update
    @param LifeGoal (the LifeGoal object to be updated)
    @param title (the title of the LifeGoal)
    @return LifeGoalDetail page with the data of the object
  */
  Future navigateToDetail(LifeGoal lifegoal, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LifegoalDetail(lifegoal, title);
    }));

    if (result) {
      updateListView();
    }
  }
  /*
  function to update the listview when an update or delete was triggered
  @return void
  */
  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<LifeGoal>> lifegoalListFuture =
          databaseHelper.getLifegoalList();
      lifegoalListFuture.then((lifegoalList) {
        setState(() {
          this.lifegoalList = lifegoalList;
          this.count = lifegoalList.length;
        });
      });
    });
  }
}
