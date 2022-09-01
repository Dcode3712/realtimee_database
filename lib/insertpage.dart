import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:realtime_database/viewpage.dart';

class insertpage extends StatefulWidget {
  Map? m;

  insertpage({this.m});

  @override
  State<insertpage> createState() => _insertpageState();
}

class _insertpageState extends State<insertpage> {
  @override
  void initState() {
    super.initState();

    tname.text = widget.m!['Name'];
    tcontact.text = widget.m!['Contact No'];
  }

  TextEditingController tname = TextEditingController();
  TextEditingController tcontact = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(title: Text("Real Time DataBase Insertpage")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: tname,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      filled: true,
                      labelText: "Enter Name",
                      fillColor: Colors.transparent),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: tcontact,
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      filled: true,
                      labelText: "Enter Contact No",
                      fillColor: Colors.transparent,
                      prefixIcon: Icon(Icons.phone)),
                ),
                SizedBox(height: 15),
                ElevatedButton(
                    onPressed: () {
                      // FirebaseDatabase database = FirebaseDatabase.instance;  // AA Line no Lakhiye To pan Chale..

                      String name = tname.text;
                      String contact = tcontact.text;

                      if (widget.m == null) {
                        DatabaseReference ref = FirebaseDatabase.instance
                            .ref("realtime_contactbook")
                            .push();

                        String? userid = ref.key;

                        /*ref.set(name);
                      ref.set(contact);
                      ref.set(userid);
                      */

                        Map m = {
                          "UserId": userid,
                          "Name": name,
                          "Contact No": contact
                        };

                        ref.set(m);

                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return viewpage();
                          },
                        ));

                        Fluttertoast.showToast(
                            msg: "Save Contact",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                      else {

                        String userid = widget.m!['UserId'];

                        DatabaseReference ref = FirebaseDatabase.instance.ref("realtime_contactbook").child(userid);

                        /*ref.set(name);
                      ref.set(contact);
                      ref.set(userid);
                      */

                        Map m = {
                          "UserId": userid,
                          "Name": name,
                          "Contact No": contact
                        };

                        ref.set(m);

                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return viewpage();
                          },
                        ));

                        Fluttertoast.showToast(
                            msg: "Update Contact",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    child: Text("Update")),
              ]),
        ),
      ),
    ), onWillPop: goback);
  }

  Future<bool> goback()
  {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return viewpage();
      },));
      return Future.value();
  }
}
