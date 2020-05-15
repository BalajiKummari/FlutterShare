import 'package:flutter/material.dart';
import 'package:fluttershare/widgets/header.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formkey =  GlobalKey<FormState>();
  String username;

  submit(){
    print("invoked");
    _formkey.currentState.save();
    Navigator.pop(context,username);
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      appBar:
          header(context, isAppTitle: false, titleText: 'Setup your Profile'),
      body: Container(
        child: Column(
          children: <Widget>[
            Text("Create a Username", style: TextStyle(fontSize: 20)),
            Form(
              key: _formkey,
              child: TextFormField(
                onSaved: (val) => username = val,
              ),
            ),
            GestureDetector(
              onTap: submit,
              child: 
              Container(
                child: Text("submit"),
                decoration: BoxDecoration(
                  color : Colors.greenAccent,
                  borderRadius : BorderRadius.circular(7.0)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
