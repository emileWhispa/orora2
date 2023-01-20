import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:orora2/report_bar_chart.dart';
import 'package:orora2/super_base.dart';

import 'json/user.dart';

class ReportScreen extends StatefulWidget{
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends Superbase<ReportScreen> {

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

  Map? incomeData;
  Map? expensesData;

  Future<void> loadData(){
    return ajax(url: "home/index.php",method: "POST",data: FormData.fromMap({
      "token":User.user?.token
    }),onValue: (s,v){
      if(s['code'] == 200) {
        setState(() {
          expenses = s['expenses'];
          farmProduction = s['farmProduction'];
          feeds = s['feeds'];
          incomeData = s['week']['income'];
          expensesData = s['week']['expenses'];
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
                  height: 330,
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
                                  Text("Reports",style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: Colors.white
                                  ),),
                                  Text("2023-01-01 - 2023-01-15",style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.white
                                  ),),
                                ],
                              ),
                            ),
                          ),
                          IconButton(onPressed: (){},color: Colors.white, icon: const Icon(Icons.calendar_month)),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Center(
                                child: Text("Profit",style: TextStyle(
                                  color: Color(0xff9FB666)
                                ),),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade200
                                    )
                                  )
                                ),
                                padding: const EdgeInsets.only(bottom: 20),
                                margin: const EdgeInsets.only(bottom: 10),
                                child: const Center(
                                  child: Text("2,058,500",style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold
                                  ),),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text("1,200940",style: TextStyle(
                                          color: Color(0xff3C9343),
                                          fontWeight: FontWeight.bold
                                        ),),
                                        Text("Income",style: TextStyle(
                                          color: Color(0xff3C9343),
                                        ),),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: const [
                                      Text("1,200940",style: TextStyle(
                                          color: Color(0xffE44747),
                                          fontWeight: FontWeight.bold
                                      ),),
                                      Text("Income",style: TextStyle(
                                        color: Color(0xffE44747),
                                      ),textAlign: TextAlign.end,),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
              ],
            ),
            Padding(padding: const EdgeInsets.all(15),child: SizedBox(height: 300,child: incomeData != null && expensesData != null ? ReportBarChat(
              incomeData: incomeData!,
              expenses: expensesData!,
            )
                : const Center(child: CircularProgressIndicator())),),

            TextButton(onPressed: goBack, child: const Text("Cancel"))
          ],
        ),
      ),
    );
  }
}