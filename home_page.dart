/*  */ //import 'package:c_clinic/today_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'today_page.dart';
import 'login_page.dart';
import 'week_page.dart';
import 'chatbot_page.dart';
import 'main.dart';
import 'setting_page.dart';
import 'package:login/realtime.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController jobController = TextEditingController();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  //TextEditingController jobController = TextEditingController();
  bool isOn = false;
  //String _str = '';
  bool isLoading = false;
  String _str = '고부기를 눌러 카메라 on';

  void _onPressed(BuildContext context) {
    if (isLoading) {
      return; // 이미 로딩 중이면 아무것도 하지 않음
    }
    setState(() {
      //isOn = !isOn; // toggle isOn 상태
      if (isOn == true) {
        isLoading = true;
        _str = "고부기를 눌러 카메라 off";
        /*   final DatabaseReference _realtimeDatabase =
            FirebaseDatabase.instance.ref();

        try {
          // 'switch' 변수에 1을 업데이트
          await _realtimeDatabase.child('switch').set(1);
          print("화면 켜짐");
        } catch (error) {
          print('Firebase 업데이트 중 오류 발생: $error');
        } */
      } // 로딩 상태 시작
      else if (isOn == false) {
        _str = "고부기를 눌러 카메라 on";
        /*     final DatabaseReference _realtimeDatabase =
            FirebaseDatabase.instance.ref();

        try {
          // 'switch' 변수에 1을 업데이트
          await _realtimeDatabase.child('switch').set(0);
          print("화면 꺼짐");
        } catch (error) {
          print('Firebase 업데이트 중 오류 발생: $error');
        } */
      }
    });
    // 10초 동안 로딩을 표시한 후에 로딩을 종료
    Future.delayed(Duration(seconds: 10), () {
      setState(() {
        isLoading = false; // 로딩 상태 종료
      });
    });
  }

  @override
  void initState() {
    super.initState();
    //print('실행전 ');
    _initializeNotifications();
    //_listenForWarningChanges();
    DatabaseReference warref =
        FirebaseDatabase.instance.ref('/warning/warning');
    warref.onValue.listen((DatabaseEvent event) {
      _listenForWarningChanges();
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });

    //_configureFirebaseMessaging();

    //_listenForWarningChanges();
    //FirebaseDatabase _realtime = FirebaseDatabase.instance;
  }

  Future<void> _initializeNotifications() async {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'));
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(RemoteMessage message) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      //'your channel description',
      importance: Importance.max,
      priority: Priority.high,
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  void _listenForWarningChanges() {
    DatabaseReference _warningRef =
        FirebaseDatabase.instance.ref('/warning/warning');
    //FirebaseDatabase.instance.ref().child("warning");
    _warningRef.onValue.listen((DatabaseEvent event) {
      int warningValue = event.snapshot.value as int;
      print("warning값 확인 :");
      print(warningValue);
      if (warningValue != 0) {
        _sendPushNotification();
      }
    });
  }

  Future<void> _sendPushNotification() async {
    try {
      /* RemoteMessage notificationMessage = RemoteMessage(
        data: {
          'title': '경고 알림',
          'body': '자세를 고치세요!',
        },
      ); */
      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        //'your channel description',
        importance: Importance.max,
        priority: Priority.high,
      );

      final NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await _flutterLocalNotificationsPlugin.show(
        0, // 알림 ID
        '경고', // 알림 제목
        '자세를 고치세요!', // 알림 내용
        platformChannelSpecifics,
        payload: 'custom_notification',
      );
      //await FirebaseMessagg.instance._showNotification(notificationMessage);
      //_showNotification(notificationMessage);
      //await FirebaseMessaging.instance.(notificationMessage);
      print('푸시 알림이 성공적으로 전송되었습니다.');
    } catch (e) {
      print('푸시 알림 전송 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "c-clinic",
          style: TextStyle(fontSize: 38, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        elevation: 20.0,
        backgroundColor: clinic_color,
        actions: [
          TextButton(
            child: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              //print("sign out");
              // 환경설정페이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingPage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        left: true,
        right: true,
        child: Column(
          children: [
            SizedBox(
              height: 130,
            ),
            IconButton(
                //today
                iconSize: 120.0,
                onPressed: () {
                  isOn = !isOn; //toggle
                  _onPressed(context);
                },
                icon: Image.asset(
                  'assets/images/rogo.png',
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(
                '$_str',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(255, 78, 78, 78),
                ),
              ),
            ),
            Container(
              width: 390,
              height: 130,
              margin: EdgeInsets.fromLTRB(30, 110, 30, 0),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(20)),
              child: Row(children: [
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        //today
                        iconSize: 75.0,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TodayPage()),
                          );
                        },
                        icon: Image.asset(
                          'assets/images/today.png',
                        )),
                    IconButton(
                        //week
                        iconSize: 75.0,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => WeekPage()),
                          );
                        },
                        icon: Image.asset(
                          'assets/images/week.png',
                        )),
                    IconButton(
                        //chatbot
                        iconSize: 75.0,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatbotPage()),
                          );
                        },
                        icon: Image.asset(
                          'assets/images/chatbot.png',
                        )),
                  ],
                )
              ]),
            )
          ],
        ),
      ),
      // 모달 다이얼로그
      floatingActionButton: isLoading
          ? Stack(
              children: [
                Opacity(
                  //뿌옇게~
                  opacity: 0.4, //0.5만큼~
                  child: ModalBarrier(
                      dismissible: false, color: Colors.black), //클릭 못하게~
                ),
                Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        '카메라를 보며 정자세를 유지해 주세요.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )),
              ],
            )
          : null,
    );
  }
}

// class Loading extends StatefulWidget {
//   const Loading({super.key});

//   @override
//   State<Loading> createState() => _LoadingState();
// }

// class _LoadingState extends State<Loading> with TickerProviderStateMixin {
//   late AnimationController controller;
//   //const Loading({super.key});

//   @override
//   void initState() {
//     controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 10),
//     );
//     controller.repeat(reverse: true);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             Text(
//               '10초만 가만히 있어보쇼',
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             CircularProgressIndicator(
//               value: controller.value,
//               //semanticsLabel: 'Circular progress indicator',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }