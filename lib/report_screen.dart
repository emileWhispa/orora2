import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:orora2/report_bar_chart.dart';
import 'package:orora2/super_base.dart';

import 'bar_chat_sample.dart';
import 'json/user.dart';

class ReportScreen extends StatefulWidget{
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends Superbase<ReportScreen> {

  String message = "";
  int income = 0;
  int profit = 0;
  int expenses = 0;
  late DateTime start;
  late DateTime end;

  @override
  void initState() {
    end = DateTime.now();
    start = end.subtract(const Duration(days: 30));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData();
    });
    super.initState();
  }

  Map? incomeData;
  Map? expensesData;

  Future<void> loadData(){
    return ajax(url: "reports/",method: "POST",data: FormData.fromMap({
      "token":User.user?.token
    }),onValue: (s,v){
      if(s['code'] == 200) {
        setState(() {
          incomeData = s['chart']['income'];
          expensesData = s['chart']['expenses'];
          income = s['income'];
          profit = s['profit'];
          expenses = s['expenses'];
        });
        refreshData();
      }else if(s['code'] == 403){
        logOut();
      }
    },error: (s,v){
      refreshData();
    });
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
                                  Text("${fmtDate2(start)} - ${fmtDate2(end)}",style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.white
                                  ),),
                                ],
                              ),
                            ),
                          ),
                          Theme(
                            data: ThemeData(
                              primarySwatch: Colors.green,
                              primaryColor: Theme.of(context).primaryColor,
                              appBarTheme: AppBarTheme(
                                color: Theme.of(context).primaryColor
                              )
                            ),
                            child: Builder(
                              builder: (context) {
                                return IconButton(onPressed: ()async {
                                  var data = await showDateRangePicker(context: context,initialDateRange: DateTimeRange(start: start, end: end),initialEntryMode: DatePickerEntryMode.calendarOnly, firstDate: DateTime.now().subtract(const Duration(days: 365)), lastDate: DateTime.now());
                                  if(data != null){
                                    setState(() {
                                      start = data.start;
                                      end = data.end;
                                    });
                                  }
                                },color: Colors.white, icon: const Icon(Icons.calendar_month));
                              }
                            ),
                          ),
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
                                child:  Center(
                                  child: Text(formatter.format(profit),style: const TextStyle(
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
                                      children: [
                                        Text(formatter.format(income),style: const TextStyle(
                                          color: Color(0xff3C9343),
                                          fontWeight: FontWeight.bold
                                        ),),
                                        const Text("Income",style: TextStyle(
                                          color: Color(0xff3C9343),
                                        ),),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children:  [
                                      Text(formatter.format(expenses),style: const TextStyle(
                                          color: Color(0xffE44747),
                                          fontWeight: FontWeight.bold
                                      ),),
                                      const Text("Expenses",style: TextStyle(
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
            Padding(padding: const EdgeInsets.all(15),child: SizedBox(height: 250,child: incomeData != null && expensesData != null ? BarChartSample2(
              incomeData: incomeData!,
              expenses: expensesData!,
            )
                : const Center(child: CircularProgressIndicator())),),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87
              ),onPressed: goBack, child: const Text("Back To Home")),
            )
          ],
        ),
      ),
    );
  }
}