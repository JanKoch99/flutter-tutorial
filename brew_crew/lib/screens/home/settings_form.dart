import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  String _currentName = "";
  String _currentSugars = "";
  int _currentStrength = 0;



  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {

          UserData? userData = snapshot.data;

          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'Update your brew settings.',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: textInputDecoration,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _currentName = value;
                    });
                  },
                  initialValue: _currentName.isNotEmpty ? _currentName : userData?.name,
                ),
                SizedBox(
                  height: 20.0,
                ),
                DropdownButtonFormField(
                    decoration: textInputDecoration,
                    value:  _currentSugars.isNotEmpty ? _currentSugars : userData?.sugars,
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                          value: sugar,
                          child: Text('$sugar sugars')
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _currentSugars = val.toString();
                      });
                    }
                ),
                SizedBox(
                  height: 20.0,
                ),
                Slider(
                    min: 100,
                    max: 900,
                    divisions: 8,
                    value: _currentStrength != 0 ? _currentStrength.toDouble() : userData!.strength.toDouble(),
                    activeColor: Colors.brown[_currentStrength != 0 ? _currentStrength : userData!.strength],
                    inactiveColor: Colors.brown[_currentStrength != 0 ? _currentStrength : userData!.strength],
                    onChanged: (value) {
                      setState(() {
                        _currentStrength = value.round();
                      });
                    }
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
                  child: Text(
                    "Update",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await DatabaseService(uid: user.uid).updateUserData(
                        _currentSugars.isNotEmpty ? _currentSugars : userData!.sugars,
                        _currentName.isNotEmpty ? _currentName : userData!.name,
                        _currentStrength != 0 ? _currentStrength : userData!.strength
                      );
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          );
        }
        return Loading();
      },
    );
  }
}
