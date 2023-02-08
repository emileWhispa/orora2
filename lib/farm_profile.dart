import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:orora2/edit_profile_picture.dart';
import 'package:orora2/farm_registration.dart';
import 'package:orora2/livestock_list.dart';
import 'package:orora2/super_base.dart';

import 'json/farm.dart';
import 'json/user.dart';

class FarmProfile extends StatefulWidget{
  final Farm farm;

  const FarmProfile({super.key, required this.farm});

  @override
  State<FarmProfile> createState() => _FarmProfileState();
}

class _FarmProfileState extends Superbase<FarmProfile> {

  int livestock = 0;
  int income = 0;
  int expenses = 0;

  @override
  void initState() {
    livestock = widget.farm.livestocks;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) =>loadData());
    super.initState();
  }
  
  void loadData(){
    ajax(url: "farms/profile",method: "POST",data: FormData.fromMap({
      "token":User.user?.token,
      "farm_id":widget.farm.id
    }),onValue: (map,v){
      setState(() {
        expenses = map['expenses'];
        income = map['income'];
        livestock = map['livestock'];
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xff3C9343)
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(onPressed: ()async{
    await showModalBottomSheet(context: context,shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20)
      )
    ),builder: (context)=>EditProfilePicture(farm: widget.farm,));
    setState(() {

    });
    }, icon: const Icon(FontAwesome.edit)),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration:  BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,colors: [
              const Color(0xff617c0e),
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
              Colors.white,
              Colors.white,
              Colors.white,
            ]),
          image: widget.farm.picture != null ?  DecorationImage(image: CachedNetworkImageProvider(widget.farm.picture!),fit: BoxFit.fitWidth,alignment: Alignment.topCenter): null,
        ),
        child: ListView(
          children: [
            const SizedBox(height: 110,),
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)
                  )
              ),
              child: Padding(padding: const EdgeInsets.all(20),child: Column(
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [

                          Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Color(0xffDADADA)
                                    )
                                )
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: InkWell(
                              onTap: ()async{
                                await push(FarmRegistration(farm: widget.farm,));
                                setState(() {

                                });
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(radius:23,child: Image.asset("assets/info_vector.png"),),
                                  Expanded(child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: const [
                                        Text("Farm Information",style: TextStyle(
                                            fontSize: 16
                                        ),),
                                        SizedBox(height: 5,),
                                        Text("Address, Category",style: TextStyle(
                                            color: Color(0xff403939)
                                        ),),
                                      ],
                                    ),
                                  )),
                                  const Icon(FontAwesome.edit,color: Color(0xffB6ADAD),)
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Color(0xffDADADA)
                                    )
                                )
                            ),
                            child: InkWell(
                              onTap: ()async{
                                push(LivestockList(farm: widget.farm));
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(radius:23,child: Image.asset("assets/cow-silhouette.png"),),
                                  Expanded(child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children:  [
                                        const Text("Livestock",style: TextStyle(
                                            fontSize: 16
                                        ),),
                                        const SizedBox(height: 5,),
                                        Text(fmtNbr(livestock),style:const TextStyle(
                                            color: Color(0xff403939),
                                          fontSize: 18
                                        ),),
                                      ],
                                    ),
                                  )),
                                  const Icon(Icons.arrow_forward_ios,color: Color(0xffB6ADAD),)
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Color(0xffDADADA)
                                    )
                                )
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: InkWell(
                              onTap: ()async{

                              },
                              child: Row(
                                children: [
                                  CircleAvatar(radius:23,child: Image.asset("assets/income.png",height: 25,fit: BoxFit.cover,),),
                                  Expanded(child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children:  [
                                        const Text("Income",style: TextStyle(
                                            fontSize: 16
                                        ),),
                                        const SizedBox(height: 5,),
                                        Text(formatter.format(income),style:const TextStyle(
                                            color: Color(0xff403939),
                                            fontSize: 18
                                        ),),
                                      ],
                                    ),
                                  )),
                                  const Icon(Icons.arrow_forward_ios,color: Color(0xffB6ADAD),)
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: InkWell(
                              onTap: ()async{

                              },
                              child: Row(
                                children: [
                                   CircleAvatar(radius:23,backgroundColor: Colors.red.shade100,child: Image.asset("assets/expenses.png",height: 20,),),
                                  Expanded(child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children:  [
                                        const Text("Expenses",style: TextStyle(
                                            fontSize: 16
                                        ),),
                                        const SizedBox(height: 5,),
                                        Text(formatter.format(expenses),style:const TextStyle(
                                            color: Color(0xff403939),
                                          fontSize: 18
                                        ),),
                                      ],
                                    ),
                                  )),
                                  const Icon(Icons.arrow_forward_ios,color: Color(0xffB6ADAD),)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),),
            ),
          ],
        ),
      ),
    );
  }
}