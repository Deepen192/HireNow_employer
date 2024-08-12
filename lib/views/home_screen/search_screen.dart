import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/consts/consts.dart';
import 'package:flutter_application_2/services/store_services.dart';
import 'package:flutter_application_2/views/job_screen/job_details.dart';
import 'package:flutter_application_2/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  final String? title;
  final String userId;

  const SearchScreen({super.key, this.title, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDAD3BE),
      appBar: AppBar(
        title: Text(title ?? '').color(Colors.black),
      ),
      body: FutureBuilder(
        future: StoreServices.searchJobs(title),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return "No products found".text.makeCentered();
          } else {
            var data = snapshot.data!.docs;
            var filtered = data.where((element) => element['p_name'].toString().toLowerCase().contains(title!.toLowerCase())).toList();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  mainAxisExtent: 300,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        filtered[index]['p_imgs'][0],
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                      const Spacer(),
                      "${filtered[index]['p_name']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                      10.heightBox,
                      // Display both p_price with pd_price if available
                      if (filtered[index]['pd_price'] != null && filtered[index]['pd_price'].isNotEmpty) ...[
                        Row(
                          children: [
                            Text(
                              "Rs.${filtered[index]['p_price']}",
                              style: const TextStyle(
                                color: Colors.orange,
                                fontFamily: bold,
                                fontSize: 18,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            10.widthBox,
                            Text(
                              "Rs.${filtered[index]['pd_price']}",
                              style: const TextStyle(
                                color: Colors.orange,
                                fontFamily: bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        // Display only p_price when pd_price is null or empty
                        Text(
                          "Rs.${filtered[index]['p_price']}",
                          style: const TextStyle(
                            color: Colors.orange,
                            fontFamily: bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                      10.heightBox,
                    ],
                  ).box.white.outerShadowMd.margin(const EdgeInsets.symmetric(horizontal: 4)).roundedSM.padding(const EdgeInsets.all(12)).make().onTap(() {
                    Get.to(() => JobsDetails(
                          userId: userId,
                          title: "${filtered[index]['p_name']}",
                          data: filtered[index],
                        ));
                  });
                },
              ),
            );
          }
        },
      ),
    );
  }
}
