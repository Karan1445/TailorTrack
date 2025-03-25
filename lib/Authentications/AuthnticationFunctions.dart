import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mresurement/Home.dart';

class FirebaseAuthentication {
  static signupUser(
      String email, String password, String name, String MobileNo,String ShopName,BuildContext context) async {
    try {


      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirestoreServices.saveUser(name, email, MobileNo,ShopName,userCredential.user!.uid);
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      showCustomSnackBar(context, "Check Email To Verified", Colors.indigo);
      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      await FirebaseAuth.instance.currentUser!.updateEmail(email);

      showCustomSnackBar(context, "You Are Logged in!!",Colors.red);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
     showCustomSnackBar(context, "Password Provided is too weak",Colors.red) ;
      } else if (e.code == 'email-already-in-use') {
       showCustomSnackBar(context, 'Email Provided already Exists',Colors.red);
      }
    } catch (e) {
      showCustomSnackBar(context,e.toString(),Colors.red);
    }
  }

  static signinUser(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

    showCustomSnackBar(context, "You Are LoggedIn",Colors.blueAccent);
    } on FirebaseAuthException catch (e) {
      print("==============================================================="+e.code);
      if (e.code == 'user-not-found' ) {
        showCustomSnackBar(context, "user Found with this Email",Colors.red);
      } else if (e.code == 'wrong-password') {
     showCustomSnackBar(context, "Password did not match",Colors.red);
      }else if (e.code == 'invalid-credential') {
        showCustomSnackBar(context, "Password did not match",Colors.red);
      }else{
        showCustomSnackBar(context,"${e.code} Check Out This Problem!",Colors.orange.shade700);
      }
    }
  }
}



void showCustomSnackBar(BuildContext context,msg,Color clr,[int? dre]) {
  final snackBar = SnackBar(duration: Duration(milliseconds: dre??500),

    content: Text(
      msg,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: clr??Colors.deepPurpleAccent,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),

  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
class FirestoreServices {
  static saveUser(String name, email, MobileNo,ShopName,uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({'email': email, 'name': name,'mobileno':MobileNo,'shopname':ShopName,'joindate':DateTime.now()});
  }
}
Future<void> sendEmailVerification(User? user) async {
  if (user != null && !user.emailVerified) {
    await user.sendEmailVerification();
    print('Verification email sent');
  }
}
Future<bool> isEmailVerified(User? user) async {
  if (user != null) {
    await user.reload();
    return user.emailVerified;
  }
  return false;
}
