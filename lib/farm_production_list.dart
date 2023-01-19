import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:orora2/create_farm_production.dart';
import 'package:orora2/super_base.dart';

import 'json/farm.dart';
import 'json/production.dart';
import 'json/user.dart';

class FarmProductionList extends StatefulWidget{
  final Farm farm;
  const FarmProductionList({super.key, required this.farm});

  @override
  State<FarmProductionList> createState() => _FarmProductionListState();
}

class _FarmProductionListState extends Superbase<FarmProductionList> {

  List<Production> _list = [];
  final _key = GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData();
    });
    super.initState();
  }

  Future<void> loadData(){
    return ajax(url: "production/production",method: "POST",data: FormData.fromMap(
        {
          "token":User.user?.token,
          "farm_id":widget.farm.id
        }),onValue: (obj,url){
      setState(() {
        _list = (obj['data'] as Iterable?)?.map((e) => Production.fromJson(e)).toList() ?? [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Farm Productions"),
        actions: [
          IconButton(onPressed: ()async{
            await push(CreateFarmProduction(farm: widget.farm));
            _key.currentState?.show();
          }, icon: const Icon(Icons.add))
        ],
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
                Expanded(child: Text(farm.tag)),
                Expanded(child: Text(fmtNbr(farm.quantity))),
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
                      Expanded(child: Text("Livestock",style: TextStyle(
                          fontWeight: FontWeight.bold
                      ))),
                      Expanded(child: Text("Quantity",style: TextStyle(
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