import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/consts/consts.dart';
import 'package:flutter_application_2/services/store_services.dart';
import 'package:flutter_application_2/views/shop_screen/office_setting_screen.dart';

class OfficeDetailsScreen extends StatelessWidget {
  final String userId;
  const OfficeDetailsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: fontGrey,
        iconTheme: const IconThemeData(color: Colors.white), 
        title: const Text('Office Details', style: TextStyle(fontSize: 16.0, color: whiteColor)),
        actions: [
          IconButton(
            icon: Icon(Icons.edit,color: Colors.white,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>   OfficeSetting(userId:userId,),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: StoreServices.getProfile(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No office details found.'));
          }

          final officeData = snapshot.data!.docs.first.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                ListTile(
                  title: Text('Office Name', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  subtitle: Text(officeData['office_name'] ?? 'N/A', style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(height: 10),
                ListTile(
                  title: Text('Email Address', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  subtitle: Text(officeData['office_email_address'] ?? 'N/A', style: TextStyle(color: Colors.black)),
                ),
                ListTile(
                  title: Text('Address', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  subtitle: Text(officeData['office_address'] ?? 'N/A', style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(height: 10),
                ListTile(
                  title: Text('Mobile', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  subtitle: Text(officeData['office_mobile'] ?? 'N/A', style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(height: 10),
                ListTile(
                  title: Text('Website', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  subtitle: Text(officeData['office_website'] ?? 'N/A', style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(height: 10),
                ListTile(
                  title: Text('Description', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  subtitle: Text(officeData['office_desc'] ?? 'N/A', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
