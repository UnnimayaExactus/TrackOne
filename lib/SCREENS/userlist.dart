import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test_app/MODELS/weather_model.dart';
import 'package:flutter_test_app/SCREENS/homepage.dart';
import 'Map_View.dart';

class AppUser extends StatefulWidget {
  @override
  State<AppUser> createState() => _AppUserState();
}

class _AppUserState extends State<AppUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              return Container(
                child: Card(
                    child: ListTile(
                  title: Text(
                    document['email'].toString().split('@')[0],
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  subtitle: Text(document['uid'].toString()),
                  onTap: () {
                    setState(() {
                      latitude = document['latitude'];
                      longitude = document['longitude'];
                      UserName = document['email'].toString().split('@')[0];
                      if (latitude != null && longitude != null)
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Homepage()),
                        );
                    });
                  },
                )),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
