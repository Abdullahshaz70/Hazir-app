import 'dart:collection';
import 'dart:ffi';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'walkin_screen.dart';
import 'catalog_screen.dart';
import 'Queue_screen.dart';

class ProviderScreen extends StatefulWidget
{
  @override
  State<ProviderScreen> createState()=> _ProviderScreen();
}



class _ProviderScreen extends State<ProviderScreen>
{

  List<String> shop_status = ["Open" , "Closed"];

  int index = 0;

  final String name = "Provider";

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 3,

      child:  Scaffold(
      appBar: AppBar(
      title: Text(name),
      actions: [

          TextButton(
            onPressed: (){},
            child: Text(shop_status[index])
          ),

          TextButton(
            onPressed: (){
              setState(() {
                index = (index+1)%2;
              });
            },
            child: Text("Toggle")
          ),

          TextButton(
            onPressed: (){},
            child: Text("Logout")
          ),

        ],
      bottom: const TabBar(
        tabs: [
          Tab(text: "Queue"),
          Tab(text: "Walk-in"),
          Tab(text: "Catalog"),
        ]
        ),
      ),

      body: TabBarView(
        children: [
          Queue(),
          Walkin(),
          Catalog()
        ]
      ),
    
    ),
  
      
    );
    


  }

}