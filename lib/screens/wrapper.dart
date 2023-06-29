import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import 'authentication/authenticate.dart';
import 'home/home.dart';

///wrapper page, this page deviates new user to login or register page, signed user to their home page
class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<NewUser?>(context);
    print(user);
    if(user == null){
      print('user is null');
      return Authenticate();
    }else{
      return Home(user: user);
    }
  }
}

