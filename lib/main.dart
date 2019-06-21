import 'package:flutter/material.dart';
import 'package:refresh_upload/page/EmptyPage.dart';
import 'package:refresh_upload/page/ErrorPage.dart';
import 'package:refresh_upload/page/GridPage.dart';
import 'package:refresh_upload/page/ListPage.dart';
import 'package:refresh_upload/page/SliverGridPage.dart';
import 'package:refresh_upload/page/SliverListPage.dart';
import 'package:refresh_upload/page/TestPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Text("list"),
              onPressed: () => {Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListPage()))},
              color: Colors.blue,
            ),
            FlatButton(
              child: Text("grid"),
              onPressed: () => {Navigator.of(context).push(MaterialPageRoute(builder: (context) => GridPage()))},
              color: Colors.blue,
            ),
            FlatButton(
              child: Text("sliverlist"),
              onPressed: () => {Navigator.of(context).push(MaterialPageRoute(builder: (context) => SliverListPage()))},
              color: Colors.blue,
            ),
            FlatButton(
              child: Text("slivergrid"),
              onPressed: () => {Navigator.of(context).push(MaterialPageRoute(builder: (context) => SliverGridPage()))},
              color: Colors.blue,
            ),
            FlatButton(
              child: Text("empty"),
              onPressed: () => {Navigator.of(context).push(MaterialPageRoute(builder: (context) => EmptyPage()))},
              color: Colors.blue,
            ),
            FlatButton(
              child: Text("error"),
              onPressed: () => {Navigator.of(context).push(MaterialPageRoute(builder: (context) => ErrorPage()))},
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
