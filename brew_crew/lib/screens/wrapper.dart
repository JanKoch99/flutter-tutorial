import 'package:brew_crew/screens/authenticate/authenticate.dart';
import 'package:brew_crew/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    final User? user = Provider.of<User?>(context);

    // return either Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    }

    return Home();
  }
}
