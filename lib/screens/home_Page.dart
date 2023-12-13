import 'package:clock_task/dataProviders/app_data.dart';
import 'package:clock_task/widgets/custom_clock.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currIndex = 0;
  bool isSwitched = false;
  var text = 'Sound On';
  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        text = 'Sound On';
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
        text = 'Sound Off';
      });
      print('Switch Button is OFF');
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppData>(context);
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: Text(
          'Mindful Meal Timer',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(11),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: _buildPageIndicator(3),
            ),
            MyCircularProgressClock(
              remainingTime: const Duration(minutes: 5),
              onPause: () {
                print('Timer paused!');
              },
            ),
            SizedBox(height: 30),
            Switch(
              onChanged: toggleSwitch,
              value: isSwitched,
              activeColor: Colors.greenAccent,
              thumbColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.greenAccent;
                  }
                  return Colors.white;
                },
              ),
            ),
            Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.greenAccent,
              onPressed: () {
                switch (provider.gettimerStatus) {
                  case TimerStatus.stopped:
                    {
                      provider.setTimerStatus = TimerStatus.started;
                      break;
                    }
                  case TimerStatus.playing:
                    {
                      provider.setTimerStatus = TimerStatus.paused;
                      break;
                    }
                  case TimerStatus.paused:
                    {
                      provider.setTimerStatus = TimerStatus.playing;
                      break;
                    }
                  case TimerStatus.started:
                    {
                      break;
                    }
                }
              },
              child: Container(
                height: 50,
                width: double.maxFinite,
                child: Center(
                  child: Text(
                    provider.gettimerStatus == TimerStatus.stopped
                        ? 'Start'
                        : provider.gettimerStatus == TimerStatus.playing
                            ? 'Pause'
                            : provider.gettimerStatus == TimerStatus.paused
                                ? 'Resume'
                                : '',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 18),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            provider.gettimerStatus != TimerStatus.stopped
                ? MaterialButton(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.transparent,
                    onPressed: () {},
                    child: Container(
                      height: 50,
                      width: double.maxFinite,
                      child: Center(
                        child: Text(
                          "LET'S STOP I AM FULL NOW",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator(int length) {
    List<Widget> list = [];
    for (int i = 0; i < length; i++) {
      list.add(i == _currIndex ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return Container(
      height: 10,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive ? 10 : 8.0,
        width: isActive ? 12 : 8.0,
        decoration: BoxDecoration(
          boxShadow: [
            isActive
                ? BoxShadow(
                    color: Color(0XFF2FB7B2).withOpacity(0.72),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: Offset(
                      0.0,
                      0.0,
                    ),
                  )
                : BoxShadow(
                    color: Colors.transparent,
                  )
          ],
          shape: BoxShape.circle,
          color: isActive ? Color(0XFF6BC4C9) : Color(0XFFEAEAEA),
        ),
      ),
    );
  }
}
