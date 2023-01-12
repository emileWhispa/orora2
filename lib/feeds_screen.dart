import 'package:flutter/material.dart';
import 'package:orora2/feeds_registration.dart';
import 'package:orora2/stock_activity_screen.dart';
import 'package:orora2/super_base.dart';

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
  int farmProduction = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Overview"),
        actions: [
          IconButton(onPressed: (){
            push(const StockActivityScreen());
          }, icon: const Icon(Icons.add))
        ],
      ),
      body: ListView(
        children: [
          Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            elevation: 2,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xff86B906)
                  ),
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,children: [
                        Row(
                          children: const [
                            Text("1,259",style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w800
                            ),),
                            Padding(
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
                  padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 40),
                  child: Row(
                    children: [
                      Expanded(child: Column(
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
                              children: const [
                                TextSpan(text: "130",style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700
                                )),
                                TextSpan(text: " In",style: TextStyle(
                                  color: Color(0xff3C9343)
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
                                  color: Color(0xff4F76A6),
                                  width: 4
                                )
                              )
                            ),
                            child: RichText(text: TextSpan(
                              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                              children: const [
                                TextSpan(text: "93",style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700
                                )),
                                TextSpan(text: " In",style: TextStyle(
                                  color: Color(0xff4F76A6)
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
                              children: const [
                                TextSpan(text: "5",style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700
                                )),
                                TextSpan(text: " Expiring",style: TextStyle(
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              children: [
                Expanded(child: SizedBox(
                  height: 200,
                  child: Card(clipBehavior: Clip.antiAliasWithSaveLayer,shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),child: InkWell(
                    onTap: (){
                      push(const FeedsRegistration());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("My Farms",style: TextStyle(
                              fontSize: 14
                          ),textAlign: TextAlign.center,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(fmtNbr(myFarms),maxLines: 1,overflow: TextOverflow.ellipsis,style: const TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w700
                            ),),
                          ),
                          Image.asset("assets/goat.png")
                        ],
                      ),
                    ),
                  ),),
                )),
                Expanded(child: SizedBox(
                  height: 200,
                  child: Card(shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),child: InkWell(
                    onTap: (){

                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Feeds",style: TextStyle(
                              fontSize: 14
                          ),textAlign: TextAlign.center,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(fmtNbr(feeds),maxLines: 1,overflow: TextOverflow.ellipsis,style: const TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w700
                            ),),
                          ),
                          Image.asset("assets/cow.png")
                        ],
                      ),
                    ),
                  ),),
                )),
                Expanded(child: SizedBox(
                  height: 200,
                  child: Card(shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),child: InkWell(
                    onTap: (){
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Farm Production",style: TextStyle(
                              fontSize: 14
                          ),textAlign: TextAlign.center,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(fmtNbr(farmProduction),maxLines: 1,overflow: TextOverflow.ellipsis,style: const TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w700
                            ),),
                          ),
                          Image.asset("assets/cow.png")
                        ],
                      ),
                    ),
                  ),),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}