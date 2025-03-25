import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mresurement/Home.dart';
import 'package:mresurement/add_mesure_user.dart';

import 'Authentications/AuthnticationFunctions.dart';


class GridHomePage extends StatefulWidget {
  @override
  _GridHomePageState createState() => _GridHomePageState();
}

class _GridHomePageState extends State<GridHomePage> {

  User? currentUser;
  String userName = '';
  String userEmail = '';
  String shopName='';
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();
      setState(() {
        userName = userDoc['name'];
        userEmail = userDoc['email'];
        shopName=userDoc['shopname']??'Tailor\'s';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: $userName',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Email: $userEmail',
                      style: TextStyle(fontSize: 16),
                    ),

                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  InkWell(
                    onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => home(),));},
                    child: GridItem(
                      icon: Icons.list,
                      label: 'Customers',
                    ),
                  ),
                  InkWell(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => home(ValueTobeCheckd:true),));},
                    child: GridItem(
                      icon: Icons.favorite_border,
                      label: 'Favorite',
                    ),
                  ),
                  InkWell(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerInfoScreen(),));},
                    child: GridItem(
                      icon: Icons.add,
                      label: 'Add User',
                    ),
                  ),
                  GridItem(
                    icon: Icons.add_card_outlined,
                    label: 'Add Card',
                  ),
                  InkWell(onTap:() async {
                    print("heello");
                    showCupertinoDialog(context: context, builder:(context) => CupertinoAlertDialog(title: Text("Alert For SignOut!\n Are You Sure?",style: TextStyle(fontSize: 18,color: Colors.black),)
                        ,actions: [TextButton(onPressed: ()async{
                          Navigator.pop(context);
                          await FirebaseAuth.instance.signOut();
                          showCustomSnackBar(context, "Your Session is Over", Colors.indigoAccent);

                        }, child: Text('Logout !',style: TextStyle(color: Colors.deepOrange,fontSize: 15),)),TextButton(onPressed: (){Navigator.pop(context);}, child: Text('Stay Login!',style: TextStyle(fontSize: 15,color: Colors.green),))]),);
                  },
                    child: GridItem(
                      icon: Icons.logout,
                      label: 'Logout!',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const GridItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
            ),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
