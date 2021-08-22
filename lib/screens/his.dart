import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Hist extends StatefulWidget {
  @override
  _HistState createState() => _HistState();
}

class _HistState extends State<Hist> {
  var i;
  List<Widget> out = [];
  var fstore = FirebaseFirestore.instance;
  myhis() async {
    var d = await fstore.collection("linux").get();
    for (i in d.docs) {
      var c = i.data()["cmd"];
      var o = i.data()["output"];
      var wid = Text(
        "$c : $o",
        style: TextStyle(color: Colors.white),
      );

      out.add(wid);
    }
  }

  void initState() {
    super.initState();
    myhis();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("History"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.tv),
                onPressed: () {
                  Navigator.pushNamed(context, "ter");
                }),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("red_hat.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView.builder(
              itemCount: out.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Colors.black12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 15.0,
                  child: out[index],
                );
              }),
        ));
  }
}
