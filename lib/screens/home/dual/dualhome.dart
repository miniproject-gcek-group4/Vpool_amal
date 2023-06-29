import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/main.dart';
import 'package:untitled1/models/components.dart';
import 'package:untitled1/screens/home/owner/addjourney.dart';
import 'package:untitled1/screens/home/owner/ownerbooking.dart';
import 'package:untitled1/screens/home/owner/ownerhome.dart';
import 'package:untitled1/screens/home/owner/ownerpaymnet.dart';
import 'package:untitled1/screens/home/traveller/travelleruserhome.dart';
import 'package:untitled1/screens/home/traveller/userbookings.dart';
import 'package:untitled1/screens/home/traveller/usernotification.dart';
import 'package:untitled1/screens/home/traveller/usersearchresult.dart';
import '../../../models/user.dart';
import '../../../services/auth.dart';
import '../traveller/userhome.dart';

/// initial page of a dual user, dual uer can act as travller and driver
class DualHome extends StatefulWidget {
  const DualHome({required this.user});
  final NewUser user;

  @override
  State<DualHome> createState() => _DualHomeState();
}

class _DualHomeState extends State<DualHome> {
  int pageIndex = 0;
  Icon icon = Icon(Icons.person);
  final AuthService _auth = AuthService();
  int v = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///pages of dual user as travler
    final userpages = [
      MyUserHome(user: widget.user),
      MySearch(user: widget.user),
      UserNotification(user: widget.user),
      UserBookings(user: widget.user)
    ];

    ///pages of dual user as driver
    final ownerpages = [
      DriverHome(),
      OwnerSearch(user: widget.user),
      OwnerPayment(user: widget.user),
      OwnerBooking(user: widget.user)
    ];
    List list = [userpages, ownerpages];

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Appbarstylining(),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        toolbarHeight: MediaQuery.of(context).size.height / 15,
        title: Center(
            child: Text(
          'Vpool',
          style: GoogleFonts.poppins(fontSize: 24),
        )),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            //Navigator.of(context).pushNamed(Login.id);
          },
        ),
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
      body: Stack(
        children: [
          Container(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height / 50,
                  right: MediaQuery.of(context).size.height / 50),
              height: MediaQuery.of(context).size.height,
              child: list[v][pageIndex]),
          Positioned(
              top: MediaQuery.of(context).size.height / 1.25,
              right: 5,
              left: 5,
              child: buildMyNavBar(context)),

          ///following floating action button is responsible fr naviagting btwn traveler and driver
          Positioned(
              top: MediaQuery.of(context).size.height / 1.30,
              left: MediaQuery.of(context).size.width / 2.35,
              child: FloatingActionButton.extended(
                onPressed: () {
                  print(v);
                  if (v == 0) {
                    v = 1;
                    icon = Icon(
                      Icons.directions_bus_rounded,
                    );
                    print("owner");
                  } else {
                    v = 0;
                    icon = Icon(
                      Icons.person,
                    );
                    print("travller");
                  }
                  setState(() {
                    print(v);
                  });
                },
                label: icon,
                elevation: 5,
              )),
        ],
      ),
    );
  }

  ///bottom navigation bar of dual user
  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[Colors.cyan, Colors.green]),
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
                      Icons.search,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.search_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            v == 0 ? const Text('Search') : const Text('add')
          ]),
          Column(children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                // setState(() {
                //   pageIndex = 2;
                // });
              },
              icon: pageIndex == 4
                  ? const Icon(
                      Icons.filter_none,
                      color: Colors.transparent,
                      size: 35,
                    )
                  : const Icon(
                      Icons.filter_none,
                      color: Colors.transparent,
                      size: 35,
                    ),
            ),
            const Text('')
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
            v == 0 ? const Text('Notification') : const Text('Payment')
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
            const Text('Bookings')
          ]),
        ],
      ),
    );
  }
}
