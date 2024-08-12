import 'package:flutter_application_2/consts/consts.dart';
import 'package:flutter_application_2/controllers/jobs_controller.dart';
import 'package:flutter_application_2/views/job_screen/jobedit.dart';

class JobsDetails extends StatelessWidget {
  final String userId;
  final dynamic data;
  final String? title;
  const JobsDetails({Key? key, this.data, required this.userId, this.title}) : super(key: key);

  List<Widget> getRatings(List<dynamic> ratings) {
    List<Widget> ratingWidgets = [];

    for (var ratingData in ratings) {
      double rating = double.tryParse(ratingData['rating'] ?? '0.0') ?? 0.0;
      String userId = ratingData['id'] ?? '';

      ratingWidgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("User ID: $userId"),
            VxRating(
              isSelectable: false,
              value: rating,
              onRatingUpdate: (value) {},
              normalColor: textfieldGrey,
              selectionColor: golden,
              count: 5,
              maxRating: 5,
              size: 25,
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    }

    return ratingWidgets;
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('No product data available.'),
        ),
      );
    }

    // Get the ProductsController instance
    Get.put(JobsController(userId: userId));

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: fontGrey,
        iconTheme: const IconThemeData(color: whiteColor),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: whiteColor),
        ),
        title: boldText(text: "${data['p_name']}", color: whiteColor, size: 16.0),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditJobScreen(userId: userId, productId: data['p_id']), // Pass necessary parameters
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // VxSwiper.builder(
              //   autoPlay: true,
              //   height: 350,
              //   itemCount: data['p_imgs'].length,
              //   aspectRatio: 16 / 9,
              //   viewportFraction: 1.0,
              //   itemBuilder: (context, index) {
              //     return Image.network(
              //       data['p_imgs'][index],
              //       width: double.infinity,
              //       fit: BoxFit.cover,
              //     );
              //   },
              // ),
              const SizedBox(height: 10),
              // Wrapping the information section inside a box
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    boldText(text: "Name: ${data['p_name']}", color: Colors.black, size: 18.0),
                    const SizedBox(height: 10),
                    boldText(text: "Category: ${data['p_category']}", color: Colors.black, size: 18.0),
                    const SizedBox(height: 10),
                    boldText(text: "Sub-cate: ${data['p_subcategory']}", color: Colors.black, size: 18.0),
                    const SizedBox(height: 10),
                    boldText(text: "Price: Rs.${data['p_price']}", color: Colors.black, size: 18.0),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: normalText(text: "Vacany", color: Colors.black, size: 18.0),
                        ),
                        boldText(text: "${data['p_quantity']} items", color: Colors.black, size: 18.0),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              boldText(text: "Description", color: Colors.black, size: 18.0),
              const SizedBox(height: 10),
              normalText(text: "${data['p_desc']}", color: Colors.black, size: 18.0),
              const SizedBox(height: 20),
                boldText(text: "Requirement", color: Colors.black, size: 18.0),
              const SizedBox(height: 10),
              normalText(text: "${data['p_requirement']}", color: Colors.black, size: 18.0),
              const SizedBox(height: 20),
                boldText(text: "Role & Respon", color: Colors.black, size: 18.0),
              const SizedBox(height: 10),
              normalText(text: "${data['p_role&responsible']}", color: Colors.black, size: 18.0),
              const SizedBox(height: 20),
                boldText(text: "Address", color: Colors.black, size: 18.0),
              const SizedBox(height: 10),
               normalText(text: "${data['p_jobaddress']}", color: Colors.black, size: 18.0),
              const SizedBox(height: 20),
               boldText(text: "Job Type", color: Colors.black, size: 18.0),
              const SizedBox(height: 10),
               normalText(text: "${data['p_jobtype']}", color: Colors.black, size: 18.0),
              const SizedBox(height: 20),
               boldText(text: "Job Time", color: Colors.black, size: 18.0),
              const SizedBox(height: 10),
               normalText(text: "${data['p_jobtime']}", color: Colors.black, size: 18.0),
              const SizedBox(height: 20),
                boldText(text: "Gender", color: Colors.black, size: 18.0),
              const SizedBox(height: 10),
               normalText(text: "${data['p_gender']}", color: Colors.black, size: 18.0),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return Container(
                        padding: const EdgeInsets.all(16.0),
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Job Ratings',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: getRatings(data['p_ratings']),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // ElevatedButton(
                            //   onPressed: () {
                            //     Navigator.pop(context);
                            //   },
                            //   child: const Text('Back'),
                            // ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: const Text('Show Ratings', style: TextStyle(fontSize: 16, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, // Button color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
