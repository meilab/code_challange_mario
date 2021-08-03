import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

const double stageSize = 300;
const double size = 30;
const double wallHeight = 60;

enum Direction {
  Up,
  Down,
  None,
}

enum GameState {
  Running,
  Dead,
}

class _MyHomePageState extends State<MyHomePage> {
  double marioY = stageSize;
  double wallX = stageSize;
  Direction direction = Direction.None;
  GameState gameState = GameState.Running;

  @override
  void didChangeDependencies() {
    var duration = Duration(milliseconds: 5);
    Timer.periodic(duration, (timer) {
      double newMarioY = marioY;
      Direction newDirection = direction;

      switch (direction) {
        case Direction.Up:
          newMarioY--;
          if (newMarioY < 150) {
            newDirection = Direction.Down;
          }
          break;
        case Direction.Down:
          newMarioY++;
          if (newMarioY > stageSize) {
            newDirection = Direction.None;
          }
          break;
        case Direction.None:
          break;
      }

      if (wallX < size && marioY > stageSize - wallHeight) {
        setState(() {
          gameState = GameState.Dead;
        });
      }

      setState(() {
        wallX = (wallX - 1 + stageSize) % stageSize;
        marioY = newMarioY;
        direction = newDirection;
      });
    });

    // TODO: implement initState
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: gameState == GameState.Running
          ? GestureDetector(
              onTap: () {
                setState(() {
                  direction = Direction.Up;
                });
              },
              child: Container(
                  width: stageSize,
                  height: stageSize,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.black)),
                  child: Stack(
                    children: [
                      Positioned.fromRect(
                          rect: Rect.fromCenter(
                              center: Offset(size / 2, marioY - size / 2),
                              width: size,
                              height: size),
                          child: Container(color: Colors.orange)),
                      Positioned.fromRect(
                          rect: Rect.fromCenter(
                              center: Offset(
                                  wallX - size / 2, stageSize - wallHeight / 2),
                              width: size,
                              height: wallHeight),
                          child: Container(color: Colors.black))
                    ],
                  )),
            )
          : Center(
              child: Container(
                  child: Text(
                      "Game Over"))), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
