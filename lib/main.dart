import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mresurement/GridHomePage.dart';
import 'package:mresurement/Home.dart';
import 'package:mresurement/LoginPage.dart';


import 'package:mresurement/Authentications/AuthnticationFunctions.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(apiKey: "AIzaSyCpaPF4bqR0r6gCT0I0PX040EEP22sYfOg",
        appId: "1:291550105668:android:5fb7cb601196f0cdadec11",
        messagingSenderId: "291550105668",
        projectId: "mapbook-a25b4")
  );

  runApp(
      MaterialApp(
       debugShowCheckedModeBanner: false,
        routes: {'/home':(context)=>home()},
      home: StreamBuilder(stream:FirebaseAuth.instance.authStateChanges()
          , builder: (context,snapshot){
              if(snapshot.hasData) {

                return GridHomePage();
              }
              else{
                return LoginPage();
              }
            return Center(child: CircularProgressIndicator(),);
          }
      ),
    )
  );
}

