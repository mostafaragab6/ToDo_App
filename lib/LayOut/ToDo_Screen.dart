import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../Models/Components.dart';
import '../Models/Cubit/Cubit.dart';
import '../Models/Cubit/States.dart';

class TodoAPP extends StatelessWidget {

  bool flag =false;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    void playAlarmSound() async {
      final player = AudioPlayer();
      await player.play(AssetSource('sounds/alarm.mp3'));
    }
    void showTimePickerDialog() async {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        final now = DateTime.now();
        var alarmDateTime = DateTime(now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);

        // Handle situations where the selected time has already passed in the current day


        try {
          await AndroidAlarmManager.oneShotAt(
            alarmDateTime, // Use the chosen alarmTime
            0, // Unique alarm ID
            playAlarmSound, // Function to play the sound at the alarm time
            exact: true,
            wakeup: true,
          );
        } catch (error) {
          // Handle any errors during alarm scheduling
          print('Error scheduling alarm: $error');
        }

        timeController.text = selectedTime.format(context).toString();
      }
    }
    return BlocProvider(

      create: (BuildContext context) => AppCubit()..CreateDataBase(),
      child: BlocConsumer<AppCubit , AppStates>(
        builder: (BuildContext context, state) {
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text('Todo App') ,
            ),
            body: ConditionalBuilder(
                condition: AppCubit.get(context).Screens.length >0,
                builder:(context)=> AppCubit.get(context).Screens[AppCubit.get(context).CurrentIndex],
                fallback: (context)=> Center(child: CircularProgressIndicator())
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                playAlarmSound();
                if(flag){
                  if(formKey.currentState!.validate()) {
                    AppCubit.get(context).InsertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text).then((value) {

                      Navigator.pop(context);
                      flag = false;
                    });

                  }
                }
                else {
                  scaffoldKey.currentState!.showBottomSheet((context) =>
                      Form(
                        key: formKey,
                        child: Container(
                          padding: EdgeInsetsDirectional.all(10.0),
                          color: Colors.grey[100],
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultForm(
                                  controller: titleController,
                                  prefix: Icons.title,
                                  type: TextInputType.text,
                                  validate: (value){
                                    if(value!.isEmpty){
                                      return 'Title must not be empty';
                                    }
                                  },
                                  label: "Title"),
                              SizedBox(height: 10.0,),
                              defaultForm(
                                  controller: timeController,
                                  prefix: Icons.watch_later_outlined,
                                  type: TextInputType.none,
                                  onTap: showTimePickerDialog,
                                  validate: (value){

                                    if(value!.isEmpty){
                                      return 'Time must not be empty';
                                    }

                                  },
                                  label: "Time"),
                              SizedBox(height: 10.0,),

                              defaultForm(
                                  controller: dateController,
                                  prefix: Icons.calendar_month,
                                  type: TextInputType.none,
                                  onTap: (){
                                    showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse("2032-05-03")
                                    ).then((value) {
                                      dateController.text= DateFormat.yMMMd().format(value!);

                                    });
                                  },
                                  validate: (value){
                                    if(value!.isEmpty){
                                      return 'Date must not be empty';
                                    }
                                  },
                                  label: "Date"),
                            ],
                          ),
                        ),
                      ));
                  flag = true ;
                }
              },
              child: Icon(Icons.add),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: AppCubit.get(context).CurrentIndex,
              onTap: (index){
                AppCubit.get(context).ChangeNavBar(index: index);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu),
                    label: "New Tasks"
                ),
                BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline),
                    label: "Done Tasks"
                ),
                BottomNavigationBarItem(icon: Icon(Icons.archive),
                    label: "Archived Tasks"
                ),

              ],
            ),
          );
        },
        listener: (BuildContext context, Object? state) {  },

      ),
    );
  }
}
