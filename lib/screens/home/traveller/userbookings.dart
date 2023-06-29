import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../models/user.dart';
import '../../../services/databaseService.dart';

///user bookind details page, this page show the detials of all the journye the booked
class UserBookings extends StatefulWidget {
  const UserBookings({required this.user});
  final NewUser user;

  @override
  State<UserBookings> createState() => _UserBookingsState();
}

class _UserBookingsState extends State<UserBookings> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
        value:
            AllJourneyTravellerDatabaseService(useremail: widget.user.username)
                .corider,
        initialData: null,
        child: DriverDetails(
          user: widget.user,
        ));
  }
}

///collecting details of driver
class DriverDetails extends StatefulWidget {
  const DriverDetails({required this.user});
  final NewUser user;

  @override
  State<DriverDetails> createState() => _DriverDetailsState();
}

class _DriverDetailsState extends State<DriverDetails> {
  @override
  Widget build(BuildContext context) {
    final driverlist = Provider.of<List<Rider>?>(context) ?? [];
    print("driverlist is " + driverlist.length.toString());
    return ListView.separated(
      itemCount: driverlist.length,
      itemBuilder: (context, index) {
        return Card(
            elevation: 10,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          child: Text(
                        "FROM",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      )),
                      Expanded(
                          child: Text("TO",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold)))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          child: Text(
                        driverlist[index].startloc,
                        style: GoogleFonts.poppins(),
                      )),
                      Expanded(
                          child: Text(driverlist[index].endloc,
                              style: GoogleFonts.poppins()))
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child:
                            Text('Journey Date', style: GoogleFonts.poppins()),
                      ),
                      Expanded(
                          child: Text(driverlist[index].date,
                              style: GoogleFonts.poppins())),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('Number of seats booked',
                            style: GoogleFonts.poppins()),
                      ),
                      Expanded(
                        child: Text(driverlist[index].nofseats,
                            style: GoogleFonts.poppins()),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child:
                            Text('Journey Time', style: GoogleFonts.poppins()),
                      ),
                      Expanded(
                          flex: 1, child: Text(driverlist[index].startingtime)),
                      Expanded(
                          flex: 1, child: Text(driverlist[index].endingtime)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child:
                            Text('Driver Email', style: GoogleFonts.poppins()),
                      ),
                      Expanded(
                          flex: 1,
                          child: Text(driverlist[index].driverid,
                              style: GoogleFonts.poppins())),
                    ],
                  ),
                ),
              ],
            ));
      },
      separatorBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(5),
        );
      },
    );
  }
}
