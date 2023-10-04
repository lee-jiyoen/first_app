import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'main.dart';
import 'home_page.dart';
import 'package:login/home_page.dart';

void realtime() async {
  FirebaseDatabase _realtime = FirebaseDatabase.instance;
  int day = 2;
  int hour = 4;
  int minute = 3;
  int month = 4;
  int second = 5;

  int warning = 0;
  int angle = 0;

  await _realtime.ref().child("time").set({
    "day": day,
    "hour": hour,
    "minute": minute,
    "month": month,
    "second": second,
  }); //time 안에 year,month,day 있음

  await _realtime.ref().child("warning").set({
    "warning": warning,
  }); //warning 안에 warning 있음

  await _realtime.ref().child("angle").set({
    "angle": angle,
  }); //angle 안에 angle

  //DataSnapshot _snapshop =_realtime.ref().child("test").get() as DataSnapshot;
  DataSnapshot _snapshot =
      await _realtime.ref().child("time").get(); //파이어베이스에 있는 time 모든 걸 읽어옴
  Map<dynamic, dynamic> _value =
      _snapshot.value as Map<dynamic, dynamic>; //읽어온걸 map화 시켜둠
  String TimeString = jsonEncode(_value); //string으로 변형시키고
  print(TimeString); //프린트 시킴

  DataSnapshot _warning_t = await _realtime.ref().child("warning").get();
  Map<dynamic, dynamic> value = _warning_t.value as Map<dynamic, dynamic>;
  String warning_value = jsonEncode(value);
  print(warning_value);

// 각 값을 분리하여 받고 출력
  int day_s = _value["day"] as int;
  int hour_s = _value["hour"] as int;
  int minute_s = _value["minute"] as int;
  int month_s = _value["month"] as int;
  int second_s = _value["second"] as int;

  print("Day: $day_s");
  print("Hour: $hour_s");
  print("Minute: $minute_s");
  print("Month: $month_s");
  print("Second: $second_s");
}
