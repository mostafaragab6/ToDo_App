import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'LayOut/ToDo_Screen.dart';
void main()async {

  WidgetsFlutterBinding.ensureInitialized();

  await AndroidAlarmManager.initialize();

  runApp( MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return
       MaterialApp(

              debugShowCheckedModeBanner: false,
              home:TodoAPP()
      );



  }

}