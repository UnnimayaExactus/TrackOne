import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER_RIGHT,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.amberAccent,
      textColor: Colors.black,
      fontSize: 38.0);
}

card(text, page, color, context, image) {
  return Card(
    margin: EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () => {
        page != null
            ? Navigator.push(
                context, MaterialPageRoute(builder: (context) => page))
            : null
      },
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset('assets/icons/$image', width: 150, height: 100),
            // Icon(_icon, size: 70.0, color: color),
            Text(
              text,
              style: new TextStyle(fontFamily: 'Montserrat', fontSize: 13),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    ),
  );
}

alert(BuildContext context, _msg, _clr) {
  Widget okButton = TextButton(
    child: const Text("OK",
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
        )),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text(
      _msg,
      style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: _clr[700]),
    ),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
