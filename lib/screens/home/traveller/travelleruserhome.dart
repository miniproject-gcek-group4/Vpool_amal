import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/models/user.dart';
import 'package:untitled1/screens/home/traveller/usersearchresult.dart';
import 'package:untitled1/services/databaseService.dart';

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
    final journeylist = Provider.of<List<Journey>?>(context)??[];
    print("journey length"+journeylist.length.toString());
    return ListView.separated(itemBuilder: (context,index){
      return GestureDetector(onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context)=>SelectJourney(user: widget.user,selected: journeylist[index],)));
      },
        child: Card(elevation: 10,
          child: Column(
            children:[
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                Expanded(flex:1,child:Text('journey'),),
                Expanded(flex: 2,child: Text(journeylist[index].startingloc)),
                Expanded(flex:1,child:Text('------->'),),
                Expanded(flex:2,child: Text(journeylist[index].endingloc))
              ],),
              Row(
                children: [
                  Expanded(flex:1,child:Text('journey date'),),
                  Expanded(flex: 1,child: Text(journeylist[index].date)),
                ],
              ),
              Row(
                children: [
                  Expanded(flex:1,child:Text('remaining seats'),),
                  Expanded(flex: 1,child: Text(journeylist[index].remseats)),
                ],
              ),
            ],
          ),
        ),
      );
    },
        separatorBuilder: (context,index){
      return Container(height: 5,);
        }
        , itemCount: journeylist.length);
  }
}
