import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'insertpage.dart';

class viewpage extends StatefulWidget {
  const viewpage({Key? key}) : super(key: key);

  @override
  State<viewpage> createState() => _viewpageState();
}

class _viewpageState extends State<viewpage> {
  List l = [];

  @override
  void initState() {
    super.initState();

    loadData();
  }

  loadData() async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("realtime_contactbook");

    DatabaseEvent de = await ref.once();

    DataSnapshot ds = de.snapshot;

    print(ds.value);

    Map map = ds.value as Map;

    map.forEach((key, value) {
      l.add(value);
    });

    setState(() {
      print(l);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("RealTime DataBase View Page")),
      body: l.length > 0
          ? ListView.builder(
              itemCount: l.length,
              itemBuilder: (context, index) {
                Map m = l[index];

                return ListTile(


                  onLongPress: () {
                    // Navigator.pop(context);

                    showDialog(
                        builder: (context1) {
                          return AlertDialog(
                            title: Text("Delete",style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,decoration: TextDecoration.underline),),
                            content: Text("Are You Sure ${m['Name']} Delete??"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context1);
                                  },
                                  child: Text(
                                    "Cancle",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context1);

                                    String userid = m['UserId'];

                                    DatabaseReference ref = FirebaseDatabase
                                        .instance
                                        .ref("realtime_contactbook")
                                        .child(userid);

                                    ref.remove();

                                    Fluttertoast.showToast(
                                        msg: "Deleted",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 2,
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white,
                                        fontSize: 16.0);

                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                      builder: (context) {
                                        return viewpage();
                                      },
                                    ));
                                  },
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  )),
                            ],
                          );
                        },
                        context: context);
                  },
                  onTap: () {
                    // Navigator.pop(context);

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                      return insertpage(m: m);
                    },));
                  },
                  title: Text("${m['Name']}"),
                  subtitle: Text("${m['Contact No']}"),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return insertpage();
            },
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
