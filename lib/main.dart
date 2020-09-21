import 'package:flutter/material.dart';

List<Widget> todoList = <Widget>[];

void main() {
  runApp(MaterialApp(
    routes: {
      "/": (context) => ViewTasksScreen(),
      "/addTask": (context) => AddTaskScreen()
    },
  ));
}

class AddTaskScreen extends StatelessWidget {
  addToDo(ToDoWidget todo, BuildContext context) {
    if (todo.title.isNotEmpty) {
      todoList.add(todo);
      todoList.add(Divider());
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController(text: "");
    var messageController = TextEditingController(text: "");

    var setTaskName = Container(
        padding: EdgeInsets.all(20.0),
        child: TextField(
          decoration: InputDecoration(
              labelText: "ToDo Title", hintText: "Enter ToDo Title"),
          controller: nameController,
        ));
    var setTaskMessage = Container(
        padding: EdgeInsets.all(20.0),
        child: TextField(
          decoration: InputDecoration(
              labelText: "ToDo Message", hintText: "Enter ToDo Message"),
          controller: messageController,
        ));

    var submitBtn = Container(
        padding: EdgeInsets.only(top: 18.0),
        child: RaisedButton(
          child: Text("Add ToDo"),
          onPressed: () => addToDo(
              ToDoWidget(
                  nameController.text, messageController.text, DateTime.now()),
              context),
        ));
    var addTaskForm = Column(
      children: <Widget>[setTaskName, setTaskMessage, submitBtn],
    );
    return Scaffold(
      appBar: AppBar(title: Text("Add Task"), backgroundColor: Colors.orange),
      body: addTaskForm,
    );
  }
}

class ViewTasksScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ViewTaskScreenState();
  }
}

class ViewTaskScreenState extends State<ViewTasksScreen> {
  @override
  Widget build(BuildContext context) {
    var onNavigationTap = (int index) {
      if (index == 1) {
        Navigator.pushNamed(context, '/addTask');
      }
    };
    var bottomNavigationBar =
        BottomNavigationBar(onTap: onNavigationTap, items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("ToDos")),
      BottomNavigationBarItem(icon: Icon(Icons.add), title: Text("Add ToDos"))
    ]);

    var displayList;

    if (todoList.isNotEmpty) {
      displayList = todoList;
    } else {
      displayList = [
        Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              "No ToDos",
              style: TextStyle(fontSize: 30.0, color: Colors.orangeAccent),
            ))
      ];
    }
    return MaterialApp(
        home: Scaffold(
      bottomNavigationBar: bottomNavigationBar,
      appBar: AppBar(title: Text("To-Do List"), backgroundColor: Colors.orange),
      body: ListView(
        children: <Widget>[
          Container(
              child: Column(
            children: displayList,
          ))
        ],
      ),
    ));
  }
}

class ToDoWidget extends StatefulWidget {
  final String title;
  final String message;
  final DateTime date;
  ToDoWidget(this.title, this.message, this.date);

  @override
  State<StatefulWidget> createState() {
    return ToDoState(this.title, this.message, this.date);
  }
}

class ToDoState extends State<ToDoWidget> {
  String title;
  String message;
  DateTime date;

  ToDoState(this.title, this.message, this.date);

  @override
  Widget build(BuildContext context) {
    var titleController = TextEditingController(text: this.title);
    var textTitleFieldDecoration = InputDecoration(border: InputBorder.none);
    var textTitleFieldStyle = TextStyle(
        fontSize: 27.0, fontWeight: FontWeight.bold, color: Colors.orange);

    var title = TextField(
      controller: titleController,
      decoration: textTitleFieldDecoration,
      style: textTitleFieldStyle,
    );

    var message = Expanded(
        child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(this.message,
                    style: TextStyle(
                        fontSize: 15.0, color: Colors.orangeAccent)))));

    String dateString = "Created " +
        this.date.day.toString() +
        "/" +
        this.date.month.toString() +
        "/" +
        this.date.year.toString();
    var dateCreated = Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Text(dateString,
            style: TextStyle(fontSize: 15.0, color: Colors.orangeAccent)));

    var todoCart = Column(
      children: <Widget>[title, message, dateCreated],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
    return Container(
      width: 400.0,
      height: 200.0,
      alignment: Alignment.centerLeft,
      constraints: BoxConstraints(maxHeight: 150.0, maxWidth: 1000.0),
      padding: EdgeInsets.all(19.0),
      child: todoCart,
    );
  }

  void removeTodoItem(int index) {
    setState(() => todoList.removeAt(index));
  }

  void promptRemoveToDoItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Text('Mark "${todoList[index]}" as done?'),
              backgroundColor: Colors.orange,
              actions: <Widget>[
                new FlatButton(
                    child: new Text('CANCEL'),
                    onPressed: () => Navigator.of(context).pop()),
                new FlatButton(
                    child: new Text('MARK AS DONE'),
                    onPressed: () {
                      removeTodoItem(index);
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  Widget buildTodoList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        if (index < todoList.length) {
          return buildTodoItem(todoList[index], index);
        }
        return Container();
      },
    );
  }

  Widget buildTodoItem(todoText, int index) {
    return new ListTile(
        title: new Text(todoText), onTap: () => promptRemoveToDoItem(index));
  }
}
