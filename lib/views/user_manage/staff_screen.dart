import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/consts/colors.dart';
import 'package:flutter_application_2/views/user_manage/staff_details.dart';

class AdminUserManagementScreen extends StatefulWidget {
  final String userId;

  const AdminUserManagementScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _AdminUserManagementScreenState createState() => _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState extends State<AdminUserManagementScreen> {
  late Stream<QuerySnapshot> ordersCollection;

  @override
  void initState() {
    super.initState();
    ordersCollection = FirebaseFirestore.instance
        .collection('orders')
        .where('vendor_id', isEqualTo: widget.userId)
        .snapshots();
  }

  void _navigateToUserDetail(String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailScreen(userId: userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: fontGrey,
        iconTheme: const IconThemeData(color: Colors.white), // Set back arrow color to white
        title: const Text(
          'Staff Details',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ordersCollection,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Staff found.'),
            );
          }
          final users = snapshot.data!.docs;

          // Track seen order_by values to avoid duplicates
          var seenOrderBy = <String>{};

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final userId = user.id;
              final userData = user.data() as Map<String, dynamic>;
              final orderBy = userData['order_by'] as String;

              // Check if order_by has already been seen
              if (seenOrderBy.contains(orderBy)) {
                return SizedBox.shrink(); // Return an empty SizedBox for duplicates
              }

              seenOrderBy.add(orderBy); // Add order_by to seen set

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    onTap: () {
                      _navigateToUserDetail(userId);
                    },
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name:', // Label as Name
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            userData['order_by_name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Staff Id:', // Label as Customer Id
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            orderBy,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    // trailing: IconButton(
                    //   icon: const Icon(Icons.delete, color: Colors.red),
                    //   onPressed: () {
                    //     deleteUser(userId);
                    //   },
                    // ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
