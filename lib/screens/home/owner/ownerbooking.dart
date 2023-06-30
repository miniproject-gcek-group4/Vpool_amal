import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:untitled1/services/auth.dart';
import '../../../main.dart';
import '../../../models/user.dart';
import '../../../services/databaseService.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';
import 'dart:convert';

///page for showing all the booking details of a journey added by a driver
class OwnerBooking extends StatefulWidget {
  const OwnerBooking({required this.user});
  final NewUser user;

  @override
  State<OwnerBooking> createState() => _OwnerBookingState();
}

class _OwnerBookingState extends State<OwnerBooking> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
        value: AllJourneyDriverDatabaseService(useremail: widget.user.username).corider,
        initialData: null,
        child: TravellerDetails(user:  widget.user,));
  }
}

///collecting the details of driver and all his journeys
class TravellerDetails extends StatefulWidget {
  const TravellerDetails({required this.user});
  final NewUser user;

  @override
  State<TravellerDetails> createState() => _TravellerDetailsState();
}

class _TravellerDetailsState extends State<TravellerDetails> {
  @override
  Widget build(BuildContext context) {
    final driverlist = Provider.of<List<Travel>?>(context) ?? [];
    print("driverlist is " + driverlist.length.toString());
    return  ListView.separated(
      itemCount: driverlist.length,
      itemBuilder: (context,index){
        return GestureDetector(
          child : Card(elevation: 5,shadowColor: Colors.black87,
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
                    Expanded(flex:1,child:Text('journey time'),),
                    Expanded(flex: 1,child: Text(driverlist[index].startingtime)),
                    Expanded(flex: 1,child: Text(driverlist[index].endingtime)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(flex:1,child:Text('seats booked'),),
                    Expanded(flex: 1,child: Text(driverlist[index].nofseats)),
                  ],
                ),
                ],),
            ),
          onTap: () async{
           await Navigator.push(context, MaterialPageRoute(builder: (context){
              return Scaffold(body: AdminDetails(
                  user: widget.user,
                  corider: driverlist[index],));
            }));
        },
          onLongPress: () async{
            showDialog(context: context, builder: (builder){
              return AlertDialog(
                title: TextButton(child: Text('Delete'),
                onPressed: () async{
                  await AllJourneyDriverDatabaseService(useremail: widget.user.username)
                      .deleteDriverJourneyData(driverlist[index].journeyid);
                },),
              );
            });
          },
        );
      },
      separatorBuilder: (context,index){
        return Container(padding: EdgeInsets.all(5),);
      },
    );
  }
}

///taking the detail of travllers of a paricular jouney from db
class AdminDetails extends StatefulWidget {
  const AdminDetails({required this.corider,required this.user});
  final NewUser user;
  final Travel corider;

  @override
  State<AdminDetails> createState() => _AdminDetailsState();
}

class _AdminDetailsState extends State<AdminDetails> {
  @override
  Widget build(BuildContext context) {
    print(widget.corider.journeyid);
    return StreamProvider.value(
        value: AdminJourneyDatabaseService(useremail: widget.user.username,journeyid: widget.corider.journeyid)
        .corider,
    initialData: null,
    child: JourneyTrackerOwner(corider: widget.corider,user: widget.user,),);
  }
}



class JourneyTrackerOwner extends StatefulWidget {
  const JourneyTrackerOwner({required this.corider,required this.user});
  final NewUser user;
  final Travel corider;///rider===>owner journey, corider===> travller journey

  @override
  State<JourneyTrackerOwner> createState() => _JourneyTrackerOwnerState();
}

class _JourneyTrackerOwnerState extends State<JourneyTrackerOwner> {

  TextEditingController enteredotp = new TextEditingController();
  Location location = new Location();

  ///enabling background services of location
  Future<bool> enableBackgroundMode() async {
    bool _bgModeEnabled = await location.isBackgroundModeEnabled();
    if (_bgModeEnabled) {
      return true;
    } else {
      try {
        await location.enableBackgroundMode();
      } catch (e) {
        debugPrint(e.toString());
      }
      try {
        _bgModeEnabled = await location.enableBackgroundMode();
      } catch (e) {
        debugPrint(e.toString());
      }
      print(_bgModeEnabled); //True!
      return _bgModeEnabled;
    }
  }

  ///calculating distance of each loction to real location of a driver
  void trackloc(List<double> lat, List<double> lng) {
    print("location insde loctrack----------------------------");
    double lat1, lon1; //location.enableBackgroundMode(enable: true);
    enableBackgroundMode();
    print(location.isBackgroundModeEnabled());
    location.onLocationChanged.listen((LocationData currentLocation) async {
      print("location inside for loop----------------------------");
      double? lat2 = currentLocation.latitude,
          lon2 = currentLocation.longitude; //1 - searching         2 - current
      for (int i = 0; i < lat.length; i++) {
        lat1 = lat[i];
        lon1 = lng[i];
        double p = 0.017453292519943295;
        double a = 0.5 - cos((lat2! - lat1) * p) / 2 +
            cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2! - lon1) * p)) / 2;
        double x = 12742 * asin(sqrt(a));
        if (x < 0.500) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('corider is 500m near to you')));
        }
        print("ditance " + x.toString() + " of " + i.toString());
        await AdminJourneyDatabaseService(
            useremail: email[i], journeyid: journy[i])
            .updateDriverJourneyDistanceData(x.toString());
      }
    });
  }

  final AuthService _auth = AuthService();
  String isjoined = '';
  bool vis = true;
  double x1 = 0.0,
      y1 = 0.0,
      x = 0;
  String a = "",
      b = "";
  List<double> lat = [],
      lng = [];
  List<String> email = [],
      journy = [];

  @override
  Widget build(BuildContext context) {
    final travellerlist = Provider.of<List<Corider>?>(context) ?? [];
    print(travellerlist.length);
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        toolbarHeight: MediaQuery
            .of(context)
            .size
            .height / 15,
        title: const Center(child:
        Text('V-Pool', style: TextStyle(
            fontSize: 25, fontWeight: FontWeight.w900),)),
        backgroundColor: topcolor,
        centerTitle: true,
        leading: BackButton(),
        actions: [
          PopupMenuButton(
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("My Account"),
                  ),

                  const PopupMenuItem<int>(
                    value: 2,
                    child: Text("Logout"),
                  ),
                ];
              },
              onSelected: (value) async {
                if (value == 0) {
                  print("My account menu is selected.");
                } else if (value == 2) {
                  await _auth.signOut();
                }
              }
          ),
        ],
      ),
      body: Column(
        children: [
          Container(height: MediaQuery
              .of(context)
              .size
              .height / 1.5,
            child: ListView.separated(itemBuilder: (context, index) {
              return Card(elevation: 5, shadowColor: Colors.black87,
                child: Column(
                  children: [
                    Text(travellerlist[index].email),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(flex: 1, child: Text('journey'),),
                        Expanded(flex: 2, child: Text(
                            travellerlist[index].startloc)),
                        Expanded(flex: 1, child: Text('------->'),),
                        Expanded(flex: 2, child: Text(
                            travellerlist[index].endloc))
                      ],),
                    Row(
                      children: [
                        Expanded(flex: 1, child: Text('journey date'),),
                        Expanded(flex: 1, child: Text(
                            travellerlist[index].date)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(flex: 1, child: Text('Seats booked'),),
                        Expanded(flex: 1, child: Text(
                            travellerlist[index].nofseats)),
                      ],
                    ),
                    Text("isjoined " + travellerlist[index].isjoined),
                    Text("isleaved " + travellerlist[index].isleaved),
                  ],
                ),
              );
            }, separatorBuilder: (context, index) {
              return Container(height: 5,);
            }, itemCount: travellerlist.length),
          ),

          ///initaily hiding the following fields
          Visibility(visible: vis,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              ElevatedButton(onPressed: () async {
                for (int k = 0; k < travellerlist.length; k++) {
                  a = travellerlist[k].slat;
                  b = travellerlist[k].slong;
                  x1 = double.parse(a);
                  y1 = double.parse(b);
                  lat.add(x1);
                  lng.add(y1);
                  lat = [...{...lat}];
                  lng = [...{...lng}];
                  email.add(travellerlist[k].email);
                  email = [...{...email}];
                  journy.add(travellerlist[k].journeyid);
                  journy = [...{...journy}];
                }
                trackloc(lat, lng);
                for (int j = 0; j < travellerlist.length; j++) {
                  await AllJourneyTravellerDatabaseService(
                      useremail: travellerlist[j].email)
                      .updateDriverJSStartData(travellerlist[j].journeyid);
                }
                enableBackgroundMode();
              }, child: Text('start')),
              ElevatedButton(onPressed: () async {
                String barcodeScanRes;
                barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                    "#ff6666", "Cancel", true, ScanMode.QR);
                print(barcodeScanRes);
                int otp= generateotp(widget.corider.email, widget.corider.journeyid);
                AdminJourneyDatabaseService(useremail: widget.user.username,
                    journeyid: widget.corider.journeyid)
                    .updateDriverJourneyDataInUser("true", barcodeScanRes, otp.toString());
                AdminJourneyDatabaseService(useremail: widget.user.username,
                    journeyid: widget.corider.journeyid).updateDriverJourneyDistanceDataOtp(otp.toString());
                setState(() {});
              }, child: Text('pick corider')),
              ElevatedButton(onPressed: () {
                showDialog(context: context, builder: (Context) {
                  return AlertDialog(
                    title: Text("enter otp"),
                    content: TextField(controller: enteredotp,
                    ),
                    actions: [
                      TextButton(onPressed: () async {
                        int target=-1;
                        for(int i=0;i<travellerlist.length;i++){
                        if (enteredotp.text == travellerlist[i].otp) {
                             target=i;
                        }}
                        await AdminJourneyDatabaseService(useremail: widget.user.username,
                            journeyid: widget.corider.journeyid).updateDriverJourneyDataInUsers(travellerlist[target].email);
                      }, child: Text('submit'))
                    ],
                  );
                });
                if (enteredotp.text ==
                    widget.corider.journeyid.substring(9, 15)) {
                  print("success");
                }
              }, child: Text('leaave corider')),
              ElevatedButton(onPressed: ()async {
                for(int i=0;i<travellerlist.length;i++){
                if(travellerlist[i].isleaved==travellerlist[i].isjoined &&
                travellerlist[i].isleaved=='true') {
                   await AllJourneyTravellerDatabaseService(
                      useremail: travellerlist[i].email)
                      .updateDriverJEStartData(travellerlist[i].journeyid);
                }
                }
                setState(() {
                  vis = false;
                });
               await showDialog(context: context, builder: (builder){
                  return AlertDialog(
                    title: Text("Feedback Form"),
                    content: TextFormField(),
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Feedback is saved")));
                      }, child: Text('submit'))
                    ],
                  );
                });
              }, child: Text('end'),),
            ],
            ),
          ),
          ElevatedButton(onPressed: ()async{
            print(widget.corider.email);
            String barcodeScanRes;
            barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                "#ff6666", "Cancel", true, ScanMode.QR);
            print(barcodeScanRes);print(widget.corider.email);
            await AllJourneyDriverDatabaseService(useremail: barcodeScanRes)
              .updatetravellerLiftJourneyData(widget.corider.journeyid, widget.user.username);
          }, child: Text('LiftService'))
        ],
      ),
    );
  }

///functions for creating one time passcode
  int encryptStringToInt(String input, String key) {
    final plainText = input.padRight(16,'\x00');
    final encrypter = Encrypter(AES(encrypt.Key.fromUtf8(key)));
    final iv=IV.fromSecureRandom(16);
    final encrypted = encrypter.encrypt(plainText,iv: iv);
    final encryptedString = base64Url.encode(encrypted.bytes);
    final hash = md5.convert(utf8.encode(encryptedString));
    final hashString = hexEncode(hash.bytes);
    final encryptedInt = int.parse(hashString.substring(0, 6), radix: 16) %
        1000000;
    return encryptedInt;
  }
  String hexEncode(List<int> bytes) {
    final hexDigits = '0123456789ABCDEF';
    final buffer = StringBuffer();
    for (var byte in bytes) {
      buffer.write(hexDigits[(byte & 0xF0) >> 4]);
      buffer.write(hexDigits[byte & 0x0F]);
    }
    return buffer.toString();
  }

  int generateotp(email, jid) {
    String originalString = "email+jid";
    String encryptionKey = "encryptionKey123";
    int encryptedInt = encryptStringToInt(originalString, encryptionKey);
    print(encryptedInt);
    return encryptedInt;// Output: 658267
  }
}

