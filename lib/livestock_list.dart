import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orora2/livestock_profile.dart';
import 'package:orora2/livestock_registration.dart';
import 'package:orora2/super_base.dart';

import 'json/farm.dart';
import 'json/livestock.dart';
import 'json/user.dart';

class LivestockList extends StatefulWidget {
  final Farm farm;
  final bool fromProduction;

  const LivestockList(
      {super.key, required this.farm, this.fromProduction = false});

  @override
  State<LivestockList> createState() => _LivestockListState();
}

class _LivestockListState extends Superbase<LivestockList> {
  List<Livestock> _livestocks = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData();
    });
    super.initState();
  }

  Future<void> loadData() {
    return ajax(
        url: "farms/myLivestocks",
        method: "POST",
        data: FormData.fromMap({
          "token": User.user?.token,
          "farm_id": widget.farm.id,
        }),
        onValue: (obj, url) {
          setState(() {
            _livestocks = (obj['data'] as Iterable?)
                    ?.map((e) => Livestock.fromJson(e))
                    .toList() ??
                [];
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.farm.name),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => LivestockRegistration(
                      farm: widget.farm,
                    )));
          }, icon: const Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadData,
        child: GridView.builder(
            itemCount: _livestocks.length,
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: (context, index) {
              // if (!widget.fromProduction) {
              //   index = index - 1;
              //   if (index < 0) {
              //     return SizedBox(
              //       height: 200,
              //       child: Card(
              //         clipBehavior: Clip.antiAliasWithSaveLayer,
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(10)),
              //         child: InkWell(
              //           onTap: () {
              //           },
              //           child: Padding(
              //             padding: const EdgeInsets.all(12.0),
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: const [
              //                 Text(
              //                   "Add New Livestock",
              //                   style: TextStyle(
              //                       fontSize: 14, fontWeight: FontWeight.bold),
              //                   textAlign: TextAlign.center,
              //                 ),
              //                 Padding(
              //                   padding: EdgeInsets.only(top: 0.0),
              //                   child: Icon(
              //                     Icons.add,
              //                     size: 50,
              //                   ),
              //                 )
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //     );
              //   }
              // }

              var livestock = _livestocks[index];
              return SizedBox(
                height: 200,
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: const Color(0xffD5EAE3),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: widget.fromProduction
                        ? () {

                          }
                        : (){
                      push(LivestockProfile(livestock: livestock));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "#${livestock.tag??""}",
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Image.asset("assets/goat.png"),
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
