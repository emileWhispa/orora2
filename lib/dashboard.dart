import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orora2/bar_chat_sample.dart';
import 'package:orora2/expenses_list.dart';
import 'package:orora2/farm_list_screen.dart';
import 'package:orora2/farm_production_list.dart';
import 'package:orora2/feeds_screen.dart';
import 'package:orora2/income_list.dart';
import 'package:orora2/json/user.dart';
import 'package:orora2/report_screen.dart';
import 'package:orora2/search_delegate.dart';
import 'package:orora2/super_base.dart';

import 'json/farm.dart';
import 'search_screen.dart';

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
  int budget = 0;

  List<Farm> _farms = [];
  Farm? _farm;
  final _key = GlobalKey<RefreshIndicatorState>();

  
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadFarms();
    });
    super.initState();
  }

  Future<void> loadFarms() {
    return ajax(
        url: "farms/myFarms",
        method: "POST",
        data: FormData.fromMap({"token": User.user?.token}),
        onValue: (obj, url) {
          setState(() {
            _farms =
                (obj['data'] as Iterable?)?.map((e) => Farm.fromJson(e)).toList() ?? [];
            if(_farm == null && _farms.isNotEmpty){
              _farm = _farms.first;
              loadData();
            }
          });
        });
  }
  Map? incomeData;
  Map? expensesData;

  Future<void> loadData(){
    return ajax(url: "home/index.php",method: "POST",data: FormData.fromMap({
      "token":User.user?.token,
      "farm_id":_farm?.id??"",
    }),onValue: (s,v){
      if(s['code'] == 200) {
        setState(() {
          expenses = s['expenses'];
          budget = s['budget'];
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
        key: _key,
        onRefresh: loadData,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                Container(
                  height: 220,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor
                  ),
                  height: 170,
                ),
                Positioned.fill(child: Padding(
                  padding: const EdgeInsets.all(15.0).copyWith(top: MediaQuery.of(context).padding.top,bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Expanded(
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(right: 8),
                          //     child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Text(message,style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          //           color: Colors.white
                          //         ),),
                          //         Text("This is how your business is doing",style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          //             color: Colors.white
                          //         ),),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          Expanded(child: Align(alignment: Alignment.centerLeft,child: Image.asset("assets/logo_new.png",fit: BoxFit.cover,height: 30,))),
                          SizedBox(
                            height: 40,
                            width: 130,
                            child: DropdownButtonFormField<Farm>(
                              isExpanded: true,
                              validator: (s)=>s == null ? "Farm is required !" : null,
                              value: _farm,
                              items: _farms
                                  .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name,maxLines: 1,overflow: TextOverflow.ellipsis,),
                              ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  _farm = val;
                                  _key.currentState?.show();
                                });
                              },
                              style: const TextStyle(
                                color: Colors.black
                              ),
                              decoration: InputDecoration(hintText: "Farm",filled: true,fillColor: Colors.transparent,contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15
                              ),border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none
                              )),
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
                                showSearch(context: context, delegate: SearchDemoSearchDelegate((query){
                                  return SearchScreen(query: query);
                                }));
                              },icon: const Icon(Icons.search),),
                            ),
                          )
                        ],
                      ),
                      Card(
                        margin: EdgeInsets.zero.copyWith(top: 15),
                        elevation: 12,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 30),
                          child: Row(
                            children: [
                              Expanded(child: InkWell(
                                onTap: (){
                                  push(const IncomeList());
                                },
                                child: Row(
                                  children: [
                                    Image.asset("assets/sales.png",width: 30,),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("${formatter.format(sales)} RWF",style: const TextStyle(
                                              color: Color(0xff3C9343),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700
                                            ),maxLines: 1,overflow: TextOverflow.ellipsis),
                                            const Text("Income",style: TextStyle(
                                              fontSize: 11
                                            ),)
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                              Expanded(child: InkWell(
                                onTap: (){
                                  push(const IncomeList());
                                },
                                child: Row(
                                  children: [
                                    Image.asset("assets/budget.png",width: 30,),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("${formatter.format(budget)} RWF",style: const TextStyle(
                                              color: Color(0xff357ED9),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700
                                            ),maxLines: 1,overflow: TextOverflow.ellipsis),
                                            const Text("Budget",style: TextStyle(
                                              fontSize: 11
                                            ),)
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                              Expanded(child: InkWell(
                                onTap: (){
                                  push(const ExpensesList());
                                },
                                child: Row(
                                  children: [
                                    Image.asset("assets/expenses.png",width: 30,),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("${formatter.format(expenses)} RWF",style: const TextStyle(
                                              color: Color(0xffD80404),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700
                                            ),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                            const Text("Expenses",style: TextStyle(
                                              fontSize: 11
                                            ),)
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
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
                              child: Text(formatter.format(myFarms),maxLines: 2,overflow: TextOverflow.ellipsis,style: const TextStyle(
                                  fontSize: 25,
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
                    ),child: InkWell(
                      onTap: (){
                        push(const FeedsScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Feeds",style: TextStyle(
                              fontSize: 14
                            ),textAlign: TextAlign.center,),
                             Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(formatter.format(feeds),maxLines: 2,overflow: TextOverflow.ellipsis,style: const TextStyle(
                                  fontSize: 25,
                                fontWeight: FontWeight.w700
                              ),),
                            ),
                            Image.asset("assets/clop.png")
                          ],
                        ),
                      ),
                    ),),
                  )),
                  Expanded(child: SizedBox(
                    height: 200,
                    child: Card(color: const Color(0xffFDE9D0),shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),child: InkWell(
                      onTap: (){
                        push(const FarmProductionList());
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
                              child: Text(formatter.format(farmProduction),maxLines: 2,overflow: TextOverflow.ellipsis,style: const TextStyle(
                                  fontSize: 25,
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
            Padding(padding: const EdgeInsets.all(15),child: SizedBox(height: 220,child: incomeData != null && expensesData != null ? BarChartSample2(
              title: "Daily Transactions",
              incomeData: incomeData!,
              expenses: expensesData!,
            )
                : const Center(child: CircularProgressIndicator())),),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                height: 200,
                child: Row(
                  children: [
                    Expanded(child: Card(child: InkWell(onTap: (){
                      push(const ReportScreen());
                    },child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text("Reports",style: Theme.of(context).textTheme.titleLarge,),
                          Expanded(child: Image.asset("assets/reports.png")),
                        ],
                      ),
                    )))),
                    Expanded(child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text("Activities",style: Theme.of(context).textTheme.titleLarge,),
                            Expanded(child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Image.asset("assets/ellipse.png"),
                            )),
                          ],
                        ),
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}