import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:orora2/create_farm_production.dart';
import 'package:orora2/json/transaction.dart';
import 'package:orora2/super_base.dart';

import 'json/farm.dart';
import 'json/production.dart';
import 'json/user.dart';

class ExpensesList extends StatefulWidget{
  const ExpensesList({super.key});

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends Superbase<ExpensesList> {

  List<Transaction> _list = [];
  final _key = GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData();
    });
    super.initState();
  }

  Future<void> loadData(){
    return ajax(url: "reports/expenses",method: "POST",data: FormData.fromMap(
        {
          "token":User.user?.token,
        }),onValue: (obj,url){
      setState(() {
        _list = (obj['expenses'] as Iterable?)?.map((e) => Transaction.fromJson(e)).toList() ?? [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses list"),
      ),
      body: RefreshIndicator(
        onRefresh: loadData,
        key: _key,
        child: ListView.builder(itemCount: _list.length,itemBuilder: (context,index){
          var farm = _list[index];
          var row = Container(
            decoration: BoxDecoration(
                color: index % 2 == 0 ? Theme.of(context).primaryColorLight : null
            ),
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(child: Text(farm.date)),
                Expanded(child: Text(formatter.format(farm.amount))),
                Expanded(child: Text(farm.category??"")),
              ],
            ),
          );

          if(index == 0){
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: const [
                      Expanded(child: Text("Date",style: TextStyle(
                          fontWeight: FontWeight.bold
                      ))),
                      Expanded(child: Text("Amount",style: TextStyle(
                          fontWeight: FontWeight.bold
                      ))),
                      Expanded(child: Text("Category",style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),)),
                    ],
                  ),
                ),
                row
              ],
            );
          }

          return row;
        }),
      ),
    );
  }
}