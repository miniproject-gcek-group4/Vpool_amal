class NewUser{
  String uid,username;
  NewUser({required this.uid,required this.username });
}

class Travellers{
  String email, username, isOwner;
  Travellers({required this.email,required this.username,required this.isOwner});
}

class Journey{
  String startingloc, endingloc, date, startingtime, endingtime, numseats,email,remseats,journeyid, price;
  Journey({required this.startingloc,required this.endingloc,required this.date,required this.price,
           required this.startingtime,required this.endingtime,required this.numseats,
           required this.email,required this.remseats,required this.journeyid});
}

class Corider{/// users or travellers details
  String email,nofseats,startloc,endloc,date,slat,slong,elat,elong,journeyid,isjoined,isleaved,otp;
  Corider({required this.email,required this.nofseats,required this.date,
          required this.startloc,required this.endloc,required this.slat,
          required this.slong,required this.elat,required this.elong,required this.otp,
          required this.journeyid,required this.isjoined,required this.isleaved});
}

class Rider{/// driver or owner details
  String email,nofseats,date,journeyid,startloc,endloc,isstart,
      isnotified,driverid,distance,startingtime,endingtime,otp;
  Rider({required this.email,required this.nofseats,required this.date,required this.journeyid,
          required this.startloc,required this.endloc,required this.isstart,
          required this.startingtime,required this.endingtime,required this.otp,
          required this.isnotified,required this.driverid,required this.distance});
}

class Travel{
  String email,nofseats,startloc,endloc,date,slat,slong,elat,elong,journeyid,startingtime,endingtime;
  Travel({required this.email,required this.nofseats,required this.date,
  required this.startloc,required this.endloc,required this.slat,
    required this.startingtime,required this.endingtime,
  required this.slong,required this.elat,required this.elong,required this.journeyid});

}