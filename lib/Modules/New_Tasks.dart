import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Models/Components.dart';
import '../Models/Cubit/Cubit.dart';
import '../Models/Cubit/States.dart';

class NewTasks extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppStates>(
      builder: (BuildContext context, AppStates state) {
        return ListView.separated(
            itemBuilder: (context , index) =>BuildTask(AppCubit.get(context).newTasks[index] , context),
            separatorBuilder: (context , index) => Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey,
              ),
            ),
            itemCount: AppCubit.get(context).newTasks.length);
      },
      listener: (BuildContext context, AppStates state) {  },
    );
  }
}
