import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../Modules/Archieved_Tasks.dart';
import '../../Modules/Done_Tasks.dart';
import '../../Modules/New_Tasks.dart';
import 'States.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super (AppInitialState()) ;

  static AppCubit get(context)=> BlocProvider.of(context);

  Database? database;
  int CurrentIndex =0;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  List<Widget> Screens= [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks()
  ];


  void ChangeNavBar({
    required int index
  }){
    CurrentIndex = index;
    emit(ChangeNavBarState());
  }


  void CreateDataBase (){
    openDatabase(
        'TODO.db',
        version: 1,
        onCreate: (database ,version){
          database.execute(
              'CREATE TABLE Tasks (ID INTEGER PRIMARY KEY ,Title Text, State TEXT , Time TEXT , Date TEXT)'
          ).then((value) {

            print("Database created");
          });
        },
        onOpen: (database){
          GetData(database);
          print("Database opened");
        }

    ).then((value) {
      database = value;
      emit(CreateDatabaseState());
    });
  }

  Future InsertToDatabase({
    required String title,
    required String time,
    required String date
  }){
    return database!.transaction((txn) {
      txn.rawInsert('INSERT INTO Tasks(Title , Date , Time , State) VALUES ("$title","$date","$time","New")'
      ).then((value) {
        print("Row inserted Successfully");
        emit(InsertToDatabaseState());

        GetData(database);

      });

      return Future(() => null);

    });

  }

  void GetData (database){
    newTasks =[];
    doneTasks=[];
    archivedTasks =[];

    database.rawQuery('SELECT * FROM Tasks').then((value){

      value.forEach((element) {

        if(element['State']== 'New'){
          newTasks.add(element);
        }
        else if(element['State']== 'Done'){
          doneTasks.add(element);
        }
        else archivedTasks.add(element);


      });
      emit(GetDataState());
      print(newTasks);
    });

  }

  void UpdateDatabase ({
    required String state,
    required int id
  }){

    database!.rawUpdate("UPDATE Tasks SET State=? WHERE ID=?",['$state', id]
    ).then((value) {
      GetData(database);
      emit(UpdateDataState());
    });

  }

  void DeleteFromDatabase ({
    required int id
  }){

    database!.rawDelete("DELETE FROM Tasks WHERE ID=? ",[id]
    ).then((value) {
      GetData(database);
      emit(DeleteFromDataState());
    });

  }


}




