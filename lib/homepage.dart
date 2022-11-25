import 'package:canteenst/paylater.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

import 'login.dart';

int totalorders = 0;
String cuser = "";
int indicator = 0;
int omniv = 0;
int totalcount = 0;
int finalTotal = 0;
List<int>? count;

List<int>? oc = [];

List<String>? orderNames = [];

bool isLoaded = false;
bool isLoading = false;
bool isadding = false;

final children = <Widget>[]; // list to store itemcards
final orderchildren = <Widget>[];
List<String>? names = []; // list to store names of items from firebase
List<String>? cost = []; // list to store cost of items from firebase
List<String>? images = [];
int itemscount = 0; // count of all items in firebase

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

List<Map<String, dynamic>?>? list = []; // list containing maps of items
Map<String, dynamic>? userMap;
Map<String, int>? ordercount;
List<String>? orderCount = [];

class CanteenHome extends StatefulWidget {
  const CanteenHome({Key? key}) : super(key: key);

  @override
  State<CanteenHome> createState() => _CanteenHomeState();
}

// ===================== Get items count ========================

class _CanteenHomeState extends State<CanteenHome> {
  getUserData() async {
    DocumentSnapshot variab = await FirebaseFirestore.instance
        .collection("Students")
        .doc(_auth.currentUser!.uid)
        .get();
    setState(() {
      cuser = variab["name"];
    });
  }

  getTotalOrders() async {
    DocumentSnapshot variable = await FirebaseFirestore.instance
        .collection("Canteen")
        .doc("TotalOrders")
        .get();
    setState(() {
      totalorders = variable["count"];
    });
  }

  getCount() async {
    QuerySnapshot productCollection = await FirebaseFirestore.instance
        .collection('Canteen')
        .doc("items")
        .collection("itemDetails")
        .get();
    itemscount = productCollection.size;
  }

// ======================= Get items in lists, names and cost============

  getItems() async {
    await _firestore
        .collection('Canteen')
        .doc('items')
        .collection('itemDetails')
        .get()
        .then((value) {
      setState(() {
        for (int i = 0; i < itemscount; i++) {
          userMap = value.docs[i].data();
          names?.add(userMap!["foodName"]);
          cost?.add(userMap!["foodCost"]);
          images?.add(userMap!["foodImage"]);

          list?.add(value.docs[i].data());
        }
      });
    });
  }

// ==================== Card of items ======================

  listofitemscard() {
    children.length = 0;
    var individualCount = 0;

    for (var i = 0; i < itemscount; i++) {
      children.add(Padding(
        padding: EdgeInsets.fromLTRB(1.w, 1.w, 1.w, 0),
        child: Container(
            width: 92.w,
            height: 14.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2.w),
              boxShadow: [
                BoxShadow(
                    color: const Color(0XFFA8B4C5).withOpacity(0.30),
                    spreadRadius: 0,
                    blurRadius: 14,
                    offset: const Offset(0, 6.0)),
              ],
            ),
            child: Row(
              children: [
                SizedBox(width: 2.w),
                CircleAvatar(
                    radius: 6.w,
                    backgroundColor: const Color(0xffececec),
                    child: Padding(
                        padding: EdgeInsets.all(1.7.w),
                        child: SizedBox() //Image.network(
                        //   images![i],
                        //   errorBuilder: (BuildContext context, Object exception,
                        //       stackTrace) {
                        //     return Image.asset("assets/images/errorimage.png",
                        //         fit: BoxFit.cover);
                        //   },
                        // ),
                        )),
                SizedBox(width: 2.w),
                SizedBox(
                  width: 38.w,
                  child: Expanded(
                    child: Text(names![i],
                        style: TextStyle(color: Colors.black, fontSize: 13.sp)),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                  child: Text("${cost?[i]}/-",
                      style:
                          TextStyle(color: Colors.grey[400], fontSize: 13.sp)),
                ),
                SizedBox(
                  width: 27.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              if (count![i] > 0) {
                                totalcount -= 1;
                                count?[i] -= 1;

                                if (orderNames!.contains(names?[i])) {
                                  if (count![i] == 0) {
                                    orderNames?.remove(names?[i]);
                                  } else {
                                    null;
                                  }
                                } else {
                                  null;
                                }
                                oc?[omniv] -= 1;

                                finalTotal =
                                    finalTotal - int.parse("${cost?[i]}");
                              } else {
                                setState(() {
                                  isadding = false;
                                });
                              }
                            });
                          },
                          icon: Icon(Icons.remove_circle,
                              color: Colors.grey[400], size: 7.w)),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              totalcount += 1;

                              isadding = true;

                              count![i] += 1;

                              if (orderNames!.contains("${names?[i]}")) {
                                null;
                              } else {
                                setState(() {
                                  orderNames?.add("${names?[i]}");
                                  indicator += 1;
                                  oc!.add(count![i]);
                                });
                              }
                              omniv = orderNames!.indexWhere(
                                  (element) => element == names![i]);
                              oc?[omniv] = count![i];

                              finalTotal =
                                  finalTotal + int.parse("${cost?[i]}");
                            });
                          },
                          icon: Icon(Icons.add_circle,
                              color: const Color(0xff9F6CE2), size: 7.w)),
                    ],
                  ),
                )
              ],
            )),
      ));
    }
    return SizedBox(
        child: Column(
      children: children,
    ));
  }

  setorderCount() {
    for (int i = 0; i < orderNames!.length; i++) {
      orderCount?.add("${orderNames![i]} - ${oc![i]}");
    }
  }

//================== mini order tracking =================

  getOrderCard() {
    orderchildren.length = 0;

    for (int i = 0; i < orderNames!.length; i++) {
      orderchildren.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            height: 8.w,
            child: Padding(
              padding: EdgeInsets.fromLTRB(2.w, 0, 2.w, 0),
              child: Center(
                  child:
                      Expanded(child: Text(orderNames![i] + " - ${oc![i]}"))),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.w),
              color: Color(0xffE9E9E9),
            )),
      ));
    }
    return Row(children: orderchildren);
  }

  emptyLists() async {
    names?.length = 0;

    cost?.length = 0;
    list?.length = 0;
    images?.length = 0;
    count = List.filled(itemscount, 0);
    finalTotal = 0;
  }

  @override
  void initState() {
    getUserData();
    getTotalOrders();
    setState(() {
      isLoading = true;
      isLoaded = false;
    });

    emptyLists();
    getCount();
    Future.delayed(const Duration(milliseconds: 500), () {});
    getItems();
    Future.delayed(const Duration(milliseconds: 2200), () {
      setState(() {
        count = List.filled(itemscount, 0);
        isLoaded = true;
        isLoading = false; // Here you can write your code for open new view
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
          backgroundColor: const Color(0XFFFFFFFF),
          appBar: AppBar(
              title: Text("CANTEEN",
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400)),
              centerTitle: true,
              elevation: 0,
              actions: [
                IconButton(
                    onPressed: () {
                      _auth.signOut();
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              alignment: Alignment.centerRight,
                              duration: const Duration(milliseconds: 600),
                              type: PageTransitionType.bottomToTopPop,
                              childCurrent: const CanteenHome(),
                              child: LoginPage()));
                    },
                    icon: const Icon(Icons.power_settings_new_rounded))
              ],
              flexibleSpace: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xff7732B1), Color(0xffC38DDB)])))),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    height: 15.h,
                    width: 100.w,
                    color: Colors.white,
                    child: Column(
                      children: [
                        isadding
                            ? SizedBox(
                                height: 8.h,
                                child: ListView(
                                  physics: const BouncingScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics()),
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    getOrderCard(),
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: 8.h,
                                child: Center(
                                  child: Text(
                                      "Start adding items by clicking on +",
                                      style:
                                          TextStyle(color: Colors.grey[400])),
                                ),
                              ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(2.w, 1.w, 2.w, 0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ButtonTheme(
                                    minWidth: 20.w,
                                    height: 6.w,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.w)),
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          orderNames = [];
                                          count = List.filled(itemscount, 0);
                                          oc!.length = 0;
                                          finalTotal = 0;
                                          isadding = false;
                                          orderCount = [];
                                        });
                                      },
                                      child: Text("clear",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w400)),
                                    )),
                                Row(children: [
                                  const Text("Total : "),
                                  Container(
                                    height: 9.w,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2.w),
                                      child: Center(
                                          child: Text("Rs. $finalTotal",
                                              style:
                                                  TextStyle(fontSize: 12.sp))),
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(1.w),
                                        color: const Color(0xffE7D3F4)),
                                  )
                                ])
                              ]),
                        )
                      ],
                    )),
                Divider(
                  height: 0,
                  color: Colors.grey[300],
                  thickness: 0.4.w,
                ),
                Padding(
                  padding: EdgeInsets.all(2.w),
                  child: Text(
                    "ITEMS",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                    width: 94.w,
                    height: 61.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.w),
                        color: const Color(0xffF4F4F4)),
                    child: ListView(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      children: [
                        SizedBox(height: 2.w),
                        isLoaded
                            ? listofitemscard()
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 11.h),
                                  SizedBox(
                                    height: 30.w,
                                    width: 30.w,
                                    child: Image.asset("assets/images/cup.png"),
                                  ),
                                  SpinKitThreeInOut(
                                    color: Color.fromARGB(255, 144, 80, 197),
                                    size: 10.w,
                                  ),
                                ],
                              ),
                      ],
                    )),
                SizedBox(height: 2.h),
                Padding(
                  padding: EdgeInsets.fromLTRB(2.w, 0, 2.w, 3.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ButtonTheme(
                          minWidth: 45.w,
                          height: 12.w,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.w)),
                          child: RaisedButton(
                              onPressed: () async {
                                setorderCount();

                                await _firestore
                                    .collection("Canteen")
                                    .doc("orders")
                                    .collection("orderDetails")
                                    .doc("${totalorders + 1}")
                                    .set(
                                  {
                                    "Person": cuser,
                                    "FoodItems": orderCount,
                                    "Total": finalTotal,
                                    "isPaid": false,
                                    "status": "Not-Delivered",
                                    "OrderNumber": totalorders + 1,
                                  },
                                );
                                await _firestore
                                    .collection("Canteen")
                                    .doc("TotalOrders")
                                    .set(
                                  {
                                    "count": totalorders + 1,
                                    "count2": totalorders + 1,
                                  },
                                );

                                setState(() {
                                  totalorders = 0;
                                  orderNames = [];
                                  oc = [];
                                  orderCount = [];
                                });
                                emptyLists();
                                getUserData();
                                getTotalOrders();
                                setState(() {
                                  isLoading = true;
                                  isLoaded = false;
                                });

                                getCount();
                                Future.delayed(
                                    const Duration(milliseconds: 500), () {});
                                getItems();
                                Future.delayed(
                                    const Duration(milliseconds: 2200), () {
                                  setState(() {
                                    isLoaded = true;
                                    isLoading = false;
                                    isadding =
                                        false; // Here you can write your code for open new view
                                  });
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => PayLater()));
                              },
                              elevation: 0,
                              color: const Color(0XFFD3D2D2),
                              child: Text("Pay Later",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400)))),
                      Container(
                        height: 12.w,
                        width: 45.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.w),
                            gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xff7732B1),
                                  Color(0xffC38DDB)
                                ])),
                        child: ButtonTheme(
                            minWidth: 45.w,
                            height: 12.w,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.w)),
                            child: RaisedButton(
                                onPressed: () {},
                                elevation: 0,
                                color: Colors.transparent,
                                child: Text("Pay Now",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400)))),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ));
    });
  }
}

class Card {
  late String name;
  late int cost;
  Card(this.name, this.cost);
}
