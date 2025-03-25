// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:mresurement/Home.dart';
// class CustomerInfoScreen extends StatefulWidget {
//   @override
//   _CustomerInfoScreenState createState() => _CustomerInfoScreenState();
// }
//
// class _CustomerInfoScreenState extends State<CustomerInfoScreen> with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _ageController = TextEditingController();
//   final _mobileController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _extrasController = TextEditingController();
//   late AnimationController _animationController;
//   late Animation<Color?> _colorAnimation;
//   late Animation<double> _buttonScaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _colorAnimation = ColorTween(begin: Colors.black, end: Colors.white).animate(_animationController);
//     _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeInOut,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   void _onFieldTap() {
//     _animationController.forward().then((value) => _animationController.reverse());
//   }
//
//   void _onButtonTap() {
//     _animationController.forward().then((value) => _animationController.reverse());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Customer Info'),
//         leading: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Image.asset('assets/logo.png'), // Add your logo here
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: <Widget>[
//               AnimatedBuilder(
//                 animation: _colorAnimation,
//                 builder: (context, child) => TextFormField(
//                   controller: _nameController,
//                   decoration: InputDecoration(labelText: 'Name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your name';
//                     }
//                     return null;
//                   },
//                   onTap: _onFieldTap,
//                   style: TextStyle(color: _colorAnimation.value),
//                 ),
//               ),
//               AnimatedBuilder(
//                 animation: _colorAnimation,
//                 builder: (context, child) => TextFormField(
//                   controller: _ageController,
//                   decoration: InputDecoration(labelText: 'Age'),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your age';
//                     }
//                     return null;
//                   },
//                   onTap: _onFieldTap,
//                   style: TextStyle(color: _colorAnimation.value),
//                 ),
//               ),
//               AnimatedBuilder(
//                 animation: _colorAnimation,
//                 builder: (context, child) => TextFormField(
//                   controller: _mobileController,
//                   decoration: InputDecoration(labelText: 'Mobile Number'),
//                   keyboardType: TextInputType.phone,
//                   validator: (value) {
//                     if (value == null || value.length != 10) {
//                       return 'Please enter a valid 10-digit mobile number';
//                     }
//                     return null;
//                   },
//                   onTap: _onFieldTap,
//                   style: TextStyle(color: _colorAnimation.value),
//                 ),
//               ),
//               AnimatedBuilder(
//                 animation: _colorAnimation,
//                 builder: (context, child) => TextFormField(
//                   controller: _addressController,
//                   decoration: InputDecoration(labelText: 'Address'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your address';
//                     }
//                     return null;
//                   },
//                   onTap: _onFieldTap,
//                   style: TextStyle(color: _colorAnimation.value),
//                 ),
//               ),
//               AnimatedBuilder(
//                 animation: _colorAnimation,
//                 builder: (context, child) => TextFormField(
//                   controller: _extrasController,
//                   decoration: InputDecoration(labelText: 'Extras'),
//                   onTap: _onFieldTap,
//                   style: TextStyle(color: _colorAnimation.value),
//                 ),
//               ),
//               SizedBox(height: 20),
//               AnimatedBuilder(
//                 animation: _buttonScaleAnimation,
//                 builder: (context, child) => Transform.scale(
//                   scale: _buttonScaleAnimation.value,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         _onButtonTap();
//                         Navigator.push(
//                           context,
//                           PageRouteBuilder(
//                             pageBuilder: (context, animation, secondaryAnimation) => ShirtMeasurementScreen(
//                               name: _nameController.text,
//                               age: _ageController.text,
//                               mobile: _mobileController.text,
//                               address: _addressController.text,
//                               extras: _extrasController.text,
//                             ),
//                             transitionsBuilder: (context, animation, secondaryAnimation, child) {
//                               var begin = Offset(1.0, 0.0);
//                               var end = Offset.zero;
//                               var curve = Curves.ease;
//
//                               var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//
//                               return SlideTransition(
//                                 position: animation.drive(tween),
//                                 child: child,
//                               );
//                             },
//                           ),
//                         );
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(18.0),
//                       ),
//                       backgroundColor: Colors.black,
//                     ),
//                     child: Text(
//                       'Next',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ShirtMeasurementScreen extends StatefulWidget {
//   final String name;
//   final String age;
//   final String mobile;
//   final String address;
//   final String extras;
//
//   ShirtMeasurementScreen({
//     required this.name,
//     required this.age,
//     required this.mobile,
//     required this.address,
//     required this.extras,
//   });
//
//   @override
//   _ShirtMeasurementScreenState createState() => _ShirtMeasurementScreenState();
// }
//
// class _ShirtMeasurementScreenState extends State<ShirtMeasurementScreen> with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   final _chestController = TextEditingController();
//   final _waistController = TextEditingController();
//   final _seatController = TextEditingController();
//   final _bicepController = TextEditingController();
//   final _shirtLengthController = TextEditingController();
//   final _shoulderController = TextEditingController();
//   final _sleeveController = TextEditingController();
//   final _cuffController = TextEditingController();
//   final _collarController = TextEditingController();
//   final _extrasController = TextEditingController();
//   late AnimationController _animationController;
//   late Animation<Color?> _colorAnimation;
//   late Animation<double> _buttonScaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _colorAnimation = ColorTween(begin: Colors.black, end: Colors.white).animate(_animationController);
//     _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeInOut,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   void _onFieldTap() {
//     _animationController.forward().then((value) => _animationController.reverse());
//   }
//
//   void _onButtonTap() {
//     _animationController.forward().then((value) => _animationController.reverse());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Shirt Measurements'),
//         leading: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Image.asset('assets/logo.png'), // Add your logo here
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: <Widget>[
//               AnimatedBuilder(
//                 animation: _colorAnimation,
//                 builder: (context, child) => TextFormField(
//                   controller: _chestController,
//                   decoration: InputDecoration(labelText: 'Chest'),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter chest measurement';
//                     }
//                     return null;
//                   },
//                   onTap: _onFieldTap,
//                   style: TextStyle(color: _colorAnimation.value),
//                 ),
//               ),
//               AnimatedBuilder(
//                 animation: _colorAnimation,
//                 builder: (context, child) => TextFormField(
//                   controller: _waistController,
//                   decoration: InputDecoration(labelText: 'Waist'),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter waist measurement';
//                     }
//                     return null;
//                   },
//                   onTap: _onFieldTap,
//                   style: TextStyle(color: _colorAnimation.value),
//                 ),
//               ),
//               // Add the rest of the shirt measurement fields here
//               AnimatedBuilder(
//                 animation: _buttonScaleAnimation,
//                 builder: (context, child) => Transform.scale(
//                   scale: _buttonScaleAnimation.value,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         _onButtonTap();
//                         Navigator.push(
//                           context,
//                           PageRouteBuilder(
//                             pageBuilder: (context, animation, secondaryAnimation) => PantsMeasurementScreen(
//                               name: widget.name,
//                               age: widget.age,
//                               mobile: widget.mobile,
//                               address: widget.address,
//                               extras: widget.extras,
//                               chest: _chestController.text,
//                               waist: _waistController.text,
//                               seat: _seatController.text,
//                               bicep: _bicepController.text,
//                               shirtLength: _shirtLengthController.text,
//                               shoulder: _shoulderController.text,
//                               sleeve: _sleeveController.text,
//                               cuff: _cuffController.text,
//                               collar: _collarController.text,
//                               extrasShirt: _extrasController.text,
//                             ),
//                             transitionsBuilder: (context, animation, secondaryAnimation, child) {
//                               var begin = Offset(1.0, 0.0);
//                               var end = Offset.zero;
//                               var curve = Curves.ease;
//
//                               var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//
//                               return SlideTransition(
//                                 position: animation.drive(tween),
//                                 child: child,
//                               );
//                             },
//                           ),
//                         );
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(18.0),
//                       ),
//                       backgroundColor: Colors.black,
//                     ),
//                     child: Text(
//                       'Next',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class PantsMeasurementScreen extends StatefulWidget {
//   final String name;
//   final String age;
//   final String mobile;
//   final String address;
//   final String extras;
//   final String chest;
//   final String waist;
//   final String seat;
//   final String bicep;
//   final String shirtLength;
//   final String shoulder;
//   final String sleeve;
//   final String cuff;
//   final String collar;
//   final String extrasShirt;
//
//   PantsMeasurementScreen({
//     required this.name,
//     required this.age,
//     required this.mobile,
//     required this.address,
//     required this.extras,
//     required this.chest,
//     required this.waist,
//     required this.seat,
//     required this.bicep,
//     required this.shirtLength,
//     required this.shoulder,
//     required this.sleeve,
//     required this.cuff,
//     required this.collar,
//     required this.extrasShirt,
//   });
//
//   @override
//   _PantsMeasurementScreenState createState() => _PantsMeasurementScreenState();
// }
//
// class _PantsMeasurementScreenState extends State<PantsMeasurementScreen> with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   final _waistController = TextEditingController();
//   final _hipController = TextEditingController();
//   final _inseamController = TextEditingController();
//   final _thighController = TextEditingController();
//   final _kneeController = TextEditingController();
//   final _pantLengthController = TextEditingController();
//   final _riseController = TextEditingController();
//   final _extrasController = TextEditingController();
//   bool _isLoading = false;
//   late AnimationController _animationController;
//   late Animation<Color?> _colorAnimation;
//   late Animation<double> _buttonScaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _colorAnimation = ColorTween(begin: Colors.black, end: Colors.white).animate(_animationController);
//     _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeInOut,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   void _onFieldTap() {
//     _animationController.forward().then((value) => _animationController.reverse());
//   }
//
//   void _onButtonTap() {
//     _animationController.forward().then((value) => _animationController.reverse());
//   }
//
//   void _saveData() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       await FirebaseFirestore.instance.collection('measurements').add({
//         'uid': user?.uid,
//         'name': widget.name,
//         'age': widget.age,
//         'mobile': widget.mobile,
//         'address': widget.address,
//         'extras': widget.extras,
//         'shirt_measurements': {
//           'chest': widget.chest,
//           'waist': widget.waist,
//           'seat': widget.seat,
//           'bicep': widget.bicep,
//           'shirtLength': widget.shirtLength,
//           'shoulder': widget.shoulder,
//           'sleeve': widget.sleeve,
//           'cuff': widget.cuff,
//           'collar': widget.collar,
//           'extras': widget.extrasShirt,
//         },
//         'pant_measurements': {
//           'waist': _waistController.text,
//           'hip': _hipController.text,
//           'inseam': _inseamController.text,
//           'thigh': _thighController.text,
//           'knee': _kneeController.text,
//           'pantLength': _pantLengthController.text,
//           'rise': _riseController.text,
//           'extras': _extrasController.text,
//         },
//       });
//
//       setState(() {
//         _isLoading = false;
//       });
//
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => home(),));
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       print('Error saving data: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pants Measurements'),
//         leading: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Image.asset('assets/logo.png'), // Add your logo here
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Stack(
//             children: [
//               ListView(
//                 children: <Widget>[
//                   AnimatedBuilder(
//                     animation: _colorAnimation,
//                     builder: (context, child) => TextFormField(
//                       controller: _waistController,
//                       decoration: InputDecoration(labelText: 'Waist'),
//                       keyboardType: TextInputType.number,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter waist measurement';
//                         }
//                         return null;
//                       },
//                       onTap: _onFieldTap,
//                       style: TextStyle(color: _colorAnimation.value),
//                     ),
//                   ),
//                   AnimatedBuilder(
//                     animation: _colorAnimation,
//                     builder: (context, child) => TextFormField(
//                       controller: _hipController,
//                       decoration: InputDecoration(labelText: 'Hip'),
//                       keyboardType: TextInputType.number,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter hip measurement';
//                         }
//                         return null;
//                       },
//                       onTap: _onFieldTap,
//                       style: TextStyle(color: _colorAnimation.value),
//                     ),
//                   ),
//                   AnimatedBuilder(
//                     animation: _colorAnimation,
//                     builder: (context, child) => TextFormField(
//                       controller: _inseamController,
//                       decoration: InputDecoration(labelText: 'Inseam'),
//                       keyboardType: TextInputType.number,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter inseam measurement';
//                         }
//                         return null;
//                       },
//                       onTap: _onFieldTap,
//                       style: TextStyle(color: _colorAnimation.value),
//                     ),
//                   ),
//                   // Add the rest of the pants measurement fields here
//                   AnimatedBuilder(
//                     animation: _buttonScaleAnimation,
//                     builder: (context, child) => Transform.scale(
//                       scale: _buttonScaleAnimation.value,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           if (_formKey.currentState!.validate()) {
//                             _onButtonTap();
//                             _saveData();
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(18.0),
//                           ),
//                           backgroundColor: Colors.black,
//                         ),
//                         child: _isLoading
//                             ? CircularProgressIndicator(
//                           color: Colors.white,
//                         )
//                             : Text(
//                           'Save & Finish',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mresurement/GridHomePage.dart';
import 'package:mresurement/Home.dart';

import 'ClientDetailPage.dart';

class CustomerInfoScreen extends StatefulWidget {
  final DocumentId;
  const CustomerInfoScreen({super.key, this.DocumentId});

  @override
  _CustomerInfoScreenState createState() => _CustomerInfoScreenState();
}

class _CustomerInfoScreenState extends State<CustomerInfoScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _extrasController = TextEditingController();
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _buttonScaleAnimation;
  late String _documentId;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _colorAnimation = ColorTween(begin: Colors.black, end: Colors.white).animate(_animationController);
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _documentId = widget.DocumentId ?? '';

    if (_documentId.isNotEmpty) {
      _loadCustomerData();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomerData() async {
    final doc = FirebaseFirestore.instance.collection('measurements').doc(_documentId);
    final snapshot = await doc.get();

    if (snapshot.exists) {
      final data = snapshot.data()!;
      _nameController.text = data['name'] ?? '';
      _ageController.text = data['age'] ?? '';
      _mobileController.text = data['mobile'] ?? '';
      _addressController.text = data['address'] ?? '';
      _extrasController.text = data['extras'] ?? '';
    }
  }

  Future<void> _saveCustomerData() async {
    final data = {
      'name': _nameController.text,
      'age': _ageController.text,
      'mobile': _mobileController.text,
      'address': _addressController.text,
      'extras': _extrasController.text,
    };

    if (_documentId.isEmpty) {
      final docRef = FirebaseFirestore.instance.collection('measurements').doc();
      _documentId = docRef.id;
      await docRef.set(data);
    } else {
      await FirebaseFirestore.instance.collection('measurements').doc(_documentId).update(data);
    }
  }

  void _onFieldTap() {
    _animationController.forward().then((value) => _animationController.reverse());
  }

  void _onButtonTap() {
    _animationController.forward().then((value) => _animationController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Info'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/logo.png'), // Add your logo here
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) => TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    if (value.length < 2) {
                      return 'Enter Valid Name!';
                    }
                    return null;
                  },
                  onTap: _onFieldTap,
                  style: TextStyle(color: _colorAnimation.value),
                ),
              ),
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) => TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    if (value.contains('-')) {
                      return 'Enter A valid Age';
                    }
                    return null;
                  },
                  onTap: _onFieldTap,
                  style: TextStyle(color: _colorAnimation.value),
                ),
              ),
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) => TextFormField(
                  controller: _mobileController,
                  decoration: InputDecoration(labelText: 'Mobile Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.length != 10) {
                      return 'Please enter a valid 10-digit mobile number';
                    }
                    return null;
                  },
                  onTap: _onFieldTap,
                  style: TextStyle(color: _colorAnimation.value),
                ),
              ),
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) => TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                  onTap: _onFieldTap,
                  style: TextStyle(color: _colorAnimation.value),
                ),
              ),
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) => TextFormField(
                  controller: _extrasController,
                  decoration: InputDecoration(labelText: 'Extras'),
                  onTap: _onFieldTap,
                  style: TextStyle(color: _colorAnimation.value),
                ),
              ),
              SizedBox(height: 20),
              AnimatedBuilder(
                animation: _buttonScaleAnimation,
                builder: (context, child) => Transform.scale(
                  scale: _buttonScaleAnimation.value,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _saveCustomerData();
                        _onButtonTap();
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => ShirtMeasurementScreen(
                              name: _nameController.text,
                              age: _ageController.text,
                              mobile: _mobileController.text,
                              address: _addressController.text,
                              extras: _extrasController.text,
                              documentId: _documentId, // Pass documentId to the next screen
                            ),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              var begin = Offset(1.0, 0.0);
                              var end = Offset.zero;
                              var curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      backgroundColor: Colors.black,
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShirtMeasurementScreen extends StatefulWidget {
  final String name;
  final String age;
  final String mobile;
  final String address;
  final String extras;
  final String? documentId;

  ShirtMeasurementScreen({
    required this.name,
    required this.age,
    required this.mobile,
    required this.address,
    required this.extras,  this.documentId,
  });

  @override
  _ShirtMeasurementScreenState createState() => _ShirtMeasurementScreenState();
}

class _ShirtMeasurementScreenState extends State<ShirtMeasurementScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _chestController = TextEditingController();
  final _waistController = TextEditingController();
  final _seatController = TextEditingController();
  final _bicepController = TextEditingController();
  final _shirtLengthController = TextEditingController();
  final _shoulderController = TextEditingController();
  final _sleeveController = TextEditingController();
  final _cuffController = TextEditingController();
  final _collarController = TextEditingController();
  final _extrasController = TextEditingController();
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _colorAnimation = ColorTween(begin: Colors.black, end: Colors.white).animate(_animationController);
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    if (widget.documentId != null) {
      _loadData();
    }

  }

  Future<void> _loadData() async {
    print("asdfghjkasdfghjdfghj=======================================================");
    final doc = await FirebaseFirestore.instance.collection('measurements').doc(widget.documentId).get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        _chestController.text = data['shirt_measurements']['chest'] ?? '';
        _waistController.text = data['shirt_measurements']['waist'] ?? '';
        _seatController.text = data['shirt_measurements']['seat'] ?? '';
        _bicepController.text = data['shirt_measurements']['bicep'] ?? '';
        _shirtLengthController.text = data['shirt_measurements']['shirtLength'] ?? '';
        _shoulderController.text = data['shirt_measurements']['shoulder'] ?? '';
        _sleeveController.text = data['shirt_measurements']['sleeve'] ?? '';
        _cuffController.text = data['shirt_measurements']['cuff'] ?? '';
        _collarController.text = data['shirt_measurements']['collar'] ?? '';
        _extrasController.text = data['shirt_measurements']['shirtExtras'] ?? '';
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onFieldTap() {
    _animationController.forward().then((value) => _animationController.reverse());
  }

  void _onButtonTap() {
    _animationController.forward().then((value) => _animationController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shirt Measurements'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/logo.png'), // Add your logo here
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) => TextFormField(
                  controller: _chestController,
                  decoration: InputDecoration(labelText: 'Chest'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter chest measurement';
                    }
                    return null;
                  },
                  onTap: _onFieldTap,
                  style: TextStyle(color: _colorAnimation.value),
                ),
              ),
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) => TextFormField(
                  controller: _waistController,
                  decoration: InputDecoration(labelText: 'Waist'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter waist measurement';
                    }
                    return null;
                  },
                  onTap: _onFieldTap,
                  style: TextStyle(color: _colorAnimation.value),
                ),
              ),
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) => TextFormField(
                  controller: _seatController,
                  decoration: InputDecoration(labelText: 'Seat'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter seat measurement';
                    }
                    return null;
                  },
                  onTap: _onFieldTap,
                  style: TextStyle(color: _colorAnimation.value),
                ),
              ),
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) => TextFormField(
                  controller: _bicepController,
                  decoration: InputDecoration(labelText: 'Bicep'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter bicep measurement';
                    }
                    return null;
                  },
                  onTap: _onFieldTap,
                  style: TextStyle(color: _colorAnimation.value),
                ),
              ),
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) => TextFormField(
                  controller: _shirtLengthController,
                  decoration: InputDecoration(labelText: 'Shirt Length'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter shirt length measurement';
                    }
                    return null;
                  },
                  onTap: _onFieldTap,
                  style: TextStyle(color: _colorAnimation.value),
                ),
              ),
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) => TextFormField(
                  controller: _shoulderController,
                  decoration: InputDecoration(labelText: 'Shoulder'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter shoulder measurement';
                    }
                    return null;
                  },
                  onTap: _onFieldTap,
                  style: TextStyle(color: _colorAnimation.value),
                ),
              ),
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) => TextFormField(
                  controller: _sleeveController,
                  decoration: InputDecoration(labelText: 'Sleeve Length'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter sleeve length measurement';
                    }
                    return null;
                  },
                  onTap: _onFieldTap,
                  style: TextStyle(color: _colorAnimation.value),
                ),
              ),
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) => TextFormField(
                  controller: _cuffController,
                  decoration: InputDecoration(labelText: 'Cuff'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter cuff measurement';
                    }
                    return null;
                  },
                  onTap: _onFieldTap,
                  style: TextStyle(color: _colorAnimation.value),
                ),
              ),
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) => TextFormField(
                  controller: _collarController,
                  decoration: InputDecoration(labelText: 'Collar'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter collar measurement';
                    }
                    return null;
                  },
                  onTap: _onFieldTap,
                  style: TextStyle(color: _colorAnimation.value),
                ),
              ),
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) => TextFormField(
                  controller: _extrasController,
                  decoration: InputDecoration(labelText: 'Shirt Extras'),

                  validator: (value) {
                  },
                  onTap: _onFieldTap,
                  style: TextStyle(color: _colorAnimation.value),
                ),
              ),
              SizedBox(height: 20),
              AnimatedBuilder(
                animation: _buttonScaleAnimation,
                builder: (context, child) => Transform.scale(
                  scale: _buttonScaleAnimation.value,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _onButtonTap();
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => PantMeasurementScreen(
                              name: widget.name,
                              age: widget.age,
                              mobile: widget.mobile,
                              address: widget.address,
                              extras: widget.extras,
                              chest: _chestController.text,
                              waist: _waistController.text,
                              seat: _seatController.text,
                              bicep: _bicepController.text,
                              shirtLength: _shirtLengthController.text,
                              shoulder: _shoulderController.text,
                              sleeve: _sleeveController.text,
                              cuff: _cuffController.text,
                              collar: _collarController.text,
                              shirtExtras: _extrasController.text,
                              documentId:widget.documentId
                            ),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              var begin = Offset(1.0, 0.0);
                              var end = Offset.zero;
                              var curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      backgroundColor: Colors.black,
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class PantMeasurementScreen extends StatefulWidget {
  final String name;
  final String age;
  final String mobile;
  final String address;
  final String extras;
  final String chest;
  final String waist;
  final String seat;
  final String bicep;
  final String shirtLength;
  final String shoulder;
  final String sleeve;
  final String cuff;
  final String collar;
  final String shirtExtras;
  final String? documentId;
  PantMeasurementScreen({
    required this.name,
    required this.age,
    required this.mobile,
    required this.address,
    required this.extras,
    required this.chest,
    required this.waist,
    required this.seat,
    required this.bicep,
    required this.shirtLength,
    required this.shoulder,
    required this.sleeve,
    required this.cuff,
    required this.collar,
    required this.shirtExtras, this.documentId,
  });

  @override
  _PantMeasurementScreenState createState() => _PantMeasurementScreenState();
}

class _PantMeasurementScreenState extends State<PantMeasurementScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _waistController = TextEditingController();
  final _hipController = TextEditingController();
  final _inseamController = TextEditingController();
  final _thighController = TextEditingController();
  final _kneeController = TextEditingController();
  final _pantLengthController = TextEditingController();
  final _riseController = TextEditingController();
  final _extrasController = TextEditingController();
  bool _isLoading = false;
  var isFav=0;
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _colorAnimation = ColorTween(begin: Colors.black, end: Colors.white).animate(_animationController);
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    if (widget.documentId != null) {
      _loadData();
    }
  }
  Future<void> _loadData() async {
    final doc = await FirebaseFirestore.instance.collection('measurements').doc(widget.documentId).get();

    if (doc.exists) {
      final data = doc.data()!;
      isFav=data['isFavorite'];
      setState(() {
        _waistController.text = data['pant_measurements']['waist'] ?? '';
        _hipController.text = data['pant_measurements']['hip'] ?? '';
        _inseamController.text = data['pant_measurements']['inseam'] ?? '';
        _thighController.text = data['pant_measurements']['thigh'] ?? '';
        _kneeController.text = data['pant_measurements']['knee'] ?? '';
        _pantLengthController.text = data['pant_measurements']['pantLength'] ?? '';
        _riseController.text = data['pant_measurements']['rise'] ?? '';
        _extrasController.text = data['pant_measurements']['extras'] ?? '';
      });
    }
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onFieldTap() {
    _animationController.forward().then((value) => _animationController.reverse());
  }

  void _onButtonTap() {
    _animationController.forward().then((value) => _animationController.reverse());
  }

  void _saveData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;final data = {
        'uid': user?.uid,
        'name': widget.name,
        'age': widget.age,
        'mobile': widget.mobile,
        'address': widget.address,
        'extras': widget.extras,
        'isFavorite':isFav,
        'shirt_measurements': {
          'chest': widget.chest,
          'waist': widget.waist,
          'seat': widget.seat,
          'bicep': widget.bicep,
          'shirtLength': widget.shirtLength,
          'shoulder': widget.shoulder,
          'sleeve': widget.sleeve,
          'cuff': widget.cuff,
          'collar': widget.collar,
          'extras': widget.shirtExtras,
        },
        'pant_measurements': {
          'waist': _waistController.text,
          'hip': _hipController.text,
          'inseam': _inseamController.text,
          'thigh': _thighController.text,
          'knee': _kneeController.text,
          'pantLength': _pantLengthController.text,
          'rise': _riseController.text,
          'extras': _extrasController.text,
        },
      };

      if (widget.documentId != null) {
        await FirebaseFirestore.instance.collection('measurements').doc(widget.documentId).update(data);
      } else {
        await FirebaseFirestore.instance.collection('measurements').add(data);
      }

      setState(() {
        _isLoading = false;
      });


      if (widget.documentId != null) {
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => home()),
              (route) => route.isFirst,
        );


      } else {
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => home()),
              (route) => route.isFirst,
        );
      }
      } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error saving data: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pant Measurements'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/logo.png'), // Add your logo here
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) => TextFormField(
                  controller: _riseController,
                  decoration: InputDecoration(labelText: 'Rise'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter rise measurement';
                    }
                    return null;
                  },
                  onTap: _onFieldTap,
                  style: TextStyle(color: _colorAnimation.value),
                ),
              ),
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) => TextFormField(
                  controller: _thighController,
                  decoration: InputDecoration(labelText: 'Thighs'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter thigh measurement';
                    }
                    return null;
                  },
                  onTap: _onFieldTap,
                  style: TextStyle(color: _colorAnimation.value),
                ),
              ),
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) => TextFormField(
                  controller: _hipController,
                  decoration: InputDecoration(labelText: 'Hips'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter hips measurement';
                    }
                    return null;
                  },
                  onTap: _onFieldTap,
                  style: TextStyle(color: _colorAnimation.value),
                ),
              ),
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) => TextFormField(
                  controller: _pantLengthController,
                  decoration: InputDecoration(labelText: 'Pant Length'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter pant length measurement';
                    }
                    return null;
                  },
                  onTap: _onFieldTap,
                  style: TextStyle(color: _colorAnimation.value),
                ),
              ),
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) => TextFormField(
                  controller: _waistController,
                  decoration: InputDecoration(labelText: 'Waist'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter waist measurement';
                    }
                    return null;
                  },
                  onTap: _onFieldTap,
                  style: TextStyle(color: _colorAnimation.value),
                ),
              ),
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) => TextFormField(
                  controller: _inseamController,
                  decoration: InputDecoration(labelText: 'Inseam'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter inseam measurement';
                    }
                    return null;
                  },
                  onTap: _onFieldTap,
                  style: TextStyle(color: _colorAnimation.value),
                ),
              ),
              AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) => TextFormField(
                  controller: _kneeController,
                  decoration: InputDecoration(labelText: 'Knee'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter knee measurement';
                    }
                    return null;
                  },
                  onTap: _onFieldTap,
                  style: TextStyle(color: _colorAnimation.value),
                ),
              ),
              TextFormField(
                controller: _extrasController,
                decoration: InputDecoration(labelText: 'Extra Instructions'),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20),
          AnimatedBuilder(
                    animation: _buttonScaleAnimation,
                    builder: (context, child) => Transform.scale(
                      scale: _buttonScaleAnimation.value,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _onButtonTap();
                            _saveData();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          backgroundColor: Colors.black,
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : Text('Save & Finish',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}





