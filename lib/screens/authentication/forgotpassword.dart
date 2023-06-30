import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth.dart';

///page for implementing forget password
class ForgotPassWord extends StatefulWidget {
  ForgotPassWord({Key? key}) : super(key: key);

  @override
  State<ForgotPassWord> createState() => _ForgotPassWordState();
  final FirebaseAuth auth = FirebaseAuth.instance;
}

class _ForgotPassWordState extends State<ForgotPassWord> {
  @override
  var email_cont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var ht = MediaQuery.of(context).size.height;
    var wd = MediaQuery.of(context).size.width;

    final AuthService _authService = AuthService();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // shape: const RoundedRectangleBorder(),
        elevation: 0,
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
        centerTitle: true,
        title: Text(
          "Reset Password",
          style: GoogleFonts.poppins(fontSize: 24),
        ),
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // const SizedBox(
                //   height: 20,
                // ),
                SizedBox(height: ht * 0.05),
                // Icon(
                //   Icons.mail_rounded,
                //   size: 120,
                // ),

                Text(
                  ' Enter your registered email id',
                  style: GoogleFonts.libreFranklin(fontSize: 20),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 60,
                  width: wd * 0.75,
                  child: TextFormField(
                    controller: email_cont,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(),
                      hintText: 'Enter email',
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),

                Container(
                  height: 55,
                  width: wd * 0.45,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[400],
                          foregroundColor: Colors.white,
                          shadowColor: Colors.grey,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          minimumSize: Size(150, 50),
                          maximumSize: Size(150, 50) //////// HERE
                          ),
                      onPressed: () async {
                        await _authService.resetPassword(
                            email_cont.text.trim(), context);
                      },
                      child: Text(
                        "Submit",
                        style: GoogleFonts.poppins(fontSize: 22),
                      )),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 30, 5, 5),
                  child: Expanded(
                    child: Image.asset(
                      'assets/images/car.jpeg',
                      fit: BoxFit.cover,
                      height: 275.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
