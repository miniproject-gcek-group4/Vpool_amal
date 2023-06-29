import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/main.dart';
import 'package:untitled1/models/components.dart';
import 'package:untitled1/screens/home/traveller/travelleruserhome.dart';
import 'package:untitled1/screens/home/traveller/userbookings.dart';
import 'package:untitled1/screens/home/traveller/usernotification.dart';
import 'package:untitled1/screens/home/traveller/usersearchresult.dart';
import '../../../models/user.dart';
import '../../../services/auth.dart';
import 'package:qr_flutter/qr_flutter.dart';

///initail page of a travller maps to different services of travller
class UserHome extends StatefulWidget {
  const UserHome({required this.user});
  final NewUser user;

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int pageIndex = 0;
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      MyUserHome(user: widget.user),
      MySearch(user: widget.user),
      UserNotification(user: widget.user),
      UserBookings(user: widget.user),
    ];

    return Scaffold(
      ///app bar of travler page
      appBar: AppBar(
        flexibleSpace: Appbarstylining(),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        title: Center(
            child: Text(
          'Vpool',
          style: GoogleFonts.poppins(fontSize: 24),
        )),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("My Account"),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text("My Qr"),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text("Logout"),
              ),
            ];
          }, onSelected: (value) async {
            if (value == 0) {
              print("My account menu is selected.");
            } else if (value == 1) {
              ///display qr code
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return QrTraveller(
                  user: widget.user,
                );
              }));
            } else if (value == 2) {
              await _auth.signOut();
            }
          }),
        ],
      ),

      ///body of travler page
      body: Stack(
        children: [
          Container(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height / 50,
                  right: MediaQuery.of(context).size.height / 50),
              height: MediaQuery.of(context).size.height,
              child: pages[pageIndex]),
          Positioned(
              top: MediaQuery.of(context).size.height / 1.25,
              right: 5,
              left: 5,
              child: buildMyNavBar(context)),
        ],
      ),
    );
  }

  /// bottom navigation bar of travelr
  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: bottomColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              icon: pageIndex == 0
                  ? const Icon(
                      Icons.home_filled,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.home_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            const Text("Home")
          ]),
          Column(children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                });
              },
              icon: pageIndex == 1
                  ? const Icon(
                      Icons.saved_search_sharp,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            const Text('Search')
          ]),
          Column(children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 2;
                });
              },
              icon: pageIndex == 2
                  ? const Icon(
                      Icons.notifications_active,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.notifications_active_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            const Text('Notification')
          ]),
          Column(children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 3;
                });
              },
              icon: pageIndex == 3
                  ? const Icon(
                      Icons.person_2,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.person_2_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            const Text('My Bookings')
          ]),
        ],
      ),
    );
  }
}

///Qr code display of user
class QrTraveller extends StatefulWidget {
  const QrTraveller({required this.user});
  final NewUser user;

  @override
  State<QrTraveller> createState() => _QrTravellerState();
}

class _QrTravellerState extends State<QrTraveller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My QR",
          style: GoogleFonts.poppins(fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Appbarstylining(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 80,
              ),
              Container(
                child: QrImageView(
                  data: widget.user.username,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
              SizedBox(
                height: 30,
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
                  onPressed: () {
                    Navigator.of(context).pushNamed('qr_scan');
                  },
                  child: Text(
                    "Scan QR",
                    style: GoogleFonts.poppins(fontSize: 16),
                  ))
            ],
          ),
        )),
      ),
    );
  }
}
