import 'package:flutter/material.dart';
import 'dart:async';
import 'Model/User.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());
List<User> users = [];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Material App', home: myhomepage(title: "Emoji"));
  }
}

class myhomepage extends StatefulWidget {
  myhomepage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _myhomepagestate createState() => new _myhomepagestate();
}

class _myhomepagestate extends State<myhomepage> {
  http.Response response;

  Future<List<String>> getdata() async {
    response = await http.get(
        Uri.encodeFull("https://flutter-person-list.firebaseio.com/.json"),
        headers: {"Accept": "application/json"});

    var jsondata = json.decode(response.body);
    print(response.body);
    for (var u in jsondata) {
      users.add(new User(u["name"], u["picture"]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Text("Emoji"),
      ),
      body: c_futurebuilder(),
    );
  }

  Container c_futurebuilder() {
    return Container(
      child: FutureBuilder(
        future: getdata(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: Colors.amber[100],
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(users[index].picture),
                  ),
                  title: Text(users[index].name),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
