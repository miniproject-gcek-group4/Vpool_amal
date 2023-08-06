import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/screens/authentication/forgotpassword.dart';
import 'package:untitled1/screens/wrapper.dart';
import 'package:untitled1/services/auth.dart';
import 'package:untitled1/models/user.dart';
import 'models/components.dart';

///colors to top app bar and bottom naviagtion bar
Color topcolor = Colors.red, bottomColor = Colors.green;

///main function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<NewUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
        routes: {
          'forgot_password': (context) => ForgotPassWord(),
          'qr_scan': (context) => QRViewExample(),
        },
      ),
    );
  }
}
