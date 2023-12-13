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
  bool isSwitched = true;
  var text = 'Sound On';

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppData>(context);
    String bigText = '';
    String subText = '';
    Duration d = Duration();
    void toggleSwitch(bool value) {
      if (isSwitched == false) {
        Future.delayed(Duration.zero, () {
          provider.setSoundStatus = Soundstatus.on;
          setState(() {
            isSwitched = true;
            text = 'Sound On';
          });
          print('Switch Button is ON');
        });
      } else {
        Future.delayed(Duration.zero, () {
          provider.setSoundStatus = Soundstatus.off;
          setState(() {
            isSwitched = false;
            text = 'Sound Off';
          });
          print('Switch Button is OFF');
        });
      }
    }

    if (_currIndex == 0) {
      bigText = 'Nom Nom:)';
      subText =
          'You have 10 minutes to eat before the pause. Focus on eating slowly';
      d = Duration(seconds: 600);
    } else if (_currIndex == 1) {
      bigText = 'Break Time';
      subText = 'Take a five minute break to check on your level of fullness';
      d = Duration(seconds: 300);
    } else {
      bigText = 'Finish your meal';
      subText = 'You can eat your meal until full';
      d = Duration(seconds: 30);
    }
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(3),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                bigText,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                subText,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              MyCircularProgressClock(
                remainingTime: d,
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
                    case TimerStatus.completed:
                      {
                        provider.setTimerStatus = TimerStatus.stopped;
                      }
                  }
                },
                child: Container(
                  height: 50,
                  width: double.maxFinite,
                  child: Center(
                    child: Text(
                      (provider.gettimerStatus == TimerStatus.stopped ||
                              provider.gettimerStatus == TimerStatus.completed)
                          ? 'Start'
                          : (provider.gettimerStatus == TimerStatus.playing ||
                                  provider.gettimerStatus ==
                                      TimerStatus.started)
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
                      onPressed: () {
                        setState(() {
                          if (_currIndex >= 0 && _currIndex <= 2) {
                            _currIndex++;
                          }
                        });
                        provider.setTimerStatus = TimerStatus.stopped;
                      },
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
