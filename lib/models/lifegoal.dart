/*
This class creates the LifeGoal object that is used with the Database
*/
class LifeGoal {
  //initalize variables (the table columns)
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;
  int _reached;
  //constructor
  LifeGoal(this._title, this._date, this._priority, this._reached, [this._description]);

  LifeGoal.withId(this._id, this._title, this._date, this._priority, this._reached,
      [this._description]);
  //getters
  int get id => _id;

  String get title => _title;

  String get description => _description;

  int get priority => _priority;

  String get date => _date;

  int get reached => _reached;
  //setters
  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }

  set priority(int newPriority) {
    this._priority = newPriority;
  }

  set date(String newDate) {
    this._date = newDate;
  }

  set reached(int reached){
    this._reached = reached;
  }
  /*
  function to create a map object of the columns (to use it in the database)
  @return map
  */
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }

    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;
    map['reached'] = _reached;

    return map;
  }
  /*
  function to set the column names to the map objects
  */
  LifeGoal.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._date = map['date'];
    this._reached = map['reached'];
  }
}
