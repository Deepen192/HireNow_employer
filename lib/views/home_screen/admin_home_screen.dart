import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/consts/consts.dart';
import 'package:flutter_application_2/controllers/dashboard_button.dart';
import 'package:flutter_application_2/services/store_services.dart';
import 'package:flutter_application_2/views/job_screen/job_details.dart';
import 'package:flutter_application_2/widgets_common/loading_indicator.dart';

class AdminHomeScreen extends StatelessWidget {
  final String userId;
  const AdminHomeScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: appbarWidget(dashboard),
      body: StreamBuilder(
        stream: StoreServices.getProducts(userId),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator();
          } else {
            var data = snapshot.data!.docs; 
 
           data = data.sortedBy((a, b) =>
                b['p_wishlist'] .length.compareTo(a['p_wishlist'].length));

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        dashboardButton(context,
                            title: jobs,
                            count: "${data.length}",
                            icon: icAdminproduct),
                            StreamBuilder<QuerySnapshot>(
                        stream: StoreServices.getAllOrders(userId),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> ordersSnapshot) {
                          if (!ordersSnapshot.hasData) {
                            return loadingIndicator();
                          } else {
                            var totalOrders = ordersSnapshot
                                .data!.docs.length
                                .toString();
                            return dashboardButton(context,
                                title: applicants, count: totalOrders, icon: icAdminorder);
                          }
                        },
                      ),
                    ],
                  ),
                            10.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            StreamBuilder<QuerySnapshot>(
                            stream: StoreServices.getProducts(userId), // Use getProducts() method
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> productsSnapshot) {
                              if (!productsSnapshot.hasData) {
                                return loadingIndicator();
                              } else {
                                var products = productsSnapshot.data!.docs;
                                var totalRatings = products.fold<int>(
                                  0,
                                  (previousValue, product) =>
                                      previousValue + (product['p_wishlist'] as List).length,
                                );

                                return dashboardButton(
                                  context,
                                  title: 'Total Ratings', // Adjust the title as needed
                                  count: totalRatings.toString(),
                                  icon: icAdminStar, // Adjust the icon as needed
                                );
                              }
                            },
                          ),

                            SizedBox(
                              height: 80,
                              child: StreamBuilder<QuerySnapshot>(
                              stream: StoreServices.getAllOrders(userId),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> ordersSnapshot) {
                                if (!ordersSnapshot.hasData) {
                                  return loadingIndicator();
                                } else {
                                  var allOrders = ordersSnapshot.data!.docs;
                                  var paidOrders = allOrders.where((order) => order['payment_status'] == true).toList();
                                  var totalPaidOrders = paidOrders.length.toString();
                              
                                  return dashboardButton(
                                    context,
                                    title: 'Total Hired',
                                    count: totalPaidOrders,
                                    icon: icAdminorder,
                                  );
                                }
                              },
                              ),
                            ),
                          
                          ],
                        ),
                     10.heightBox,
                    const Divider(),
                    10.heightBox,
                    boldText(text: popular,color: fontGrey, size: 16.0),
                    20.heightBox,
                        SizedBox(
                    height: 300,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                        data.length,
                        (index) => (data[index]['p_wishlist'] as List).isEmpty
                            ? const SizedBox()
                            : ListTile(
                                onTap: () {
                                  Get.to(() => JobsDetails(
                                        data: data[index], userId:userId,
                                      ));
                                },
                                // leading: Image.network(data[index]['p_imgs'][0],
                                //     width: 100, height: 100, fit: BoxFit.cover),
                                title: boldText(
                                    text: "${data[index]['p_name']}",
                                    color: fontGrey),
                                subtitle: normalText(
                                    text: "Rs.${data[index]['p_price']}",
                                    color: darkFontGrey),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
