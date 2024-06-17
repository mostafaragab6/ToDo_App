
import 'package:flutter/material.dart';

import 'Cubit/Cubit.dart';

Widget defaultButton (
    {
      double width = double.infinity,
      bool upper = false,
      Color color = Colors.blue,
      required String text,
      required void Function() function
    }
    )=> Container(
  decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: color

  ),
  height: 40.0,
  width: width,
  child:   MaterialButton(
    onPressed: function,
    child: Text( upper? text.toUpperCase() : text,
      style: TextStyle(
          color: Colors.white
      ),),

  ),
);

Widget defaultForm ({
  String? Function(String?)? onChange,
  required TextEditingController controller,
  required IconData prefix,
  IconData? suffix,
  required TextInputType type ,
  String? Function(String?)? validate,
  required String label,
  String? Function(String?)? onSupmit ,
  void Function()? onClick ,
  bool isPassword = false ,
  void Function()? onTap ,
}
    )=> TextFormField(


  onChanged:onChange ,
  onTap: onTap,
  obscureText: isPassword ? true : false,
  keyboardType: type,
  controller:controller ,
  validator: validate ,
  decoration: InputDecoration(

      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
      ),
      prefixIcon: Icon (prefix),
      suffixIcon:suffix !=null ? IconButton(onPressed: onClick,icon:Icon(suffix)) : null,
      label: Text(label)

  ),
  onFieldSubmitted: onSupmit,

);

Widget BuildTask (Map model , context) => Dismissible(
  key: Key(model['ID'].toString()),
  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child:   Row(

      children: [

        CircleAvatar(

          radius: 35.0,

          child: Text('${model['Time']}'),

        ),

        SizedBox(width: 10.0,),

        Expanded(

          child: Column(

            children: [

              Text('${model['Title']}',

                style: TextStyle(

                  fontSize: 25.0,

                  fontWeight: FontWeight.w300,

                ),),

              Text('${model['Date']}',

                style: TextStyle(

                    fontSize: 15.0,

                    fontWeight: FontWeight.w300,

                    color: Colors.grey[500]

                ),),



            ],

          ),

        ),

        IconButton(

            onPressed: (){

              AppCubit.get(context).UpdateDatabase(

                  state:'Done',

                  id: model["ID"]);

            },

            icon: Icon(Icons.check_box,

              color: Colors.green,)),

        IconButton(

            onPressed: (){

              AppCubit.get(context).UpdateDatabase(

                  state:'Archived',

                  id: model["ID"]);

            },

            icon: Icon(Icons.archive,

              color: Colors.grey,))

      ],

    ),

  ),
  onDismissed: (direction){
    AppCubit.get(context).DeleteFromDatabase(id: model["ID"]);
  },
);



void navigatTo(context , widget) => Navigator.push(context,
    MaterialPageRoute(builder:(context)=> widget)
);

void navigateAndFinish (context , widget)=>Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context)=>widget),
        (route) => false);






