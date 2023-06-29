import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/screens/home/owner/ownerhome.dart';
import 'package:untitled1/screens/home/traveller/userhome.dart';
import 'package:untitled1/services/databaseService.dart';
import '../../models/user.dart';
import 'dual/dualhome.dart';

/// home page, this page deviates travllers to travler page,  owner to driver page and dual to dual user page
class Home extends StatefulWidget {
  const Home({required this.user});
  final NewUser user;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {

    return StreamProvider.value(
      value: UserDatabaseService().users,
    initialData: null,
    child: UserSwitch(user: widget.user,)
    );
  }}

class UserSwitch extends StatefulWidget {
  const UserSwitch({required this.user});
  final NewUser user;

  @override
  State<UserSwitch> createState() => _UserSwitchState();
}

class _UserSwitchState extends State<UserSwitch> {
  @override
  Widget build(BuildContext context) {
    String? userdesignation="";
    final userlist = Provider.of<List<Travellers>?>(context)??[];
    print("username="+widget.user.username);
    print("length= "+ userlist.length.toString());
    for(int i=0;i<userlist.length;i++){print(userlist[i].email);
      if(userlist[i]?.email==widget.user.username){
        userdesignation=userlist[i]?.isOwner;
        print(userlist[i].username);
      }
    }
    print(userdesignation);
    ///divider
    if (userdesignation == '0') {
      return UserHome(user: widget.user);
    } else if (userdesignation == '1'){
      return OwnerHome(user: widget.user);
    }else if (userdesignation == '2'){
      return DualHome(user: widget.user);
    }
    return Container(height: 1,child: CircularProgressIndicator(),);
  }
}
