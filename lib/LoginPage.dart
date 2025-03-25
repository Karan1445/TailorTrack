import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mresurement/Authentications/AuthnticationFunctions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  TextEditingController restemail=TextEditingController();
  String email = '';
  String MobileNo='';
  String resetEmail='';
  String password = '';
  String fullname = '';
  String ShopName='';
  bool login = true; // Default to login mode
  bool showForgotPassword = false; // Toggle for forgot password view

  late AnimationController _controller;
  late Animation<double> _formAnimation;
  late Animation<Color?> _backgroundColorAnimation;
  late Animation<Color?> _buttonColorAnimation;
  late Animation<Color?> _textColorAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _formAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 1.0, curve: Curves.easeInOut),
      ),
    );

    _backgroundColorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.grey[100],
    ).animate(_controller);

    _buttonColorAnimation = ColorTween(
      begin: Colors.black,
      end: Colors.blueGrey,
    ).animate(_controller);

    _textColorAnimation = ColorTween(
      begin: Colors.black,
      end: Colors.blueGrey,
    ).animate(_controller);

    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleLoginSignup() {
    setState(() {
      login = !login;
      _controller.reverse().then((_) => _controller.forward());
    });
  }

  Future<void> _resetPassword() async {
    if (restemail.text!=null) {
      try {
        print(restemail.text);
        await FirebaseAuth.instance.sendPasswordResetEmail(email: restemail.text);
        showCustomSnackBar(context, "Password reset email sent", Colors.lightBlue);
      } on FirebaseAuthException catch (e) {
        print(e.message);
        showCustomSnackBar(context, e.message ?? "Error occurred", Colors.red);
      }
    } else {
      showCustomSnackBar(context, "Please enter your email", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Scaffold(
        backgroundColor: _backgroundColorAnimation.value,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16),
              child: FadeTransition(
                opacity: _formAnimation,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: Duration(milliseconds: 300),
                        style: TextStyle(
                          fontSize: 32, // Increased font size
                          color: _textColorAnimation.value,
                          fontWeight: FontWeight.bold,
                        ),
                        child: Text(login ? 'Login' : 'Signup'),
                      ),
                      SizedBox(height: 20),
                      if (showForgotPassword)
                        Column(
                          children: [
                            TextFormField(
                              key: ValueKey('resetEmail'),
                              controller: restemail,
                              decoration: InputDecoration(
                                hintText: 'Enter your email',
                                hintStyle: TextStyle(color: Colors.grey[600]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: Icon(Icons.email, color: Colors.grey[600]),
                              ),
                              validator: (value) {
                                if (value!.isEmpty || !value.contains('@')) {
                                  return 'Please Enter a valid Email';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                setState(() {
                                  resetEmail = value!;
                                });
                              },
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed:_resetPassword,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: _buttonColorAnimation.value,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                              ),
                              child: Text(
                                'Reset Password',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  showForgotPassword = false;
                                  _toggleLoginSignup(); // Go back to login/signup form
                                });
                              },
                              child: Text(
                                "Back to Login/Signup",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        )
                      else
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              if (!login)
                                TextFormField(
                                  key: ValueKey('fullname'),
                                  decoration: InputDecoration(
                                    hintText: 'Enter Full Name',
                                    hintStyle: TextStyle(color: Colors.grey[600]),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    prefixIcon: Icon(Icons.person, color: Colors.grey[600]),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please Enter Full Name';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) {
                                    setState(() {
                                      fullname = value!;
                                    });
                                  },
                                ),
                              if(!login)
                              Column(
                                children: [
                                  SizedBox(height: 10,),
                                  TextFormField(
                                    key: ValueKey('Mobile No:'),
                                    decoration: InputDecoration(
                                      hintText: 'Enter MobileNo:',
                                      hintStyle: TextStyle(color: Colors.grey[600]),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      prefixIcon: Icon(Icons.call, color: Colors.grey[600]),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty || value!.length!=10) {
                                        return 'Please Enter/valid MobileNo:';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      setState(() {
                                        MobileNo = value!;
                                      });
                                    },
                                  ),
                                  SizedBox(height:10),
                                  TextFormField(
                                    key: ValueKey('Shop Name:'),
                                    decoration: InputDecoration(
                                      hintText: 'Shop Name:',
                                      hintStyle: TextStyle(color: Colors.grey[600]),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      prefixIcon: Icon(Icons.shopping_bag_outlined, color: Colors.grey[600]),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please Enter Shop Name!';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      setState(() {
                                        ShopName = value!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                key: ValueKey('email'),
                                decoration: InputDecoration(
                                  hintText: 'Enter Email',
                                  hintStyle: TextStyle(color: Colors.grey[600]),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: Icon(Icons.email, color: Colors.grey[600]),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return 'Please Enter a valid Email';
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value){
                                  email=value;
                                },
                                onSaved: (value) {
                                  setState(() {
                                    email =  value ?? '';
                                  });
                                },
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                key: ValueKey('password'),
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Enter Password',
                                  hintStyle: TextStyle(color: Colors.grey[600]),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: Icon(Icons.lock, color: Colors.grey[600]),
                                ),

                                onSaved: (value) {
                                  setState(() {
                                    password = value!;
                                  });
                                },
                              ),
                              SizedBox(height: 20),
                              ScaleTransition(
                                scale: _buttonScaleAnimation,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      login
                                          ? FirebaseAuthentication.signinUser(email, password, context)
                                          : FirebaseAuthentication.signupUser(
                                          email, password, fullname,MobileNo,ShopName, context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: _buttonColorAnimation.value,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                                  ),
                                  child: Text(
                                    login ? 'Login' : 'Signup',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextButton(
                                onPressed: _toggleLoginSignup,
                                child: Text(
                                  login
                                      ? "Don't have an account? Signup"
                                      : "Already have an account? Login",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              SizedBox(height: 10),
                              if (!showForgotPassword)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      showForgotPassword = true;
                                      _controller.reverse().then((_) => _controller.forward());
                                    });
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
