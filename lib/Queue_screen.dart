import 'package:flutter/material.dart';


class Queue extends StatefulWidget
{
  @override
  State<Queue> createState()=> _Queue();
}



class _Queue extends State<Queue>
{


  @override
  Widget build(BuildContext context){
    return Scaffold(

      body: Column(
        children: [
          Text( "Queue",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),

    );


  }

}