import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/store_services.dart';
import 'package:flutter_application_2/consts/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VacncySoldScreen extends StatelessWidget {
  final String userId;

  const VacncySoldScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vacancy Sale Report'),
      ),
      backgroundColor: whiteColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: StoreServices.getSalesReport(userId),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // Display message when there are no orders
            return Center(
              child: Text(
                'No Records found',
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            var data = snapshot.data!.docs;

            // Aggregate sales data
            Map<String, dynamic> salesData = {};
            for (var orderDoc in data) {
              List<dynamic> products = orderDoc['orders']; // Adjust this to match your actual field name
              for (var product in products) {
                String productId = product['p_id'];
                String productName = product['title'];
                int quantity = product['qty'];
                double price = product['tprice'].toDouble(); // Convert to double

                if (salesData.containsKey(productId)) {
                  salesData[productId]['quantity'] += quantity;
                  salesData[productId]['total_sales'] += (quantity * price);
                } else {
                  salesData[productId] = {
                    'product_name': productName,
                    'product_image': product['img'], // Added product image
                    'quantity': quantity,
                    'total_sales': quantity * price,
                  };
                }
              }
            }

            // Convert sales data to a list for easier display
            List salesList = salesData.values.toList();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: salesList.length,
                itemBuilder: (context, index) {
                  var salesEntry = salesList[index];
                  return ListTile(
                    leading: Image.network(
                      salesEntry['product_image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(salesEntry['product_name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Vacancy Taken: ${salesEntry['quantity']}'),
                        Text('Total sales: Rs. ${salesEntry['total_sales']}'),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
