import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orora2/farm_production_list.dart';
import 'package:orora2/farm_profile.dart';
import 'package:orora2/farm_registration.dart';
import 'package:orora2/json/user.dart';
import 'package:orora2/livestock_list.dart';
import 'package:orora2/super_base.dart';

import 'json/farm.dart';

class FarmListScreen extends StatefulWidget{
  final bool fromProduction;
  const FarmListScreen({super.key, this.fromProduction = false});

  @override
  State<FarmListScreen> createState() => _FarmListScreenState();
}

class _FarmListScreenState extends Superbase<FarmListScreen> {

  List<Farm> _farms = [];


  final _key = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      reload();
    });
    super.initState();
  }

  Future<void> loadData(){
    return ajax(url: "farms/myFarms",method: "POST",data: FormData.fromMap({
      "token":User.user?.token
    }),onValue: (obj,url){
      setState(() {
        _farms = (obj['data'] as Iterable?)?.map((e) => Farm.fromJson(e)).toList() ?? [];
      });
    });
  }

  void reload(){
    _key.currentState?.show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Farms"),
        actions: [
          IconButton(onPressed: ()async{
            await Navigator.push(context, CupertinoPageRoute(builder: (context)=>const FarmRegistration()));
            reload();
          }, icon: const Icon(Icons.add)),
        ],
      ),
      body: RefreshIndicator(
        key: _key,
        onRefresh: loadData,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,childAspectRatio: 0.8),
          itemCount: _farms.length+(widget.fromProduction ? 0 : 0),
          itemBuilder: (context,index){

            // if(!widget.fromProduction){
            //   index = index - 1;
            //   if(index < 0 ){
            //     return Card(clipBehavior: Clip.antiAliasWithSaveLayer,shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10)
            //     ),child: InkWell(
            //       onTap: (){
            //         Navigator.push(context, CupertinoPageRoute(builder: (context)=>const FarmRegistration()));
            //       },
            //       child: Padding(
            //         padding: const EdgeInsets.all(15.0),
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: const [
            //             Text("Add New Farm",style: TextStyle(
            //                 fontSize: 14,
            //                 fontWeight: FontWeight.bold
            //             ),textAlign: TextAlign.center,),
            //             Padding(
            //               padding: EdgeInsets.all(5.0),
            //               child: Icon(Icons.add,size: 40,),
            //             )
            //           ],
            //         ),
            //       ),
            //     ),);
            //   }
            // }

            var farm = _farms[index];

            return Card(clipBehavior: Clip.antiAliasWithSaveLayer,color: const Color(0xffD5EAE3),shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),child: InkWell(
              onTap: widget.fromProduction ? (){

              } : (){
                if(widget.fromProduction) {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) =>
                          LivestockList(farm: farm,
                            fromProduction: widget.fromProduction,)));
                }else{
                  push(FarmProfile(farm: farm));
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  farm.picture != null ? Expanded(child: Image(image: CachedNetworkImageProvider(farm.picture!),frameBuilder: frameBuilder,width: double.infinity,fit: BoxFit.cover,)) : const SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(farm.name,style: const TextStyle(
                        fontSize: 14
                    ),textAlign: TextAlign.center,),
                  ),
                   Text(fmtNbr(farm.livestocks),style: const TextStyle(
                       fontSize: 29,
                       fontWeight: FontWeight.w700
                   ),),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: [
                            const WidgetSpan(child: Icon(Icons.location_on_outlined,size: 15,)),
                            TextSpan(text: farm.sector)
                          ]
                      ),
                    ),
                  )
                ],
              ),
            ),);
          },
          padding: const EdgeInsets.all(12),
        ),
      ),
    );
  }
}