import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test_app/CONSTANTS/future.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';

import '../COMMON/validators.dart';
import '../main.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = FirebaseAuth.instance;
  bool showProgress = false;

  String email = '', password = '';
  TextEditingController conform_password = TextEditingController();
  TextEditingController pass_word = TextEditingController();
  var registerKey = new GlobalKey<FormState>();
  bool terms = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
        child: SingleChildScrollView(
          child: Form(
            key: registerKey,
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
                  'Sign Up',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value; //get the value entered by user.
                  },
                  validator: (value) {
                    return Validate.emailValidator(value!);
                  },
                  decoration: InputDecoration(
                      label: Text('Username'),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1))),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: pass_word,
                  obscureText: true,
                  validator: (value) {
                    return Validate.pwdValidator(value!);
                  },
                  onChanged: (value) {
                    password = value; //get the value entered by user.
                  },
                  decoration: InputDecoration(
                      label: Text('Password'),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1))),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: conform_password,
                  obscureText: true,
                  validator: (value) {
                    print(pass_word.text);
                    print(conform_password.text);
                    if (pass_word.text != conform_password.text) {
                      return 'Password and Confirm Password Mismatch';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    password = value; //get the value entered by user.
                  },
                  decoration: InputDecoration(
                      label: Text('Conform Password'),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1))),
                ),
                SizedBox(
                  height: 30.0,
                ),
                FormField<bool>(
                  builder: (state) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                value: terms,
                                onChanged: (newValue) {
                                  setState(() {
                                    terms = newValue as bool;
                                  });
                                }),
                            Text('I agree with TERMS & CONDITIONS'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              state.errorText ?? '',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                  validator: (value) {
                    if (!terms) {
                      return 'You need to accept the terms';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: Material(
                    elevation: 5,
                    color: Color.fromRGBO(139, 0, 0, 5),
                    borderRadius: BorderRadius.circular(32.0),
                    child: MaterialButton(
                      onPressed: () async {
                        setState(() {
                          showProgress = true;
                        });
                        if (registerKey.currentState!.validate())
                          try {
                            await _auth
                                .createUserWithEmailAndPassword(
                                    email: email, password: password)
                                .then((value) {
                              create_user(
                                value.user!.uid,
                                email,
                              );

                              if (value.user!.uid != null) {
                                Fluttertoast.showToast(
                                    msg: "Successfully Registered to TrackOne",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.black,
                                    fontSize: 16.0);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyLoginPage()),
                                );

                                setState(() {
                                  showProgress = false;
                                });
                              }
                            });
                          } catch (e) {}
                      },
                      minWidth: 300.0,
                      height: 45.0,
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
