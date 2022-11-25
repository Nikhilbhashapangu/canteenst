
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';

class PayLater extends StatefulWidget {
  PayLater({Key? key}) : super(key: key);

  @override
  State<PayLater> createState() => _PayLaterState();
}

class _PayLaterState extends State<PayLater> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        body: Container(
            width: 100.w,
            height: 100.h,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 25.w),
                Stack(
                  children: [
                    SpinKitPulse(
                      color: Color.fromARGB(255, 100, 29, 215),
                      size: 60.w,
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Image.asset("assets/images/cooking.png"),
                    )
                  ],
                ),
                Expanded(
                    child: Text(
                        "Your order has been recorded. Please receive your order at the canteen",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 14.sp, color: Colors.black))),
                Padding(
                  padding: EdgeInsets.fromLTRB(40.w, 0, 40.w, 30.w),
                  child: ButtonTheme(
                    minWidth: 20.w,
                    height: 10.w,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.w)),
                    child: RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: Color.fromARGB(255, 108, 29, 205),
                        child: Text("Done",
                            style: TextStyle(
                                color: Colors.white, fontSize: 11.sp))),
                  ),
                )
              ],
            )),
      );
    });
  }
}
