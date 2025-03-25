import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mresurement/Authentications/AuthnticationFunctions.dart';
import 'package:mresurement/Home.dart';
import 'package:mresurement/add_mesure_user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart'; // Import for phone call
import 'package:permission_handler/permission_handler.dart';
class DetailsPage extends StatefulWidget {
  final String documentId;
  var UserName;
  DetailsPage({required this.documentId});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isLoading = false; // Add loading state

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> createAndSharePdf(String DocumentID) async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    try {
      final pdf = pw.Document();
      final data = await FirebaseFirestore.instance.collection('measurements')
          .doc(DocumentID)
          .get();
      final documentData = data.data() as Map<String, dynamic>;
      final fontData = await rootBundle.load('assets/NotoSans-Regular.ttf');
      final ttf = pw.Font.ttf(fontData);
      pdf.addPage(
        pw.Page(
          build:  (pw.Context context) {
      return pw.Padding(
      padding: pw.EdgeInsets.all(16),
      child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
      pw.Text('Measurement Of ${documentData['name']}', style: pw.TextStyle(
      fontSize: 24, fontWeight: pw.FontWeight.bold, font: ttf,fontFallback:[pw.Font.times(),pw.Font.courier()])),
      pw.SizedBox(height: 20),
      pw.Text('Personal Information', style: pw.TextStyle(
      fontSize: 18, fontWeight: pw.FontWeight.bold, font: ttf)),
      _buildPdfRow('Name:', documentData['name'], ttf),
      _buildPdfRow('Age:', documentData['age'].toString(), ttf),
      _buildPdfRow('Mobile:', documentData['mobile'], ttf),
      _buildPdfRow('Address:', documentData['address'], ttf),
      pw.SizedBox(height: 20),
      pw.Text('Shirt Measurements', style: pw.TextStyle(
      fontSize: 18, fontWeight: pw.FontWeight.bold, font: ttf,fontFallback: [pw.Font.times(),pw.Font.courier()])),
      _buildPdfRow('Chest:', documentData['shirt_measurements']['chest'].toString(), ttf),
      _buildPdfRow('Waist:', documentData['shirt_measurements']['waist'].toString(), ttf),
      _buildPdfRow('Seat:', documentData['shirt_measurements']['seat'].toString(), ttf),
      _buildPdfRow('Bicep:', documentData['shirt_measurements']['bicep'].toString(), ttf),
      _buildPdfRow('Shirt Length:', documentData['shirt_measurements']['shirtLength'].toString(), ttf),
      _buildPdfRow('Shoulder:', documentData['shirt_measurements']['shoulder'].toString(), ttf),
      _buildPdfRow('Sleeve:', documentData['shirt_measurements']['sleeve'].toString(), ttf),
      _buildPdfRow('Cuff:', documentData['shirt_measurements']['cuff'].toString(), ttf),
      _buildPdfRow('Collar:', documentData['shirt_measurements']['collar'].toString(), ttf),
      _buildPdfRow('Shirt Extras:', documentData['shirt_measurements']['extras'].toString(), ttf),
      pw.SizedBox(height: 20),
      pw.Text('Pant Measurements', style: pw.TextStyle(
      fontSize: 18, fontWeight: pw.FontWeight.bold, font: ttf,fontFallback: [ttf])),
      _buildPdfRow('Waist:', documentData['pant_measurements']['waist'].toString(), ttf),
      _buildPdfRow('Hip:', documentData['pant_measurements']['hip'].toString(), ttf),
      _buildPdfRow('Inseam:', documentData['pant_measurements']['inseam'].toString(), ttf),
      _buildPdfRow('Thigh:', documentData['pant_measurements']['thigh'].toString(), ttf),
      _buildPdfRow('Knee:', documentData['pant_measurements']['knee'].toString(), ttf),
      _buildPdfRow('Pant Length:', documentData['pant_measurements']['pantLength'].toString(), ttf),
      _buildPdfRow('Rise:', documentData['pant_measurements']['rise'].toString(), ttf),
      _buildPdfRow('Extras:', documentData['pant_measurements']['extras'], ttf),
      ],
      ),
      );
      },
        ),
      );

      final outputFile = await _getOutputFile();
      final file = File(outputFile.path);
      await file.writeAsBytes(await pdf.save());

      // Share the PDF
      await Share.shareFiles([file.path], text: 'Here is the measurement details PDF');
    } catch (e) {
      print('Error creating or sharing PDF: $e');
    } finally {
      setState(() {
        _isLoading = false; // Set loading state to false
      });
    }
  }

  Future<File> _getOutputFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/${widget.UserName}-measurement-data.pdf');
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error making phone call: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Measurement Details'),
        backgroundColor: Colors.indigo.shade50,
        foregroundColor: Colors.black87,
      ),
      body: _isLoading // Conditional UI for loading state
          ? Center(child: CircularProgressIndicator(color: Colors.black))
          : FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('measurements')
            .doc(widget.documentId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.black));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No Data Found'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          widget.UserName = data['name'];
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: FadeTransition(
              opacity: _animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(1, 0),
                  end: Offset(0, 0),
                ).animate(_animation),
                child: Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSection('Personal Information',Ionicons.person_sharp),
                        _buildInfoRow('Name:', data['name']),
                        _buildInfoRow('Age:', data['age'].toString()),
                        _buildInfoRow('Mobile:', data['mobile']),
                        _buildInfoRow('Address:', data['address']),
                        SizedBox(height: 16.0),
                        _buildSection('Shirt Measurements',Ionicons.shirt_outline),
                        _buildInfoRow(
                            'Chest:', data['shirt_measurements']['chest'].toString()),
                        _buildInfoRow(
                            'Waist:', data['shirt_measurements']['waist'].toString()),
                        _buildInfoRow(
                            'Seat:', data['shirt_measurements']['seat'].toString()),
                        _buildInfoRow(
                            'Bicep:', data['shirt_measurements']['bicep'].toString()),
                        _buildInfoRow('Shirt Length:',
                            data['shirt_measurements']['shirtLength'].toString()),
                        _buildInfoRow('Shoulder:',
                            data['shirt_measurements']['shoulder'].toString()),
                        _buildInfoRow('Sleeve:',
                            data['shirt_measurements']['sleeve'].toString()),
                        _buildInfoRow('Cuff:',
                            data['shirt_measurements']['cuff'].toString()),
                        _buildInfoRow('Collar:',
                            data['shirt_measurements']['collar'].toString()),
                        _buildInfoRow('Shirt Extras:',
                            data['shirt_measurements']['extras'].toString()),
                        SizedBox(height: 16.0),
                        _buildSection('Pant Measurements',Ionicons.body_outline),
                        _buildInfoRow(
                            'Waist:', data['pant_measurements']['waist'].toString()),
                        _buildInfoRow('Hip:', data['pant_measurements']['hip'].toString()),
                        _buildInfoRow(
                            'Inseam:', data['pant_measurements']['inseam'].toString()),
                        _buildInfoRow(
                            'Thigh:', data['pant_measurements']['thigh'].toString()),
                        _buildInfoRow('Knee:', data['pant_measurements']['knee'].toString()),
                        _buildInfoRow('Pant Length:',
                            data['pant_measurements']['pantLength'].toString()),
                        _buildInfoRow('Rise:', data['pant_measurements']['rise'].toString()),
                        _buildInfoRow('Extras:', data['pant_measurements']['extras']),
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [

                                Container(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerInfoScreen(DocumentId: widget.documentId,),));
                                    },
                                    icon: Icon(Icons.edit, color: Colors.white),
                                    label: Text('Edit/Update Client', style: TextStyle(color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.cyan,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: (){createAndSharePdf(widget.documentId);},
                                  child: Row(
                                    children: [Icon(Ionicons.download_outline,color: Colors.white,),
                                      Text(' Download as PDF', style: TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _makePhoneCall(data['mobile']);
                                  },
                                  icon: Icon(Icons.phone, color: Colors.white),
                                  label: Text('Call', style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.lightGreen,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    showDialog(context: context, builder: (context) => CupertinoAlertDialog(
                                      title: Text('Are You Sure You!!\n Want to Delete : ${data['name']}'),
                                      actions: [
                                        TextButton(onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('measurements')
                                              .doc(widget.documentId)
                                              .delete();
                                          showCustomDeletebar(context, 'You Want To recover!!', Colors.red, widget.documentId, data);

                                          Navigator.pushAndRemoveUntil(context,
                                              MaterialPageRoute(builder: (context) => home()),
                                          (route) => route.isFirst);
                                        }, child: Text('Yes!', style: TextStyle(color: Colors.red))),
                                        TextButton(onPressed: () {
                                          Navigator.pop(context);
                                        }, child: Text('No!', style: TextStyle(color: Colors.lightGreen))),
                                      ],
                                    ));
                                  },
                                  icon: Icon(Icons.delete, color: Colors.white),
                                  label: Text('Delete', style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title,Data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(Data,color: Colors.indigo.shade700,),
          Text(" "+
            title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.indigo.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfRow(String label, String value, pw.Font ttf) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: 16,font: ttf,fontFallback: [pw.Font.times(),pw.Font.courier()])),
        pw.Text(value, style: pw.TextStyle(fontSize: 16,font: ttf,fontFallback: [pw.Font.times(),pw.Font.courier()])),
      ],
    );
  }
}

void showCustomDeletebar(BuildContext context, String msg, Color clr, String documentId, Map<String, dynamic> WholeData) {
  final snackBar = SnackBar(
    duration: Duration(milliseconds: 5000),
    action: SnackBarAction(
      label: 'Undo',
      textColor: Colors.lime,
      onPressed: () async {
        await FirebaseFirestore.instance.collection('measurements').add(WholeData);
      },
    ),
    content: Text(
      msg,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: clr ?? Colors.deepPurpleAccent,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
