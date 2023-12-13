import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:clock_task/dataProviders/app_data.dart';
import 'package:flutter/material.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:provider/provider.dart';

class MyCircularProgressClock extends StatefulWidget {
  final Duration remainingTime;
  final VoidCallback onPause;

  MyCircularProgressClock(
      {Key? key, required this.remainingTime, required this.onPause})
      : super(key: key);

  @override
  _MyCircularProgressClockState createState() =>
      _MyCircularProgressClockState();
}

class _MyCircularProgressClockState extends State<MyCircularProgressClock> {
  PausableTimer? timer;
  final player = AudioPlayer();
  int remainingSeconds = 0; // Start from 10 minutes
  bool soundOn = true;
  bool _completed = false;
  var _status = TimerStatus.stopped;

  @override
  void initState() {
    remainingSeconds = widget.remainingTime.inSeconds;
    super.initState();
  }

  void startTimer() {
    if (remainingSeconds > 0) {
      final initialProgress =
          (widget.remainingTime.inSeconds - remainingSeconds) /
              widget.remainingTime.inSeconds;
      timer = PausableTimer(
        Duration(seconds: 1),
        () async {
          setState(() {
            remainingSeconds -= 1; // Decrease remaining time
          });
          if (remainingSeconds <= 5 && remainingSeconds >= 0 && soundOn) {
            await player.play(AssetSource('countdown_tick.mp3'));
            player.setReleaseMode(ReleaseMode.loop);
          }
          if (remainingSeconds <= 0) {
            await player.stop();
            stopTimer();
            setState(() {
              _completed = true;
            });
          } else {
            Future.delayed(Duration(seconds: 1),
                startTimer); // Schedule the next iteration only if remaining time > 0
          }
        },
      );
      timer?.start();
    }
  }

  void stopTimer() {
    timer?.cancel();
  }

  @override
  void pauseTimer() {
    if (!(timer!.isPaused)) {
      timer?.pause();
    }
  }

  void resumeTimer() {
    if (timer != null) {
      if (timer!.isPaused) {
        timer?.start();
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppData>(context);
    if (_completed) {
      Future.delayed(Duration.zero, () {
        provider.setTimerStatus = TimerStatus.completed;
      });
      remainingSeconds = 0;
    }
    if (provider.gettimerStatus == TimerStatus.started) {
      if (_status == TimerStatus.stopped) {
        setState(() {
          remainingSeconds = widget.remainingTime.inSeconds;
        });
        _completed = false;

        startTimer();

        Future.delayed(Duration.zero, () {
          provider.setTimerStatus = TimerStatus.playing;
        });
      }
    }
    if (provider.gettimerStatus == TimerStatus.paused) {
      pauseTimer();
    } else if (provider.gettimerStatus == TimerStatus.playing) {
      resumeTimer();
    }
    if (provider.getSoundStatus == Soundstatus.off) {
      if (soundOn == true) {
        soundOn = false;
      }
    } else {
      if (soundOn == false) {
        soundOn = true;
      }
    }
    var minutes = remainingSeconds ~/ 60;
    var seconds = remainingSeconds % 60;
    var progress = (remainingSeconds / widget.remainingTime.inSeconds);
    if (provider.gettimerStatus == TimerStatus.stopped) {
      minutes = 0;
      seconds = 0;
      progress = 0;
      remainingSeconds = 0;
      _completed = false;
    }
    return Container(
      margin: EdgeInsets.all(27),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white, // Set the background color if needed
      ),
      child: Container(
        width: double
            .infinity, // Set the width to cover the entire parent container
        height: 320,
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: CustomPaint(
          size: Size(150, 150),
          painter: MyPainter(progress),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none),
                ),
                Text(
                  'minutes remaining',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black38,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final double progress;

  MyPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw the progress bar.
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        2 * pi * progress, false, paint);
    // Draw the minute markers.
    for (int i = 0; i < 60; i++) {
      final minuteProgress = i / 60;
      if (minuteProgress <= progress) {
        paint.color = Colors.green;
      } else {
        paint.color = Colors.grey;
      }
      final minuteAngle = 2 * pi * minuteProgress - pi / 2;
      final innerPoint = center +
          Offset(cos(minuteAngle), sin(minuteAngle)) *
              (i % 15 == 0 ? radius - 20 : radius - 10);
      final outerPoint =
          center + Offset(cos(minuteAngle), sin(minuteAngle)) * radius;
      canvas.drawLine(innerPoint, outerPoint, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is MyPainter) {
      return oldDelegate.progress != progress;
    }
    return true;
  }
}
