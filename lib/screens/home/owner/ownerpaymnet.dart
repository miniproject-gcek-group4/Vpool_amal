import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../models/user.dart';
import '../../../services/databaseService.dart';

///this page deals with all payment services
class OwnerPayment extends StatefulWidget {
  const OwnerPayment({required this.user});
  final NewUser user;

  @override
  State<OwnerPayment> createState() => _OwnerPaymentState();
}

class _OwnerPaymentState extends State<OwnerPayment> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: JourneyDatabaseService().journeylist,
      initialData: null,
      child: Payment(),
    );
  }
}

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    final travelpaymentlist = Provider.of<List<Journey>?>(context) ?? [];
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Center(
            child: Text(
              "No Transactions done yet",
              style: GoogleFonts.poppins(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
