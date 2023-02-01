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
          var row = InkWell(
            onTap: (){
              showProductionDetails(farm, context);
            },
            child: Container(
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


Future<void> showProductionDetails(Production item,BuildContext context){
  return showModalBottomSheet(context: context,shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20)
      )
  ), builder: (context){
    return ProductionDetails(production: item);
  });
}


class ProductionDetails extends StatefulWidget{
  final Production production;
  const ProductionDetails({super.key, required this.production});

  @override
  State<ProductionDetails> createState() => _ProductionDetailsState();
}

class _ProductionDetailsState extends Superbase<ProductionDetails> {

  bool loading = false;

  void deleteTransaction()async{
    setState(() {
      loading = true;
    });
    await ajax(url: "finance/deleteProduction",method: "POST",data: FormData.fromMap({
      "transaction_id":widget.production.id,
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
    var item = widget.production;
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
                child: Text("Production details",style: TextStyle(
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
                  const Expanded(child: Text("Production Tag")),
                  Text(item.tag),
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
                  const Expanded(child: Text("Quantity")),
                  Text(fmtNbr(item.quantity)),
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
                  // ElevatedButton(onPressed: ()async{
                  //   // await push(TransactionRegistration(transaction: item,));
                  //   goBack();
                  // },style: ElevatedButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(
                  //         vertical: 11,
                  //         horizontal: 35
                  //     ),
                  //     backgroundColor: const Color(0xffD4F6EB),
                  //     foregroundColor: Colors.black87
                  // ), child: const Text("Edit")),
                  // ElevatedButton(onPressed: ()async{
                  //   var x = await confirmDialog(context);
                  //   if(x == true){
                  //     deleteTransaction();
                  //   }
                  // },style: ElevatedButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(
                  //         vertical: 11,
                  //         horizontal: 40
                  //     ),
                  //     backgroundColor: const Color(0xffFBC1C1),
                  //     foregroundColor: Colors.black87
                  // ), child: const Text("Delete")),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}