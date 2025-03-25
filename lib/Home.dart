import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'Authentications/AuthnticationFunctions.dart';
import 'ClientDetailPage.dart';
import 'add_mesure_user.dart';

class home extends StatefulWidget {
  const home({super.key, this.ValueTobeCheckd});
  final bool? ValueTobeCheckd;

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late AnimationController _likeController;
  late Animation<double> _likeAnimation;
  late Animation<double> _scaleAnimation;

  String searchQuery = "";
  List<DocumentSnapshot> filteredData = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.grey.shade100,
    ).animate(_controller);

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();

    _likeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _likeAnimation = CurvedAnimation(
      parent: _likeController,
      curve: Curves.easeInOut,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(_likeController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    _likeController.dispose();
    super.dispose();
  }

  void _filterData(String query, List<DocumentSnapshot> data) {
    if (query.isEmpty) {
      filteredData = data;
    } else {
      filteredData = data.where((doc) {
        final documentData = doc.data() as Map<String, dynamic>;
        final name = (documentData['name'] ?? '').toLowerCase();
        final mobile = (documentData['mobile'] ?? '').toLowerCase();
        final searchLower = query.toLowerCase();
        return name.contains(searchLower) || mobile.contains(searchLower);
      }).toList();
    }
  }

  void _toggleFavorite(String documentId, int index) async {
    try {
      DocumentSnapshot docSnapshot = filteredData[index];
      bool currentFavoriteStatus = (docSnapshot.data() as Map<String, dynamic>)['isFavorite'] == 1;
      bool newFavoriteStatus = !currentFavoriteStatus;

      // Update Firestore
      await FirebaseFirestore.instance
          .collection('measurements')
          .doc(documentId)
          .update({'isFavorite': newFavoriteStatus ? 1 : 0});

      // Refresh the filteredData list
      final snapshot = await FirebaseFirestore.instance
          .collection('measurements')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      setState(() {
        _filterData(searchQuery, snapshot.docs);
      });

      _likeController.forward().then((_) {
        _likeController.reverse();
      });

      showCustomSnackBar(
        context,
        '${newFavoriteStatus ? 'Favorited' : 'Unfavorited'} ${docSnapshot['name']}',
        newFavoriteStatus ? Colors.blue : Colors.red,
      );
    } catch (e) {
      showCustomSnackBar(
        context,
        'Error updating favorite status: ${e.toString()}',
        Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isFavPage = widget.ValueTobeCheckd ?? false;
    final User user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      floatingActionButton: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return FloatingActionButton(
            foregroundColor: Colors.transparent,
            isExtended: false,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerInfoScreen(),
                ),
              );
            },
            backgroundColor: _colorAnimation.value,
            child: Image.asset(
              "assets/513741.png",
              height: 65,
              width: 45,
              alignment: Alignment.center,
            ),
          );
        },
      ),
      appBar: AppBar(
        foregroundColor: Colors.black87,
        backgroundColor: Colors.indigo.shade50,
        elevation: 5,
        excludeHeaderSemantics: true,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            Text(
              !isFavPage ? "Customers" : 'Favorite',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search by name or mobile number',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
                // Trigger filtering when searchQuery changes
                // Filtering happens inside the StreamBuilder to avoid build phase updates
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: !isFavPage
                  ? FirebaseFirestore.instance
                  .collection("measurements")
                  .where('uid', isEqualTo: user.uid)
                  .snapshots()
                  : FirebaseFirestore.instance
                  .collection("measurements")
                  .where('uid', isEqualTo: user.uid)
                  .where('isFavorite', isEqualTo: 1)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isNotEmpty) {
                    final List<DocumentSnapshot> documents = snapshot.data!.docs;

                    // Filter data after fetching
                    _filterData(searchQuery, documents);

                    return ListView.builder(
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final document = filteredData[index];
                        final documentId = document.id;

                        return FadeTransition(
                          opacity: _animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(1, 0),
                              end: Offset(0, 0),
                            ).animate(_animation),
                            child: Card(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 13.0),
                              color: Colors.white,
                              elevation: 3.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(10.0),
                                leading: Icon(Icons.person,
                                    size: 32, color: Colors.blueGrey),
                                title: Text(
                                  (document.data() as Map<String, dynamic>)['name'] ?? 'N/A',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                                subtitle: Text(
                                  (document.data() as Map<String, dynamic>)['mobile'] ?? 'N/A',
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.remove_red_eye_outlined,
                                          color: Colors.lightBlue),
                                      onPressed: () {
                                        showCustomSnackBar(context,
                                            'Seeing ${document['name']}',
                                            Colors.blue);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailsPage(
                                                documentId: documentId),
                                          ),
                                        ).then((value) {
                                          setState(() {});
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        (document.data() as Map<String, dynamic>)['isFavorite'] == 1
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: (document.data() as Map<String, dynamic>)['isFavorite'] == 1
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      onPressed: () {
                                        _toggleFavorite(documentId, index);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text(
                        "No Data To Display! \nPlease Take Some Measurement!",
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
