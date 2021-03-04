import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:we_care/models/tracker.dart';
import 'package:we_care/Widgets/chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BloodPressureTrackerScreen extends StatefulWidget {
  @override
  _BloodPressureTrackerScreenState createState() =>
      _BloodPressureTrackerScreenState();
}

class _BloodPressureTrackerScreenState
    extends State<BloodPressureTrackerScreen> {
  getCurrentUser() async {
    await FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        userId = user.uid;
      });
    });
  }

  QuerySnapshot snapshot;
  String userId;
  double averageDiastolic, averageSystolic, averagePulse;
  BloodPressureTracker bloodPressure;
  getDocumentList() async {
    bloodPressure = BloodPressureTracker();
    snapshot = await Firestore.instance
        .collection('tracker')
        .document(userId)
        .collection('blood_pressure')
        .getDocuments();
    averageDiastolic = 0;
    double totalDiastolic = 0, totalSystolic = 0, totalPulse = 0;

    List<BloodPressure> list = bloodPressure.loadData(snapshot);
    for (var s in list) {
      totalDiastolic += s.diastolic;
      totalSystolic += s.systolic;
      totalPulse += s.pulse;
    }

    setState(() {
      averageDiastolic = totalDiastolic / list.length;
      averageSystolic = totalSystolic / list.length;
      averagePulse = totalPulse / list.length;
    });

    return snapshot;
  }

  PageController _controller;

  @override
  void initState() {
    getCurrentUser();
    _controller = PageController(
      initialPage: 0,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: <Widget>[
          FutureBuilder(
              future: getDocumentList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 8, 20, 0),
                          child: Text(
                            'Lower BP Level ',
                            style: TextStyle(
                              fontSize: 32,
                              color: Color(0xFFffc0b4),
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          margin: EdgeInsets.all(15),
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height / 1.7,
                            maxWidth: MediaQuery.of(context).size.width *
                                (snapshot.data.documents.length / 2.5),
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BloodPressureChart(
                                animate: true,
                                userID: userId,
                                type: 'Lower BP Level',
                              ),
                            ),
                            margin: EdgeInsets.all(8),
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.only(left: 8, right: 8),
                        child: ListTile(
                          subtitle: Text('Average Lower BP Values '),
                          title: Text(averageDiastolic.toStringAsFixed(2)),
                        ),
                      )
                    ],
                  );
                } else
                  return SizedBox();
              }),
          FutureBuilder(
              future: getDocumentList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 8, 20, 0),
                          child: Text(
                            'Upper BP Level',
                            style: TextStyle(
                              fontSize: 32,
                              color: Color(0xFFffc0b4),
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          margin: EdgeInsets.all(15),
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height / 1.7,
                            maxWidth: MediaQuery.of(context).size.width *
                                (snapshot.data.documents.length / 2.5),
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BloodPressureChart(
                                animate: true,
                                userID: userId,
                                type: 'Upper BP Level',
                              ),
                            ),
                            margin: EdgeInsets.all(8),
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.only(left: 8, right: 8),
                        child: ListTile(
                          subtitle: Text('Average Upper BP Values'),
                          title: Text(averageSystolic.toStringAsFixed(2)),
                        ),
                      )
                    ],
                  );
                } else
                  return SizedBox();
              }),
          FutureBuilder(
              future: getDocumentList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 8, 20, 0),
                          child: Text(
                            'Pulse',
                            style: TextStyle(
                              fontSize: 32,
                              color: Color(0xFFffc0b4),
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          margin: EdgeInsets.all(15),
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height / 1.7,
                            maxWidth: MediaQuery.of(context).size.width *
                                (snapshot.data.documents.length / 2.5),
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BloodPressureChart(
                                animate: true,
                                userID: userId,
                                type: 'pulse',
                              ),
                            ),
                            margin: EdgeInsets.all(8),
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.only(left: 8, right: 8),
                        child: ListTile(
                          subtitle: Text('Average Pulse'),
                          title: Text(averageSystolic.toStringAsFixed(2)),
                        ),
                      )
                    ],
                  );
                } else
                  return SizedBox();
              })
        ],
      ),
    );
  }
}
