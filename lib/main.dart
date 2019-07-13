import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Wear Countdown",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WatchScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WatchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape) {
        return AmbientMode(
          builder: (context, mode) {
            return TimerScreen(mode);
          },
        );
      },
    );
  }
}

class TimerScreen extends StatefulWidget {
  Mode mode;

  TimerScreen(this.mode);

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Timer _timer;
  int _count;
  String _strCount;
  String _status;

  @override
  void initState() {
    _count = 0;
    _strCount = "00:00:00";
    _status = "Start";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.mode == Mode.active ? Colors.white : Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: FlutterLogo(),
            ),
            SizedBox(height: 4.0),
            Center(
              child: Text(
                _strCount,
                style: TextStyle(
                    color: widget.mode == Mode.active
                        ? Colors.black
                        : Colors.white),
              ),
            ),
            _buildWidgetButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetButton() {
    if (widget.mode == Mode.active) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          RaisedButton(
            child: Text("$_status"),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              if (_status == "Start") {
                _startTimer();
              } else if (_status == "Stop") {
                _timer.cancel();
                setState(() {
                  _status = "Continue";
                });
              } else if (_status == "Continue") {
                _startTimer();
              }
            },
          ),
          RaisedButton(
            child: Text("Reset"),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              if (_timer != null) {
                _timer.cancel();
                setState(() {
                  _count = 0;
                  _strCount = "00:00:00";
                  _status = "Start";
                });
              }
            },
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  void _startTimer() {
    _status = "Stop";
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _count += 1;
        int hour = _count ~/ 3600;
        int minute = (_count % 3600) ~/ 60;
        int second = (_count % 3600) % 60;
        _strCount = hour < 10 ? "0$hour" : "$hour";
        _strCount += ":";
        _strCount += minute < 10 ? "0$minute" : "$minute";
        _strCount += ":";
        _strCount += second < 10 ? "0$second" : "$second";
      });
    });
  }
}
