import 'package:flutter_application_2/consts/consts.dart';
import 'package:flutter_application_2/controllers/userorders_controller.dart';
import 'package:flutter_application_2/views/userorders_screen/components/pdf_viewer.dart';
import 'components/userorder_place.dart';
import 'package:intl/intl.dart' as intl;
class UserOrderDetails extends StatefulWidget {
  final dynamic data;
  const UserOrderDetails({super.key, this.data});

  @override
  State<UserOrderDetails> createState() => _UserOrderDetailsState();
}

class _UserOrderDetailsState extends State<UserOrderDetails> {
  var controller= Get.put(UserOrdersController());
  @override
  void initState() {   
    super.initState();
    controller.getOrders(widget.data);
    controller.confirmed.value=widget.data['order_confirmed'];
    controller.ondelivery.value=widget.data['order_on_delivery'];
    controller.delivered.value=widget.data['order_delivered'];
  }
  @override
  Widget build(BuildContext context) {
 
    return Obx(
      ()=>Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: fontGrey,
          iconTheme: const IconThemeData(color: Colors.white), // Set back arrow color to white
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white), // Ensure the back arrow is white
          ),
          title: boldText(text: "User Order details", color: whiteColor, size: 16.0),
        ),

        bottomNavigationBar: Visibility(
          visible: !controller.confirmed.value,
          child: SizedBox(
            height: 60,
            width: context.screenWidth,
            child: ourButton(color: green,onPress: (){
              controller.confirmed(true);
              controller.changeStatus(title: "order_confirmed",status: true,docID: widget.data.id);
            },title: "Confirm"),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [  
                //order delivery status section
                Visibility(
                  visible: controller.confirmed.value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      boldText(text: "Order Status",color: purpleColor,size: 16.0),
                      SwitchListTile(
                        activeColor: green,
                        value: true,
                        onChanged: (value){},
                        title: boldText(text: "Placed",color: fontGrey),
                      ),
                       SwitchListTile(
                        activeColor: green,
                        value: controller.confirmed.value,
                        onChanged: (value){
                          controller.confirmed.value=value;
                        },
                        title: boldText(text: "Processing",color: fontGrey),
                      ),
                       SwitchListTile(
                        activeColor: green,
                        value: controller.ondelivery.value,
                        onChanged: (value){
                          controller.ondelivery.value=value;
                         
                          controller.changeStatus(title: "order_on_delivery",status:value,docID: widget.data.id);
                        },
                        title: boldText(text: "Reviewed",color: fontGrey),
                      ),
                       SwitchListTile(
                        activeColor: green,
                        value: controller.delivered.value,
                        onChanged: (value){
                          controller.delivered.value=value;                          
                          controller.changeStatus(title: "order_delivered",status:value,docID: widget.data.id);
                        },
                        title: boldText(text: "Selection",color: fontGrey),
                      ),
                       SwitchListTile(
                        activeColor: green,
                        value: controller.paymentstatus.value,
                        onChanged: (value){
                          controller.paymentstatus.value=value;                          
                          controller.changeStatus(title: "payment_status",status:value,docID: widget.data.id);
                        },
                        title: boldText(text: "Paid",color: fontGrey),
                      ),
                      
                    ],
                  ).box.padding(const EdgeInsets.all(8)).outerShadowMd.white.border(color: lightGrey).roundedSM.make(),
                ),
    
                //order detaiks section                                    
                    Column(
                      children: [
                         userOrderPlaceDetails(
                      d1: "${widget.data['order_code']}",
                      d2:ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerScreen(pdfUrl: widget.data['file_url']),
      ),
    );
  },
  child: Text("Open Doc", style: TextStyle(color: Colors.orange)),
),

                      title1: "Order Code",
                      title2: "CV Doc",
                     ),
          
                      userOrderPlaceDetails(
                        //d1: DateTime.now(),
                     d1: intl.DateFormat().add_yMd().format((widget.data['order_date'].toDate())),
                      d2:"${widget.data['payment_method']}",
                      title1: "Order Date",
                      title2: "Payment Method",
                     ), 
          
                     userOrderPlaceDetails(
                      d1: widget.data['payment_status'] == false ? "Unpaid" : "Paid",
                      d2:"Placed",
                      title1: "Payment Status",
                      title2: "Status",
                     ), 
                     15.heightBox,
                  const Divider(),
                  " Placed Job".text.bold.size(16).color(darkFontGrey).fontFamily(semibold).makeCentered(),
                    10.heightBox,
                    ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(controller.orders.length, (index){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        //   Align(
                        //  alignment: Alignment.center, // Align the image within the available space
                        //  child: Image.network(
                        //   controller.orders[index]['img'],
                        //   width: 400,
                        //   height: 200,
                        //   fit: BoxFit.fitHeight,
                        //  ),
                        // ),
                          userOrderPlaceDetails(
                              title1: "${controller.orders[index]['title']}",
                              title2: "Rs.${(controller.orders[index]['tprice'])}",
                              d1: "Profession",
                              d2: "Salary"
                            ),
                            // Padding(                        
                            //     padding: const EdgeInsets.symmetric(horizontal: 16),
                            //     child: Container(
                            //     width: 30,
                            //     height: 30,
                            //     color: Color(controller.orders[index]['color']),
                            //   ),
                            // ),
                            const Divider(),
                          ],
                        );
                      }).toList(),
                    ).box.outerShadowMd.white.margin(const EdgeInsets.only(bottom: 4)).make(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(                    
                            crossAxisAlignment:CrossAxisAlignment.start,
                              children:[
                              //"Shipping Address".text.fontFamily(semibold).make(),
                              boldText(text: "User Details",color: purpleColor),
                              // "User Details".text.fontFamily(semibold).make(),
                            // "${data['order_by_name']}".text.make(),
                            Row(children: [
                              "Name:${widget.data['order_by_firstname']}".text.make(),SizedBox(width: 5,),
                            "${widget.data['order_by_lastname']}".text.make(),
                            ],),
                             
                            "Email:${widget.data['order_by_email']}".text.make(),
                            "Address:${widget.data['order_by_address']}".text.make(),                           
                            "Phone:${widget.data['order_by_phone']}".text.make(),
                            // "${data['order_by_postalcode']}".text.make(),
                            ],
                          ),
                        ),
                        10.heightBox,
                        const Divider(),
          
                        SizedBox(
                          width: 130,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              boldText(text: "Total Amount",color: purpleColor),
                              boldText(text:"Rs.${widget.data['total_amount']}",color: Colors.orange,size: 16.0),                        
                             
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                      ],
                    ).box.outerShadowMd.white.border(color: lightGrey).roundedSM.make(),
                    const Divider(),
                    10.heightBox,
                    
              ],              
                
            ),
          ),
        ),
      ),
    );
  }
}