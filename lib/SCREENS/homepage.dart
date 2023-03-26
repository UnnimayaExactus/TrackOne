import 'package:flutter/material.dart';
import 'package:flutter_test_app/CONSTANTS/future.dart';
import 'package:flutter_test_app/SCREENS/userlist.dart';
import '../CONSTANTS/willpopup.dart';
import 'Map_View.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets.dart';

String UserID = '';
String UserName = '';
String Useremail = '';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

final pages = [
  const MapView(),
  AppUser(),
];
late Position _currentPosition;
String _geoLocation = '';
var latitude;
var longitude;

class _HomepageState extends State<Homepage> {
  bool serviceEnabled = false;
  late LocationPermission permission;
  int pageIndex = 0;
  @override
  void initState() {
    update_latlong(UserID, latitude, longitude);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          UserName.toString(),
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: pages[pageIndex],
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 60,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 0;
              });
            },
            icon: pageIndex == 0
                ? const Icon(
                    Icons.home_outlined,
                    color: Colors.black,
                    size: 35,
                  )
                : const Icon(
                    Icons.home_outlined,
                    color: Colors.black,
                    size: 35,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 1;
              });
            },
            icon: pageIndex == 1
                ? const Icon(
                    Icons.person_2_outlined,
                    color: Colors.black,
                    size: 35,
                  )
                : const Icon(
                    Icons.person_2_outlined,
                    color: Colors.black,
                    size: 35,
                  ),
          ),
        ]),
      ),
      endDrawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ), //BoxDecoration
              child: UserAccountsDrawerHeader(
                accountName: Text(
                  "$UserName",
                  style: TextStyle(fontSize: 18),
                ),
                accountEmail: Text('$Useremail'),
                currentAccountPictureSize: Size.square(50),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 165, 255, 137),
                  child: Text(
                    '${UserName.substring(0, 1)}',
                    style: TextStyle(fontSize: 30.0, color: Colors.blue),
                  ), //Text
                ), //circleAvatar
              ), //UserAccountDrawerHeader
            ), //DrawerHeader
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(' My Profile '),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            ),
          ],
        ),
      ),
    );
  }
}
