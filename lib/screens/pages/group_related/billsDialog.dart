import 'package:app/models/BillDetails.dart';
import 'package:app/models/MemberDetails.dart';
import 'package:app/screens/pages/Items/itemPage.dart';
import 'package:app/services/database.dart';
import 'package:flutter/material.dart';

class BillsDialog extends StatefulWidget {
  final DataBaseService dbService;
  final String billName;
  final List<MemberDetails> members;

  BillsDialog({this.dbService, this.billName, this.members});

  @override
  _BillsDialogState createState() => _BillsDialogState(
      dbService: dbService, billName: billName, members: members);
}

class _BillsDialogState extends State<BillsDialog> {
  final _formKey = GlobalKey<FormState>();
  DataBaseService dbService;
  String billName;
  BillDetails billDetails;
  final List<MemberDetails> members;
  int gst = 0;
  int serviceCharge = 0;

  _BillsDialogState({this.dbService, this.billName, this.members});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Container(
          height: 280,
          child: Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "New Bill",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Bill Name cannot be Empty';
                          }
                          return null;
                        },
                        onChanged: (name) {
                          setState(() {
                            billName = name;
                          });
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                )),
                            labelText: 'Bill Name'),
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                        child: Container(
                          width: 116,
                          height: 50,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: gst.toString(),
                            onChanged: (value) {
                              setState(() {
                                gst = int.parse(value);
                              });
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    )),
                                labelText: 'GST'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                        child: Container(
                          width: 116,
                          height: 50,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: serviceCharge.toString(),
                            onChanged: (value) {
                              setState(() {
                                serviceCharge = int.parse(value);
                              });
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    )),
                                labelText: 'SVC'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, left: 25.0, right: 30.0),
                          child: FlatButton(
                            child: Text(
                              "Ok",
                              style: TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.bold),
                            ),
                            color: Colors.teal[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                billDetails = await dbService.createBill(
                                    billName, members, gst, serviceCharge);
                                dbService = new DataBaseService(
                                    uid: dbService.uid,
                                    groupUID: dbService.groupUID,
                                    billUID: billDetails.billUID,
                                    owedBillUID: billDetails.owedBillUID);
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ItemPage(
                                            dbService: dbService,
                                            billDetails: billDetails)));
                              }
                            },
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                            top: 20.0,
                            left: 15.0,
                          ),
                          child: FlatButton(
                            child: Text(
                              "Close",
                              style: TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.bold),
                            ),
                            color: Colors.teal[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )),
                    ],
                  ),
                ],
              )),
        ));
  }
}
