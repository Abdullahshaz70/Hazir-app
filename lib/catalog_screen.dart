import 'package:flutter/material.dart';


class Catalog extends StatefulWidget
{
  @override
  State<Catalog> createState()=> _Catalog();
}



class _Catalog extends State<Catalog>
{


  @override
  Widget build(BuildContext context){
    return Scaffold(

      body: Column(
        children: [
          Text( "Catalog",
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