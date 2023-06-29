import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Login extends StatefulWidget {
  const Login({required this.toggleView});
  final Function toggleView;
  static final String id = "login";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  TextEditingController username1 = new TextEditingController();
  TextEditingController passsord1 = new TextEditingController();
  String error = "";
  @override
  Widget build(BuildContext context) {
    var ht = MediaQuery.of(context).size.height;
    var wd = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          // toolbarHeight: 65,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black54, // shadow color
                      blurRadius: 20, // shadow radius
                      offset: Offset(5, 5), // shadow offset
                      spreadRadius:
                          0.1, // The amount the box should be inflated prior to applying the blur
                      blurStyle: BlurStyle.normal // set blur style
                      ),
                ],
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30)),
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[Colors.cyan, Colors.green])),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.backspace,
            ),
            onPressed: () {
              exit(0);
            },
          ),
          centerTitle: true,
          shape: const RoundedRectangleBorder(),
          // toolbarHeight: 70,
          backgroundColor: Colors.transparent,
          title: Text(
            'Sign in',
            style: GoogleFonts.poppins(fontSize: 24),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child:

              //////////
              Container(
            padding: EdgeInsets.only(
                // left: MediaQuery.of(context).size.height / 70,
                // right: MediaQuery.of(context).size.height / 70,
                // top: MediaQuery.of(context).size.height / 100,
                ),
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    Row(children: [
                      //const Expanded(flex:1,child: Text("Username",style: TextStyle(fontSize: 18.0,color: Colors.red),)),
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.fromLTRB(wd * 0.05, 5, wd * 0.05, 5),
                          child: Container(
                            // height: 50,
                            // width: wd * 0.5,
                            child: TextField(
                                controller: username1,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                    hintText: 'Enter your email',
                                    border: OutlineInputBorder())),
                          ),
                        ),
                      ),
                    ]),
                    SizedBox(
                      height: 20,
                    ),
                    Row(children: [
                      // Expanded(flex:1,child: Text("Password",style: TextStyle(fontSize: 18.0,color: Colors.red),)),
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.fromLTRB(wd * 0.05, 5, wd * 0.05, 5),
                          child: Container(
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: passsord1,
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: 'Enter your password ',
                                  border: OutlineInputBorder()),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 50,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[400],
                          foregroundColor: Colors.white,
                          shadowColor: Colors.grey,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          minimumSize: Size(200, 50), //////// HERE
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            dynamic result =
                                await _auth.signInWithEmailandPassword(
                                    username1.text.trim(), passsord1.text);
                            if (result == null) {
                              setState(() {
                                showTopSnackBar(
                                  Overlay.of(context),
                                  const CustomSnackBar.error(
                                    message: 'Sign in failed',
                                  ),
                                );

                                error = "sign in failed";
                              });
                            }
                          }
                        },
                        child: Text(
                          'Login',
                          style: GoogleFonts.poppins(fontSize: 20),
                        )),
                    SizedBox(
                      height: 32,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have account? | ",
                          style: GoogleFonts.libreFranklin(fontSize: 16),
                        ),
                        TextButton(
                            onPressed: () {
                              widget.toggleView();
                            },
                            child: Text(
                              "Signup",
                              style: GoogleFonts.poppins(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('forgot_password');
                        },
                        child: Text(
                          "Forgot password?",
                          style: GoogleFonts.poppins(fontSize: 17),
                        )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                      child: Image.asset(
                        'assets/images/carpool.jpg',
                        fit: BoxFit.cover,
                        height: 300.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
