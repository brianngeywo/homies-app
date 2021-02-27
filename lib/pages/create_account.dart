import 'dart:async';
import 'package:flutter/material.dart';
import 'package:homie_app/widgets/header.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String displayName;
  submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      SnackBar snackBar = SnackBar(content: Text("welcome $displayName"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context, displayName);
      });
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context,
          titleText: "Create an Account", removeBackButton: true),
      body: ListView(
        children: [
          Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: Center(
                    child: Text(
                      "create a display Name",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                      key: _formKey,
                      child: TextFormField(
                        autovalidate: true,
                        validator: (val) {
                          if (val.trim().length < 3 || val.isEmpty) {
                            return "display name too short";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => displayName = val,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "agency/company name",
                          labelText: "must be atleast 3 characters",
                          labelStyle: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      )),
                ),
                GestureDetector(
                  onTap: submit,
                  child: Container(
                    height: 50,
                    width: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.blue,
                    ),
                    child: Text("Submit",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
