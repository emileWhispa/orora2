import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orora2/farm_list_screen.dart';
import 'package:orora2/json/user.dart';
import 'package:orora2/line_chart.dart';
import 'package:orora2/super_base.dart';

class Dashboard extends StatefulWidget{
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends Superbase<Dashboard> {

  String message = "";
  int expenses = 0;
  int sales = 0;
  int myFarms = 0;
  int feeds = 0;
  int farmProduction = 0;
  
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) { 
      loadData();
    });
    super.initState();
  }
  
  Future<void> loadData(){
    return ajax(url: "home/index.php",method: "POST",data: FormData.fromMap({
      "token":User.user?.token
    }),onValue: (s,v){
      if(s['code'] == 200) {
        setState(() {
          expenses = s['expenses'];
          farmProduction = s['farmProduction'];
          feeds = s['feeds'];
          sales = s['sales'];
          message = s['message'];
          myFarms = s['myFarms'];
        });
        refreshData();
      }else if(s['code'] == 403){
        logOut();
      }
    },error: (s,v)=>refreshData());
  }

  void refreshData(){
    Timer(const Duration(seconds: 30), loadData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      body: RefreshIndicator(
        onRefresh: loadData,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                Container(
                  height: 255,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor
                  ),
                  height: 170,
                ),
                Positioned.fill(child: Padding(
                  padding: const EdgeInsets.all(15.0).copyWith(top: MediaQuery.of(context).padding.top),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(message,style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white
                                  ),),
                                  Text("This is how your business is doing",style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.white
                                  ),),
                                ],
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            borderRadius: BorderRadius.circular(1000),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                color: Colors.black26,shape: BoxShape.circle),
                              child: IconButton(color: Colors.white70,onPressed: (){

                              },icon: const Icon(Icons.search),),
                            ),
                          )
                        ],
                      ),
                      Card(
                        margin: EdgeInsets.zero.copyWith(top: 20),
                        elevation: 12,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 35),
                          child: Row(
                            children: [
                              Expanded(child: Row(
                                children: [
                                  Image.asset("assets/expenses.png"),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("${fmtNbr(expenses)} RWF",style: const TextStyle(
                                            color: Color(0xffD80404),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700
                                          ),),
                                          const Text("Expenses")
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )),
                              Expanded(child: Row(
                                children: [
                                  Image.asset("assets/sales.png"),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("${fmtNbr(sales)} RWF",style: const TextStyle(
                                            color: Color(0xff3C9343),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700
                                          ),),
                                          const Text("Sales")
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(child: SizedBox(
                    height: 200,
                    child: Card(clipBehavior: Clip.antiAliasWithSaveLayer,color: const Color(0xffD5EAE3),shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),child: InkWell(
                      onTap: (){
                        Navigator.push(context, CupertinoPageRoute(builder: (context)=>const FarmListScreen()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("My Farms",style: TextStyle(
                              fontSize: 14
                            ),textAlign: TextAlign.center,),
                             Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(fmtNbr(myFarms),style: const TextStyle(
                                  fontSize: 40,
                                fontWeight: FontWeight.w700
                              ),),
                            ),
                            Image.asset("assets/cow.png")
                          ],
                        ),
                      ),
                    ),),
                  )),
                  Expanded(child: SizedBox(
                    height: 200,
                    child: Card(color: const Color(0xffE5E4F9),shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Feeds",style: TextStyle(
                            fontSize: 14
                          ),textAlign: TextAlign.center,),
                           Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(fmtNbr(feeds),style: const TextStyle(
                                fontSize: 40,
                              fontWeight: FontWeight.w700
                            ),),
                          ),
                          Image.asset("assets/clop.png")
                        ],
                      ),
                    ),),
                  )),
                  Expanded(child: SizedBox(
                    height: 200,
                    child: Card(color: const Color(0xffFDE9D0),shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),child: InkWell(
                      onTap: (){
                        Navigator.push(context, CupertinoPageRoute(builder: (context)=>const FarmListScreen(fromProduction: true,)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Farm Production",style: TextStyle(
                              fontSize: 14
                            ),textAlign: TextAlign.center,),
                             Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(fmtNbr(farmProduction),style: const TextStyle(
                                  fontSize: 40,
                                fontWeight: FontWeight.w700
                              ),),
                            ),
                            Image.asset("assets/production.png")
                          ],
                        ),
                      ),
                    ),),
                  )),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.all(15),child: SizedBox(height: 220,child: LineChartSample1()),),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(child: Card(
                    child: Image.asset("assets/ellipse.png"),
                  )),
                  Expanded(child: Card(child: Image.asset("assets/reports.png")))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}