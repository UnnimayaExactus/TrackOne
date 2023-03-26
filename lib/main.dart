import 'package:flutter/material.dart';
import 'package:flutter_test_app/SCREENS/registration.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'COMMON/validators.dart';
import 'CONSTANTS/future.dart';
import 'SCREENS/homepage.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  bool serviceEnabled = false;
  late LocationPermission permission;
  final _auth = FirebaseAuth.instance;
  late Position _currentPosition;

  String email = '', password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "Login Page",
      //     style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0),
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                'assets/icons/logo.jpg',
                height: 100,
                width: 150,
              ),
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
              Text(
                'Sign in to continue',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  return Validate.emailValidator(value!);
                },
                onChanged: (value) {
                  email = value; // get value from TextField
                },
                decoration: InputDecoration(
                    label: Text('Username'),
                    enabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide(width: 1))),
              ),
              SizedBox(
                height: 50.0,
              ),
              TextFormField(
                obscureText: true,
                validator: (value) {
                  return Validate.pwdValidator(value!);
                },
                onChanged: (value) {
                  password = value; //get value from textField
                },
                decoration: InputDecoration(
                    label: Text('Password'),
                    enabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide(width: 1))),
              ),
              SizedBox(
                height: 50.0,
              ),
              Center(
                child: Material(
                  elevation: 5,
                  color: Color.fromRGBO(139, 0, 0, 5),
                  borderRadius: BorderRadius.circular(32.0),
                  child: MaterialButton(
                    onPressed: () async {
                      setState(() {
                        permission_handler();
                        _getCurrentLocation();
                      });
                      try {
                        print(email);
                        print(password);
                        final newUser = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        // User? userFb = FirebaseAuth.instance.currentUser;
                        UserID = newUser.user!.uid;
                        Useremail = newUser.user!.email!;
                        UserName = Useremail.toString().split('@')[0];
                        print(newUser.toString());
                        print('//////////////${UserID.toString()}');

                        if (newUser != null) {
                          Fluttertoast.showToast(
                              msg: "Login Successfull",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              fontSize: 16.0);
                          setState(() {
                            (latitude != null && longitude != null)
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Homepage()),
                                  )
                                : Fluttertoast.showToast(
                                    msg: "Please Turn on the location",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    // timeInSecForIos: 1,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.red,
                                    fontSize: 16.0);
                          });
                        } else {
                          Fluttertoast.showToast(
                              msg: "Invalid User",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              // timeInSecForIos: 1,
                              backgroundColor: Colors.white,
                              textColor: Colors.red,
                              fontSize: 16.0);
                        }
                      } catch (e) {
                        // Fluttertoast.showToast(
                        //     msg: e,
                        //     toastLength: Toast.LENGTH_SHORT,
                        //     gravity: ToastGravity.CENTER,
                        //     timeInSecForIosWeb: 4,
                        //     backgroundColor: Colors.white,
                        //     textColor: Colors.red,
                        //     fontSize: 16.0);
                      }
                    },
                    minWidth: 300.0,
                    height: 45.0,
                    child: Text(
                      "Login Now",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20.0,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                height: 70,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w900),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
    setState(() {
      _currentPosition = position;
      // _geoLocation = "${position.latitude},${position.longitude}";
      latitude = position.latitude;
      longitude = position.longitude;
      print('LAT' + latitude.toString());
      print('LONG' + longitude.toString());
      // update_latlong(UserID, latitude, longitude).then((value) {
      //   print('UPDATE RESULT$value');
      // });
    });
  }

  void permission_handler() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled() ?? false;
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyLoginPage())));
    super.initState();
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: FadeTransition(
              opacity: animation,
              child: Image.asset(
                'assets/icons/logo.jpg',
                height: 500.0,
                width: 500.0,
                fit: BoxFit.fitWidth,
              )),
        ));
  }
}
