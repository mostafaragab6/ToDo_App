
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Models/Components.dart';
import '../Models/Cubit/Cubit.dart';
import '../Models/Cubit/States.dart';

class DoneTasks extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppStates>(
      builder: (BuildContext context, AppStates state) {
        return ListView.separated(
            itemBuilder: (context , index) =>BuildTask(AppCubit.get(context).doneTasks[index],context),
            separatorBuilder: (context , index) => Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey,
              ),
            ),
            itemCount: AppCubit.get(context).doneTasks.length);
      },
      listener: (BuildContext context, AppStates state) {  },
    );
  }
}
