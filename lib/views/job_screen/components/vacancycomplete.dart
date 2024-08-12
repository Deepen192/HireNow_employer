import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/consts/colors.dart';
import 'package:flutter_application_2/consts/firebase_consts.dart';
import 'package:flutter_application_2/views/job_screen/job_details.dart';
// Import ProductsDetails screen

class VacancyCompletedScreen extends StatelessWidget {
  final String userId;
  const VacancyCompletedScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vacancy Completed'),
      ),
      backgroundColor: whiteColor,
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection(productsCollection)
            .where('vendor_id', isEqualTo: userId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Yet No Vacancy is Full.'));
          } else {
            var allProducts = snapshot.data!.docs;
            var lowStockProducts = allProducts.where((doc) {
              var quantityString = doc['p_quantity'] as String;
              var quantity = int.tryParse(quantityString) ?? 0;
              return quantity <= 0;
            }).toList();

            if (lowStockProducts.isEmpty) {
              return Center(child: Text('Yet No Vacancy is Full.'));
            }

            return ListView.builder(
              itemCount: lowStockProducts.length,
              itemBuilder: (context, index) {
                var product = lowStockProducts[index].data() as Map<String, dynamic>;
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobsDetails(data: product, userId: userId),
                        ),
                      );
                    },
                    leading: Image.network(
                      product['p_imgs'][0],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(product['p_name']),
                    // subtitle: Text('Quantity: ${product['p_quantity']}'),
                    trailing: Text('Rs. ${product['p_price']}'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
