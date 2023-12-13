import 'package:flutter/foundation.dart';

enum TimerStatus { stopped, playing, paused, started }

enum Soundstatus { on, off }

class AppData extends ChangeNotifier {
  TimerStatus timerStatus = TimerStatus.stopped;
  Soundstatus soundstatus = Soundstatus.on;
  TimerStatus get gettimerStatus => timerStatus!;
  Soundstatus get getSoundStatus => soundstatus;

  set setTimerStatus(TimerStatus status) {
    timerStatus = status;
    notifyListeners();
  }

  set setSoundStatus(Soundstatus s) {
    soundstatus = s;
    notifyListeners();
  }
}
