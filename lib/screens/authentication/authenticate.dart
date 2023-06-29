import 'package:flutter/material.dart';
import 'package:untitled1/screens/authentication/login.dart';
import 'package:untitled1/screens/authentication/register.dart';


class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignin = true;
  void toggleView(){
    setState(() {
      showSignin = !showSignin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showSignin)
      return Login(toggleView : toggleView);
    else return Register(toggleView : toggleView);
  }
}
