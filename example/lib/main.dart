// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nearpay_flutter_sdk/nearpay.dart';




void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final nearpayPlugin = Nearpay();
  final tokenKey = "test+youremail@gmail.com";
  final authType = AuthenticationType.email.value;
  final timeout = 60;
  
  @override
  void initState() {
    super.initState();
    sdkInitialize();
  }

  sdkInitialize()  {
    var reqData = {
      "authtype" : authType,
      "authvalue" : tokenKey,
      "locale" : Locale.localeDefault.value,
      "environment" : Environments.sandbox.value
      };
    print("...sdk Initialize...-5555-----$reqData.");
    var jsonResponse = nearpayPlugin.initialize(reqData) ;
    print("...sdk Initialize...------$jsonResponse.");
    
  }

  purchaseWithRefund() async {
    var reqData = {
      "amount": 0001, 
      "customer_reference_number": "", // Any string as a reference number
      "isEnableUI" : true,
      "isEnableReversal" : true, //it will allow you to enable or disable the reverse button
      "authtype" : authType, 
      "authvalue" : tokenKey, //Only for JWT token
      "finishTimeout" : timeout
    };
    var jsonResponse = await nearpayPlugin.purchase(reqData);
    var jsonData = json.decode(jsonResponse);
    print("...paymentresponse...------$jsonData.");
    var status = jsonData['status'];
    var message = jsonData['message'];
    if(status == 200){

        List<dynamic> purchaseList = jsonData["list"];
        print("...paymentresponse...------$jsonData.");
        Future.delayed(const Duration(milliseconds: 5000), () {
        // Your code
          print("...response list...------$purchaseList.");
          if(purchaseList.isNotEmpty){
            String uuid = purchaseList[0]['uuid'];
            print("...response list...udid------$uuid.");
            refundAction(uuid);
          }
          
        });
    }else if(status == 401){
      showToast(message, true);

    }
    else{
      showToast(message, true);

    }
    
  }

  purchaseWithReverse() async {
    var reqData = {
      "amount": 0001, 
      "customer_reference_number": "uuyuyuyuy65565675",
      "isEnableUI" : true,
      "isEnableReversal" : true, //it will allow you to enable or disable the reverse button
      "authtype" : authType, 
      "authvalue" : tokenKey, 
      "finishTimeout" : timeout
    };
    var jsonResponse = await nearpayPlugin.purchase(reqData);
    var jsonData = json.decode(jsonResponse);
    print("...paymentresponse...------$jsonData.");
    var status = jsonData['status'];
    var message = jsonData['message'];
    if(status == 200){
      List<dynamic> purchaseList = jsonData["list"];
      print("...paymentresponse...------$jsonData.");
      Future.delayed(const Duration(milliseconds: 5000), () {
      // Your code
        print("...response list...------$purchaseList.");
        if(purchaseList.isNotEmpty){
          String uuid = purchaseList[0]['uuid'];
          print("...response list...uuid------$uuid.");
          reverseAction(uuid);
        }
        
      });
    }else if(status == 401){
      showToast(message, true);

    }
    else{
      showToast(message, true);

    }

    
  }


  purchaseAction() async {
    var reqData = {
      "amount": 0001, 
      "customer_reference_number": "uuyuyuyuy65565675",
      "isEnableUI" : true,
      "isEnableReversal" : true, //it will allow you to enable or disable the reverse button
      "authtype" : authType, 
      "authvalue" : tokenKey,
      "finishTimeout" : timeout     
    };
    var jsonResponse = await nearpayPlugin.purchase(reqData);
    print("...purchaseAction...------$jsonResponse.");
    
  }

  refundAction(String uuid) async {
    var reqData = {
      "amount": 0001, 
      "transaction_uuid" :uuid,
      "customer_reference_number": "rerretest123333333",
      "isEnableUI" : true,
      "isEnableReversal" : true,
      "isEditableReversalUI" : true,
      "authtype" : authType, 
      "authvalue" : tokenKey,
      "finishTimeout" : timeout

    };
    var jsonResponse = await nearpayPlugin.refund(reqData) ;
    print("...refund response...------$jsonResponse.");
    
  }

  reconcileAction() async {
    var reqData = {
      "isEnableUI" : true,
      "authtype" : authType, 
      "authvalue" : tokenKey,
      "finishTimeout" : timeout    
    };
    var jsonResponse = await nearpayPlugin.reconcile(reqData) ;
    print("...reconcileAction response...------$jsonResponse.");
    
  }

  reverseAction(String uuid) async {
    var reqData = {
      "transaction_uuid" :uuid,
      "isEnableUI" : true,
      "authtype" : authType, 
      "authvalue" : tokenKey,
      "finishTimeout" : timeout   
    };
    var jsonResponse = await nearpayPlugin.reverse(reqData) ;
    print("...reverseAction response...------$jsonResponse.");
    
  }

  logoutAction() async {
    var jsonResponse = await nearpayPlugin.logout() ;
    print("...logoutAction response...------$jsonResponse.");
    
  }

  setupAction(String tokenKey) async {
      var reqData = {
        "authtype" : authType, 
        "authvalue" : tokenKey,
      };
    var jsonResponse = await nearpayPlugin.setup(reqData) ;
    print("...setupAction response...------$jsonResponse.");
  }

  showToast(String message, bool isError){
    print("..$isError....showtoast.....4.....$message....");
    Fluttertoast.showToast(
        msg:message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor:Colors.red ,
        textColor:  Colors.black,
        fontSize: 16.0
    );
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Nearpay Example'),
        ),
        body: Column(children: [
          TextButton(
            onPressed: () async {
              // Respond to button press
              purchaseAction();
            },
            child: const Text("Purchase"),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () async {
              // Respond to button press
              purchaseWithRefund();
            },
            child: const Text("Purchase and Refund"),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () async {
              // Respond to button press
              purchaseWithReverse();
            },
            child: const Text("Purchase and Reverse"),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () async {
              // Respond to button press
              reconcileAction();
            },
            child: const Text("RECONCILE"),
          ),
          const SizedBox(
            height: 20,
          ),
          /*TextButton(
            onPressed: () async {
              // Respond to button press
              reverseAction();
            },
            child: const Text("REVERSE"),
          ),
          const SizedBox(
            height: 20,
          ),*/
          TextButton(
            onPressed: () async {
              // Respond to button press
              setupAction(tokenKey);
            },
            child: const Text("Setup"),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () async {
              // Respond to button press
              logoutAction();
            },
            child: const Text("Logout"),
          )
        ]),
      ),
    );
  }
}


