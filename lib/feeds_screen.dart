import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:orora2/stock_activity_screen.dart';
import 'package:orora2/super_base.dart';

import 'json/feed.dart';
import 'json/user.dart';

class FeedsScreen extends StatefulWidget{
  const FeedsScreen({super.key});

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends Superbase<FeedsScreen> {

  int expenses = 0;
  int sales = 0;
  int myFarms = 0;
  int feeds = 0;
  int percentage = 0;
  int farmProduction = 0;
  int out = 0;
  int inFeeds = 0;
  int expiring = 0;
  List<Feed> _list = [];


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData();
    });
    super.initState();
  }

  void loadFeeds(){
    ajax(url: "feeds/activities",method: "POST",data: FormData.fromMap({
      "token":User.user?.token,
    }),onValue: (s,v){
      setState(() {
        _list = (s['data'] as Iterable?)?.map((e) => Feed.fromJson(e)).toList() ?? [];
      });
    });
  }

  Future<void> loadData(){
    loadFeeds();
    return ajax(url: "feeds/overview",method: "POST",data: FormData.fromMap({
      "token":User.user?.token,
    }),onValue: (s,v){
      setState(() {
        expiring = s['expiring'];
        percentage = s['percentage'];
        feeds = s['feeds'];
        inFeeds = s['in'];
        out = s['out'];
      });
    });
  }

  final _key = GlobalKey<RefreshIndicatorState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: const Text("Overview",style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),),
        actions: [
          IconButton(onPressed: ()async{
            await push(const StockActivityScreen());
            _key.currentState?.show();
          }, icon: const Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
        key: _key,
        onRefresh: loadData,
        child: ListView(
          padding: const EdgeInsets.all(15).copyWith(top: 0),
          children: [
            Card(
              elevation: 9,
              shadowColor: Colors.black26,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xff86B906)
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,children: [
                          Row(
                            children: [
                              Text(fmtNbr(feeds),style: const TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.w800
                              ),),
                              const Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text("items",style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal
                                ),),
                              ),
                            ],
                          ),
                          const Text("These are in all of your stock(s)",style: TextStyle(
                            color: Color(0xff286242)
                          ),),
                        ],)),
                        Stack(
                          children: const [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: CircularProgressIndicator(
                                value: 0.0,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            Positioned.fill(child: Center(child: Text("35%",style: TextStyle(
                              color: Colors.white,
                              fontSize: 19
                            ),)),)
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 25),
                    child: Row(
                      children: [
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xff3C9343),
                                    width: 4
                                  )
                                )
                              ),
                              child: RichText(text: TextSpan(
                                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                                children: [
                                  TextSpan(text: fmtNbr(inFeeds),style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700
                                  )),
                                  const TextSpan(text: " In",style: TextStyle(
                                    color: Color(0xff3C9343)
                                  )),
                                ]
                              ),),
                            ),
                          ],
                        )),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xff4F76A6),
                                    width: 4
                                  )
                                )
                              ),
                              child: RichText(text: TextSpan(
                                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                                children: [
                                  TextSpan(text: fmtNbr(out),style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700
                                  )),
                                  const TextSpan(text: " Out",style: TextStyle(
                                    color: Color(0xff4F76A6),
                                  )),
                                ]
                              ),),
                            ),
                          ],
                        )),
                        Expanded(child: Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xffBF1919),
                                    width: 4
                                  )
                                )
                              ),
                              child: RichText(text: TextSpan(
                                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                                children: [
                                  TextSpan(text: fmtNbr(expiring),style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700
                                  )),
                                  const TextSpan(text: " Out of Stock",style: TextStyle(
                                    color: Color(0xffBF1919)
                                  )),
                                ]
                              ),),
                            ),
                          ],
                        )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Card(
              elevation: 5,
              shadowColor: Colors.black26,
              margin: const EdgeInsets.all(4).copyWith(top: 20),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text("Recent Activities",style: TextStyle(
                        color: Color(0xffACAFB0),
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                    Column(
                      children: _list.asMap().map((k,e) => MapEntry(k, Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: k == _list.length-1 ? Colors.transparent : Colors.grey.shade300
                                )
                            )
                        ),
                        child: InkWell(
                          onTap: (){
                            showFeedDetails(e, context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(children: [
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e.activityDate??""),
                                  Text(e.name??""),
                                ],
                              )),Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(e.activity??"",style: TextStyle(
                                    fontSize: 14,
                                      color: e.activity == 'In' ? const Color(0xff4F76A6) : const Color(0xffE44747)
                                  ),),
                                  Text(fmtNbr(e.activityQty),style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: e.activity == 'In' ? const Color(0xff4F76A6) : const Color(0xffE44747)
                                  ),),
                                ],
                              )
                            ],),
                          ),
                        ),
                      ))).values.toList(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


Future<void> showFeedDetails(Feed item,BuildContext context){
  return showModalBottomSheet(context: context,shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20)
      )
  ), builder: (context){
    return FeedDetails(feed: item);
  });
}


class FeedDetails extends StatefulWidget{
  final Feed feed;
  const FeedDetails({super.key, required this.feed});

  @override
  State<FeedDetails> createState() => _FeedDetailsState();
}

class _FeedDetailsState extends Superbase<FeedDetails> {

  bool loading = false;

  void deleteTransaction()async{
    setState(() {
      loading = true;
    });
    await ajax(url: "finance/deleteTransaction",method: "POST",data: FormData.fromMap({
      "transaction_id":widget.feed.id,
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
    var item = widget.feed;
    return Container(
      padding: const EdgeInsets.all(20),
      child: loading ? const Center(
        child: CircularProgressIndicator(),
      ) : SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text("Activity details",style: TextStyle(
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
                    const Expanded(child: Text("Feed Name")),
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
                    const Expanded(child: Text("Activity Date")),
                    Text(item.activityDate??""),
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
                    const Expanded(child: Text("Activity")),
                    Text(item.activity??""),
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
                    const Expanded(child: Text("Activity Quantity")),
                    Text(fmtNbr(item.activityQty)),
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
              // SafeArea(
              //   top: false,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       ElevatedButton(onPressed: ()async{
              //         // await push(TransactionRegistration(transaction: item,));
              //         // goBack();
              //       },style: ElevatedButton.styleFrom(
              //           padding: const EdgeInsets.symmetric(
              //               vertical: 11,
              //               horizontal: 35
              //           ),
              //           backgroundColor: const Color(0xffD4F6EB),
              //           foregroundColor: Colors.black87
              //       ), child: const Text("Edit")),
              //       ElevatedButton(onPressed: ()async{
              //         var x = await confirmDialog(context);
              //         if(x == true){
              //           deleteTransaction();
              //         }
              //       },style: ElevatedButton.styleFrom(
              //           padding: const EdgeInsets.symmetric(
              //               vertical: 11,
              //               horizontal: 40
              //           ),
              //           backgroundColor: const Color(0xffFBC1C1),
              //           foregroundColor: Colors.black87
              //       ), child: const Text("Delete")),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}