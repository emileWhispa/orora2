import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orora2/json/user.dart';
import 'package:orora2/super_base.dart';
import 'package:orora2/transaction_registration.dart';

import 'input_dec.dart';
import 'json/farm.dart';
import 'json/transaction.dart';

class FinanceDashboard extends StatefulWidget{
  const FinanceDashboard({super.key});

  @override
  State<FinanceDashboard> createState() => _FinanceDashboardState();
}

class _FinanceDashboardState extends Superbase<FinanceDashboard> {


  List<Farm> _farms = [];
  Farm? _farm;

  List<Transaction> _transactions = [];
  final _key = GlobalKey<RefreshIndicatorState>();

  Future<void> loadFarms() {
    return ajax(
        url: "farms/myFarms",
        method: "POST",
        data: FormData.fromMap({"token": User.user?.token}),
        onValue: (obj, url) {
          setState(() {
            _farms =
                (obj['data'] as Iterable).map((e) => Farm.fromJson(e)).toList();
          });
        });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData();
      loadFarms();
    });
    super.initState();
  }

  Future<void> loadData(){
    return ajax(url: "finance/transactions.php",method: "POST",data: FormData.fromMap({
      "token":User.user?.token,
      "farm_id":_farm?.id,
    }),onValue: (obj,url){
      setState(() {
        _transactions = (obj['data'] as Iterable?)?.map((e) => Transaction.fromJson(e)).toList() ?? [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        key: _key,
        onRefresh: loadData,
        child: ListView.builder(padding: EdgeInsets.zero,itemCount: _transactions.length+1,itemBuilder: (context,index){
          index = index -1;
          if(index < 0){
            return Stack(
              children: [
                Container(
                  height: 260,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor
                  ),
                  height: 200,
                ),
                Positioned.fill(child: Padding(
                  padding: const EdgeInsets.all(15.0).copyWith(top: MediaQuery.of(context).padding.top),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: SizedBox(
                              height: 40,
                              child: DropdownButtonFormField<Farm>(
                                validator: (s)=>s == null ? "Farm is required !" : null,
                                isExpanded: true,
                                value: _farm,
                                items: _farms
                                    .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.name),
                                ))
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    _farm = val;
                                    _key.currentState?.show();
                                  });
                                },
                                decoration: InputDecoration(hintText: "Farm",filled: true,fillColor: Colors.black12,contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15
                                ),border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none
                                )),
                              ),
                            ),
                          )),
                          // Expanded(
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(right: 8),
                          //     child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Text("Balance",style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          //             color: Colors.white
                          //         ),),
                          //         Text("395,000 RWF",style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          //             color: Colors.white
                          //         ),),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.black12,
                                    shape: BoxShape.circle
                                ),
                                height: 40,
                                child: IconButton(onPressed: (){
                                  Navigator.push(context, CupertinoPageRoute(builder: (context)=>const TransactionRegistration()));
                                }, icon: const Icon(Icons.add,size: 33,),padding: EdgeInsets.zero,),
                              ),
                            ),
                          )
                        ],
                      ),
                      Card(
                        margin: EdgeInsets.zero.copyWith(top: 20),
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
                                        children: const [
                                          Text("283,520 RWF",style: TextStyle(
                                              color: Color(0xffD80404),
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700
                                          ),),
                                          Text("Expenses")
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
                                        children: const [
                                          Text("625,500 RWF",style: TextStyle(
                                              color: Color(0xffD80404),
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700
                                          ),),
                                          Text("Sales")
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
            );
          }

          var item = _transactions[index];

          var color = item.type == 'expenditure' ? Colors.red : Theme.of(context).primaryColor;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyLarge,
                        children:  [
                          TextSpan(text: item.name??"",style: TextStyle(color: color),),
                          TextSpan(text: ". ${item.date}",),
                        ]
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Text(item.category??"",style: const TextStyle(fontSize: 18),),
                          Text(". ${fmtNbr(item.amount)} RWF",style: TextStyle(
                            color: color
                          ),)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}