import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/services/store_services.dart';
import 'package:flutter_application_2/views/userorders_screen/userorder_details.dart';
import 'package:flutter_application_2/consts/consts.dart';
import 'package:flutter_application_2/widgets_common/loading_indicator.dart';
import 'package:intl/intl.dart' as intl;

class ApplicantScreen extends StatelessWidget {
  final String userId;
  const ApplicantScreen({Key? key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: appbarWidget(applicants),
      body: StreamBuilder(
        stream: StoreServices.getAllOrders(userId),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingIndicator();
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // Display message when there are no orders
            return Center(
              child: Text(
                'No Orders found',
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(data.length, (index) {
                    var time = data[index]['order_date'].toDate();
                    return ListTile(
                      onTap: () {
                        Get.to(() => UserOrderDetails(data: data[index]));
                      },
                      tileColor: textfieldGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: boldText(
                        text: "${data[index]['order_code']}",
                        color: purpleColor,
                      ),
                      subtitle: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_month, color: fontGrey),
                              10.heightBox,
                              boldText(
                                text: intl.DateFormat().add_yMd().format(time),
                                color: fontGrey,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.payment, color: fontGrey),
                              10.heightBox,
                              boldText(
                                text: data[index]['payment_status'] ? "Paid" : "Unpaid",
                                color: data[index]['payment_status'] ? Colors.green : Colors.orange,
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: boldText(
                        text: "Rs.${data[index]['total_amount']}",
                        color: purpleColor,
                        size: 16.0,
                      ),
                    ).box.margin(const EdgeInsets.only(bottom: 4)).make();
                  }),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
