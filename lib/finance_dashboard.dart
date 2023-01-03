import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orora2/transaction_registration.dart';

class FinanceDashboard extends StatefulWidget{
  const FinanceDashboard({super.key});

  @override
  State<FinanceDashboard> createState() => _FinanceDashboardState();
}

class _FinanceDashboardState extends State<FinanceDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(padding: EdgeInsets.zero,itemBuilder: (context,index){
        if(index == 0){
          return Stack(
            children: [
              Container(
                height: 260,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor
                ),
                height: 200,
              ),
              Positioned.fill(child: Padding(
                padding: const EdgeInsets.all(15.0).copyWith(top: MediaQuery.of(context).padding.top),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Balance",style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white
                                ),),
                                Text("395,000 RWF",style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white
                                ),),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.black45,
                              shape: BoxShape.circle
                          ),
                          height: 40,
                          child: IconButton(onPressed: (){
                            Navigator.push(context, CupertinoPageRoute(builder: (context)=>const TransactionRegistration()));
                          }, icon: const Icon(Icons.add,size: 40,),padding: EdgeInsets.zero,color: Colors.white,),
                        )
                      ],
                    ),
                    Card(
                      margin: EdgeInsets.zero.copyWith(top: 20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 35),
                        child: Row(
                          children: [
                            Expanded(child: Row(
                              children: [
                                Image.asset("assets/expenses.png"),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text("283,520 RWF",style: TextStyle(
                                            color: Color(0xffD80404),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700
                                        ),),
                                        Text("Expenses")
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )),
                            Expanded(child: Row(
                              children: [
                                Image.asset("assets/sales.png"),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text("625,500 RWF",style: TextStyle(
                                            color: Color(0xffD80404),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700
                                        ),),
                                        Text("Sales")
                                      ],
                                    ),
                                  ),
                                )
                              ],
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

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: const [
                        TextSpan(text: "Feeds",style: TextStyle(color: Colors.red),),
                        TextSpan(text: ". 18 Dec 2022",),
                      ]
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         const Text("Kugura Ubwatsi",style: TextStyle(fontSize: 18),),
                        Text(". 200,200 RWF",style: TextStyle(
                          color: index % 2 == 0 ? Colors.red : Theme.of(context).primaryColor
                        ),)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}