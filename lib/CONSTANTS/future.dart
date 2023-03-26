import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test_app/SCREENS/homepage.dart';
import 'package:http/http.dart' as http;

import '../MODELS/weather_model.dart';

Future<List> weather_get(latitude, longitude) async {
  print('LAT $latitude LONG $longitude');
  var url = Uri.parse(
      'http://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&APPID=21d6e175e99da7893408f2c0d5f60fdc&units=metric');
  http.Response response = await http.get(url);
  var datas = [];
  // if (response.statusCode == 200) {
  datas = json.decode(response.body.substring(0));

  // }

  return datas;
}

Future create_user(uid, email) async {
  final doc_user = FirebaseFirestore.instance.collection('users').doc(uid);

  final json = {
    'uid': uid,
    'email': email,
    'latitude': '',
    'longitude': '',
  };
  await doc_user.set(json);
}

Future update_latlong(uid, lat, long) async {
  print('in future--$uid,$lat,$long');
  final doc_user = FirebaseFirestore.instance.collection('users');
  if (doc_user != null)
    await doc_user
        .doc(uid) // <-- Doc ID where data should be updated.
        .update({'longitude': long, 'latitude': lat});
}
