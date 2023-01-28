import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orora2/expenses_list.dart';
import 'package:orora2/json/user.dart';
import 'package:orora2/super_base.dart';
import 'package:orora2/transaction_registration.dart';

import 'income_list.dart';
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
  int expenses = 0;
  int income = 0;

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
                (obj['data'] as Iterable?)?.map((e) => Farm.fromJson(e)).toList() ?? [];
            if(_farm == null && _farms.isNotEmpty){
              _farm = _farms.first;
              loadData();
            }
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
      if(obj is Map && obj.containsKey("summary")) {
        setState(() {
          expenses = obj['summary']['expenses'];
          income = obj['summary']['income'];
          _transactions = (obj['data'] as Iterable?)
              ?.map((e) => Transaction.fromJson(e))
              .toList() ?? [];
        });
      }
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
                  height: 250,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor
                  ),
                  height: 175,
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
                                child: IconButton(onPressed: ()async {
                                  await Navigator.push(context, CupertinoPageRoute(builder: (context)=>const TransactionRegistration()));
                                  _key.currentState?.show();
                                }, icon: const Icon(Icons.add,size: 33,),padding: EdgeInsets.zero,),
                              ),
                            ),
                          )
                        ],
                      ),
                      Card(
                        elevation: 12,
                        shadowColor: Colors.black26,
                        margin: EdgeInsets.zero.copyWith(top: 20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 35),
                          child: Row(
                            children: [
                              Expanded(child: InkWell(
                                onTap: (){
                                  push(const IncomeList());
                                },
                                child: Row(
                                  children: [
                                    Image.asset("assets/sales.png"),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children:  [
                                            Text("${formatter.format(income)} RWF",style: const TextStyle(
                                                color: Color(0xff3C9343),
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700
                                            ),),
                                            const Text("Income")
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
                                    Image.asset("assets/expenses.png"),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("${formatter.format(expenses)} RWF",style: const TextStyle(
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
            );
          }

          var item = _transactions[index];

          var color = item.type == 'expenditure' ? Colors.red : Theme.of(context).primaryColor;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Card(
              child: InkWell(
                onTap: ()async{
                  await showTransactionDetails(item, context);
                  _key.currentState?.show();
                },
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
                            Text("${fmtNbr(item.amount)} RWF",style: TextStyle(
                              color: color
                            ),)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}



Future<void> showTransactionDetails(Transaction item,BuildContext context){
  return showModalBottomSheet(context: context,shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)
        )
    ), builder: (context){
      return TransactionDetails(transaction: item);
    });
}


class TransactionDetails extends StatefulWidget{
  final Transaction transaction;
  const TransactionDetails({super.key, required this.transaction});

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends Superbase<TransactionDetails> {

  bool loading = false;

  void deleteTransaction()async{
    setState(() {
      loading = true;
    });
    await ajax(url: "finance/deleteTransaction",method: "POST",data: FormData.fromMap({
      "transaction_id":widget.transaction.id,
      "token": User.user?.token
    }),onValue: (s,v){
      if(s['code'] == 200){
        goBack();
      }
      showSnack(s['message']);
    });
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var item = widget.transaction;
    return Container(
      padding: const EdgeInsets.all(20),
      child: loading ? const Center(
        child: CircularProgressIndicator(),
      ) : SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text("Transaction details",style: TextStyle(
                    fontWeight: FontWeight.bold
                ),),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          style: BorderStyle.solid,
                          color: Colors.grey.shade300
                      )
                  )
              ),
              child: Row(
                children: [
                  const Expanded(child: Text("Category")),
                  Text(item.category??""),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          style: BorderStyle.solid,
                          color: Colors.grey.shade300
                      )
                  )
              ),
              child: Row(
                children: [
                  const Expanded(child: Text("Date")),
                  Text(item.date),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          style: BorderStyle.solid,
                          color: Colors.grey.shade300
                      )
                  )
              ),
              child: Row(
                children: [
                  const Expanded(child: Text("Transaction")),
                  Text(item.name??""),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          style: BorderStyle.solid,
                          color: Colors.grey.shade300
                      )
                  )
              ),
              child: Row(
                children: [
                  const Expanded(child: Text("Amount")),
                  Text(fmtNbr(item.amount)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
              ),
              child: Row(
                children: [
                  const Expanded(child: Text("Description")),
                  Text(item.notes??""),
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(onPressed: ()async{
                    await push(TransactionRegistration(transaction: item,));
                    goBack();
                  },style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 11,
                          horizontal: 35
                      ),
                      backgroundColor: const Color(0xffD4F6EB),
                      foregroundColor: Colors.black87
                  ), child: const Text("Edit")),
                  ElevatedButton(onPressed: ()async{
                    var x = await confirmDialog(context);
                    if(x == true){
                      deleteTransaction();
                    }
                  },style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 11,
                          horizontal: 40
                      ),
                      backgroundColor: const Color(0xffFBC1C1),
                      foregroundColor: Colors.black87
                  ), child: const Text("Delete")),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}