import 'dart:async';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import '../models/nursery.dart';
import 'package:firebase_database/firebase_database.dart';

class NurseryPage extends StatefulWidget {
  final Nursery nursery;

  NurseryPage(this.nursery);

  @override
  _NurseryPageState createState() => _NurseryPageState(nursery);
}

var motion, Garbeg, sound, heart;

class _NurseryPageState extends State<NurseryPage> {
  final Nursery nursery;

  _NurseryPageState(this.nursery);

  void initState() {
    FirebaseDatabase.instance
        .reference()
        .child('incubators')
        .child('180619812')
        .child('Sound')
        .once()
        .then((DataSnapshot snap) {
      setState(() {
        sound = snap.value;
      });
    });

    FirebaseDatabase.instance
        .reference()
        .child('incubators')
        .child('180619812')
        .child('PIR_motion')
        .once()
        .then((DataSnapshot snap) {
      setState(() {
        motion = snap.value;
      });
    });

    FirebaseDatabase.instance
        .reference()
        .child('incubators')
        .child('180619812')
        .child('Status')
        .once()
        .then((DataSnapshot snap) {
      setState(() {
        Garbeg = snap.value;
      });
    });

    FirebaseDatabase.instance
        .reference()
        .child('incubators')
        .child('180619812')
        .child('Heart')
        .once()
        .then((DataSnapshot snap) {
      setState(() {
        heart = snap.value;
      });
    });
    super.initState();
  }


  Widget image_carousel = new Container(
    height: 300.0,
    child: new Carousel(
      boxFit: BoxFit.cover,
      images: [
        AssetImage('assets/nursery3.jpg'),
        AssetImage('assets/nursery2.jpg'),
        AssetImage('assets/nursery1.jpg'),
        AssetImage('assets/nursery4.jpg'),
        AssetImage('assets/nursery5.jpg'),
      ],
      autoplay: true,
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: Duration(milliseconds: 1000),
      dotSize: 4.0,
      indicatorBgPadding: 5.0,
      dotBgColor: Colors.transparent,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Stack(children: <Widget>[
          SizedBox(
            height: 250,
            width: double.infinity,
            child: image_carousel,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16.0, 200.0, 16.0, 16.0),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16.0),
                      margin: EdgeInsets.only(top: 16.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 96.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  nursery.title,
                                  style: Theme.of(context).textTheme.title,
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.all(0),
                                  title: Text('ID: ' + nursery.nationalID),
                                  subtitle: Text('cairo'),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                              image: AssetImage('assets/baby.jpg'),
                              fit: BoxFit.cover)),
                      margin: EdgeInsets.only(left: 16.0),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text("Baby information"),
                      ),
                      Divider(),
                      ListTile(
                        title: Text("motion "),
                        subtitle: Text('Status: ' + motion.toString()),
                        leading: Icon(Icons.directions_run),
                      ),
                      ListTile(
                        title: Text("Sound "),
                        subtitle: Text('Status: ' + sound.toString()),
                        leading: Icon(Icons.surround_sound),
                      ),
                      ListTile(
                        title: Text("Garbeg"),
                        subtitle: Text('Status: ' + Garbeg.toString()),
                        leading: Icon(Icons.flare),
                      ),
                      ListTile(
                        title: Text("Garbeg"),
                        subtitle: Text('Status: ' + heart.toString()),
                        leading: Icon(Icons.flare),
                      ),
                      ListTile(
                        title: Text("blood type"),
                        subtitle: Text(nursery.bloodType),
                        leading: Icon(Icons.merge_type),
                      ),
                      ListTile(
                        title: Text("Gander"),
                        subtitle: Text(nursery.gander),
                        leading: Icon(Icons.accessibility),
                      ),
                      ListTile(
                        title: Text("Age"),
                        subtitle: Text(nursery.age),
                        leading: Icon(Icons.supervised_user_circle),
                      ),
                      ListTile(
                        title: Text("About"),
                        subtitle: Text(nursery.description),
                        leading: Icon(Icons.person),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
