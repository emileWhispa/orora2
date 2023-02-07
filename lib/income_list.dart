import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:orora2/json/transaction.dart';
import 'package:orora2/super_base.dart';

import 'finance_dashboard.dart';
import 'json/user.dart';

class IncomeList extends StatefulWidget{
  final DateTime? start;
  final DateTime? end;
  const IncomeList({super.key, this.start, this.end});

  @override
  State<IncomeList> createState() => _IncomeListState();
}

class _IncomeListState extends Superbase<IncomeList> {

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
    var map = {
      "token":User.user?.token
    };

    if(widget.start != null && widget.end != null){
      map.addAll({
        "from":fmtDate2(widget.start),
        "to":fmtDate2(widget.end)
      });
    }

    return ajax(url: "reports/income",method: "POST",data: FormData.fromMap(map),onValue: (obj,url){
      setState(() {
        _list = (obj['income'] as Iterable?)?.map((e) => Transaction.fromJson(e)).toList() ?? [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Income"),
      ),
      body: RefreshIndicator(
        onRefresh: loadData,
        key: _key,
        child: ListView.builder(itemCount: _list.length,itemBuilder: (context,index){
          var farm = _list[index];
          var row = InkWell(
            onTap: ()async{
              await showTransactionDetails(farm, context);
              _key.currentState?.show();
            },
            child: Container(
              decoration: BoxDecoration(
                  color: index % 2 == 0 ? Theme.of(context).primaryColorLight : null
              ),
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(child: Text(farm.date)),
                  Expanded(child: Text(fmtNbr(farm.amount))),
                  Expanded(child: Text(farm.category??"")),
                ],
              ),
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