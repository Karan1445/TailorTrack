import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mresurement/Authentications/AuthnticationFunctions.dart';

class GetHomedata{
  Future<void> GetDataHome()async{
    FirebaseFirestore FIrebase_Firestore= FirebaseFirestore.instance;
    CollectionReference Collections=FIrebase_Firestore.collection("measurements");
    try{
      QuerySnapshot querySnapshot=await Collections.get();
      print(querySnapshot);
    } catch (e) {
      print("Error retrieving collection data: $e");
    }

  }
}