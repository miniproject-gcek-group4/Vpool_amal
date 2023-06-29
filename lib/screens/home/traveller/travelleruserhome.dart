import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/models/user.dart';
import 'package:untitled1/screens/home/traveller/usersearchresult.dart';
import 'package:untitled1/services/databaseService.dart';
import 'package:untitled1/models/components.dart';

///travaller home page, this page show details of all the journey they can select
class MyUserHome extends StatefulWidget {
  const MyUserHome({required this.user});
  final NewUser user;

  @override
  State<MyUserHome> createState() => _MyUserHomeState();
}

class _MyUserHomeState extends State<MyUserHome> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
        value: JourneyDatabaseService().journeylist,
        initialData: null,
        child: AllJourneys(user: widget.user));
  }
}

///collecting details of all the journey form db
class AllJourneys extends StatefulWidget {
  const AllJourneys({required this.user});
  final NewUser user;

  @override
  State<AllJourneys> createState() => _AllJourneysState();
}

class _AllJourneysState extends State<AllJourneys> {
  @override
  Widget build(BuildContext context) {
    final journeylist = Provider.of<List<Journey>?>(context) ?? [];
    print("journey length" + journeylist.length.toString());
    return ListView.separated(
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectJourney(
                            user: widget.user,
                            selected: journeylist[index],
                          )));
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Expanded(
                              //   child: Text(
                              //     'Journey',
                              //     style: TextStyle(
                              //       fontWeight: FontWeight.bold,
                              //     ),
                              //   ),
                              // ),
                              Expanded(
                                child: Text(
                                  journeylist[index].startingloc,
                                  style: GoogleFonts.poppins(),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '------->',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  journeylist[index].endingloc,
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Journey Date',
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  journeylist[index].date,
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text('Remaining Seats',
                                    style: GoogleFonts.poppins()),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  journeylist[index].remseats,
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Container(
            height: 5,
          );
        },
        itemCount: journeylist.length);
  }
}
