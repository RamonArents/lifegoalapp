// import required packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqllitetest/models/lifegoal.dart';
import 'package:sqllitetest/utils/database_helper.dart';

/*
  This class creates the form view to insert, update or delete a lifegoal
*/
class LifegoalDetail extends StatefulWidget {
  //initalize variables
  final String appBarTitle;
  final LifeGoal lifegoal;

  LifegoalDetail(this.lifegoal, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return LifegoalDetailState(this.lifegoal, this.appBarTitle);
  }
}

class LifegoalDetailState extends State<LifegoalDetail> {
  //values for the dropdownmenu's
  static var _priorities = ['High', 'Medium', 'Low'];
  static var _reached = ['Completed', 'Not completed'];
  var _validate = false;
  //initialize other variables
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  LifeGoal lifegoal;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  LifegoalDetailState(this.lifegoal, this.appBarTitle);

  @override
  void dispose() {
    //dispose for required title field
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //use the primarySwatch color to style the text
    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = lifegoal.title;
    descriptionController.text = lifegoal.description;
    //Using Android, WillPopScope determines how the back button should act. In this case it returns to the lifegoal_list.
    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      //also return to the lifgoal_list when the white backbutton at the top is clicked
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              moveToLastScreen();
            },
          ),
        ),
        //priority dropdown
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              Text(
                'Goal importance:',
                style: textStyle,
              ),
              ListTile(
                title: DropdownButton(
                  items: _priorities.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  style: textStyle,
                  value: getPriorityAsString(lifegoal.priority),
                  onChanged: (valueSelectedByUser) {
                    setState(() {
                      updatePriorityAsInt(valueSelectedByUser);
                    });
                  },
                ),
              ),
              //title field
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: titleController,
                  style: textStyle,
                  onChanged: (value) {
                    updateTitle();
                  },
                  decoration: InputDecoration(
                    labelText: 'title',
                    labelStyle: textStyle,
                    errorText: _validate ? 'This field is required' : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              //description field
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: descriptionController,
                  style: textStyle,
                  onChanged: (value) {
                    updateDescription();
                  },
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              //completed dropdown
              ListTile(
                title: DropdownButton(
                  items: _reached.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  style: textStyle,
                  value: getReachedAsString(lifegoal.reached),
                  onChanged: (valueSelectedByUser) {
                    setState(() {
                      updateReachedAsInt(valueSelectedByUser);
                    });
                  },
                ),
              ),
              //save button
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Save',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          _save();
                        });
                      },
                    ),
                  ),
                  //delete button
                  Container(width: 5.0),
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Delete',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          _delete();
                        });
                      },
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
  function to move to last screen (in this case there are only two screens, so it returns always to the lifegoal_list)
  @return void
  */
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  /*
  function to update the priority with the right value
  @return void
  */
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        lifegoal.priority = 1;
        break;
      case 'Medium':
        lifegoal.priority = 2;
        break;
      case 'Low':
        lifegoal.priority = 3;
        break;
    }
  }

  /*
  function to get the priority as string value
  @param value (the value of the priority)
  @return priority (the priority as String value)
  */
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
      case 3:
        priority = _priorities[2];
        break;
    }
    return priority;
  }

  /*
  function to update when a lifegoal is completed. It shows a green checkmark in the card when the value is 1.
  @param value(the actual value of reached)
  @return void
  */
  void updateReachedAsInt(String value) {
    switch (value) {
      case 'Completed':
        lifegoal.reached = 1;
        break;
      case 'Not completed':
        lifegoal.reached = 0;
        break;
    }
  }

  /*
  function to get the completed lifegoal as a string
  @param value (the actual value of reached)
  @return reached (completed or not completed)
  */
  String getReachedAsString(int value) {
    String reached;
    switch (value) {
      case 1: // completed
        reached = _reached[0];
        break;
      case 0: // not completed
        reached = _reached[1];
        break;
    }
    return reached;
  }

  /*
  function to update the title
  @return void
  */
  void updateTitle() {
    lifegoal.title = titleController.text;
  }

  /*
  function to update the description
  @return void
  */
  void updateDescription() {
    lifegoal.description = descriptionController.text;
  }

  /*
  function to save the values
  @return void
  */
  void _save() async {
    titleController.text.isEmpty ? _validate = false : _validate = true;
    if (_validate) {
      moveToLastScreen();

      lifegoal.date = DateFormat.yMMMd().format(DateTime.now());
      int result;
      if (lifegoal.id != null) {
        result = await helper.updateLifegoal(lifegoal);
      } else {
        result = await helper.insertLifegoal(lifegoal);
      }

      if (result == 0) {
        _showAlertDialog('Status', 'Problem Saving Goal');
      }
    }else{
       _showAlertDialog('Status', 'The title field is required');
    }
  }

  /*
  function to delete a lifegoal
  @return void
  */
  void _delete() async {
    //show if the delete button is clicked before the data was created
    if (lifegoal.id == null) {
      _showAlertDialog('Status', 'No Goal was deleted');
    } else {
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
                    int result = await helper.deleteLifegoal(lifegoal.id);
                    if (result != 0) {
                      moveToLastScreen();
                    } else {
                      moveToLastScreen();
                    }
                    moveToLastScreen();
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
  }

  /*
  function to show a dialog when a lifegoal is saved or deleted
  @param title (what the dialog means (status, message, note etc.))
  @param message (the message that is displayed in the dialog)
  @return void
  */
  _showAlertDialog(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
