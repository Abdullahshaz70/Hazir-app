import 'package:flutter/material.dart';


class Walkin extends StatefulWidget
{
  @override
  State<Walkin> createState()=> _Walkin();
}



class _Walkin extends State<Walkin>
{


  @override
  Widget build(BuildContext context){
    return Scaffold(

      body: Column(
        children: [
          Text( "Add in Walk-in Customer",
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