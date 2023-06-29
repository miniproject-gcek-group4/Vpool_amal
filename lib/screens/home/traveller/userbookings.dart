import 'package:flutter/material.dart';
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
        value: AllJourneyTravellerDatabaseService(useremail: widget.user.username).corider,
        initialData: null,
        child: DriverDetails(user:  widget.user,));
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
    final driverlist = Provider.of<List<Rider>?>(context)??[];
    print("driverlist is "+ driverlist.length.toString());
    return ListView.separated(
      itemCount: driverlist.length,
      itemBuilder: (context,index){
        return Card(elevation: 10,
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                Expanded(flex:1,child:Text('journey'),),
                Expanded(flex: 2,child: Text(driverlist[index].startloc)),
                Expanded(flex:1,child:Text('------->'),),
                Expanded(flex:2,child: Text(driverlist[index].endloc))
              ],),
              Row(
                children: [
                  Expanded(flex:1,child:Text('journey date'),),
                  Expanded(flex: 1,child: Text(driverlist[index].date)),
                ],
              ),
              Row(
                children: [
                  Expanded(flex:1,child:Text('number of seats booked'),),
                  Expanded(flex: 1,child: Text(driverlist[index].nofseats)),
                ],
              ),
              Row(
                children: [
                  Expanded(flex:1,child:Text('journey time'),),
                  Expanded(flex: 1,child: Text(driverlist[index].startingtime)),
                  Expanded(flex: 1,child: Text(driverlist[index].endingtime)),
                ],
              ),
              Row(
                children: [
                  Expanded(flex:1,child:Text('driver mail'),),
                  Expanded(flex: 1,child: Text(driverlist[index].driverid)),
                ],
              ),
            ],
          )
        );
      },
      separatorBuilder: (context,index){
        return Container(padding: EdgeInsets.all(5 ),);
      },
    );
  }
}
