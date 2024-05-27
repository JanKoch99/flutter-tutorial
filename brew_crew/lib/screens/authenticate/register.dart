import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/services/auth.dart';

import '../../shared/constants.dart';

class Register extends StatefulWidget {

  final Function toggleView;

  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text("Sign up to Brew Crew"),
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person),
              onPressed: () {
                widget.toggleView();
              },
              label: Text('Sign in'),
            )
          ]
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter an email';
                  }
                  return null;
                },
                onChanged: (val) {
                  setState(() => email = val);
                },
                decoration: textInputDecoration.copyWith(
                    hintText: 'Email'
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Enter a password 6+ chars long';
                  }
                  return null;
                },
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
                decoration: textInputDecoration.copyWith(
                    hintText: 'Password'
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.pink[400]),
                      textStyle: MaterialStateProperty.all(
                          TextStyle(
                            color: Colors.white,
                          )
                      )
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                      if (result == null) {
                        setState(() {
                          error = 'please supply a valid email';
                          loading = false;
                        });
                      }
                    }
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  )
              ),
              SizedBox(
                height: 12.0,
              ),
              Text(
                error,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
