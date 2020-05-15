import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/widgets/progress.dart';


class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}


class _TimelineState extends State<Timeline> {
final userscollectionRef = Firestore.instance.collection('users');

            @override
            void initState(){
              super.initState();
            }

              @override
              Widget build(context) {
                return Scaffold( 
                  appBar: header(
                    context,
                    isAppTitle: true),
                    body:  Text("Timeline")
                  );
              }
 } 

// StreamBuilder<QuerySnapshot>(
//                         stream: userscollectionRef.snapshots(),
//                         builder: (context, snapshot){
//                           if(!snapshot.hasData){
//                             return circularProgress();
//                           }
//                           final children =  snapshot.data.documents.map((e) => Text(e['username'])).toList();
//                           return Container(
//                             child : ListView(
//                               children: children
//                               )
//                           );
//                         },
//                         )