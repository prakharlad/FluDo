import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Ter extends StatefulWidget {
  @override
  _TerState createState() => _TerState();
}

class _TerState extends State<Ter> {
  var authc = FirebaseAuth.instance;
  var fstore = FirebaseFirestore.instance;
  myout(var a) async {
    // ignore: unnecessary_brace_in_string_interps
    var url = "http://192.168.1.52/cgi-bin/n.py?x=${a}";
    var r = await http.get(url);
    setState(() {
      out = r.body;
    });
    // ignore: unnecessary_brace_in_string_interps
    fstore.collection("linux").add({'cmd': '${cmd}', 'output': '${out}'});
  }

  var c = TextEditingController();
  var cmd;
  var out;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("FluDo"),
        leading: Image.asset("fludo_logo.png"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.history),
              onPressed: () {
                Navigator.pushNamed(context, "hist");
              }),
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                print("Sign out");
                await authc.signOut();
                Fluttertoast.showToast(
                    msg: "Successfully logged out",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                Navigator.pushNamed(context, "log");
              })
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("red_hat.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Card(
              color: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 20.0,
              child: Row(
                children: <Widget>[
                  Text(
                    "[root@localhost]",
                    style: TextStyle(color: Colors.white),
                  ),
                  Flexible(
                      child: TextField(
                    controller: c,
                    onChanged: (value) {
                      cmd = value;
                    },
                    style: TextStyle(color: Colors.white),
                  )),
                  IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        c.clear();
                        setState(() {
                          myout(cmd);
                        });
                      }),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Flexible(
              //height: MediaQuery.of(context).size.height * 0.5,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 15.0,
                color: Colors.black26,
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "[root@localhost] ",
                          style: TextStyle(color: Colors.white),
                        ),
                        Flexible(
                          child: Text(
                            out ?? " ",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
