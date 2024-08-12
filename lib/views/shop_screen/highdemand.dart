import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/consts/consts.dart';

class HighDemandAdminScreen extends StatefulWidget {
  final String userId;
  const HighDemandAdminScreen({super.key, required this.userId});

  @override
  _HighDemandAdminScreenState createState() => _HighDemandAdminScreenState();
}

class _HighDemandAdminScreenState extends State<HighDemandAdminScreen> {
  late List<Product> products = [];
  List<Product> selectedProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    var productsSnapshot = await FirebaseFirestore.instance.collection(productsCollection).where('vendor_id', isEqualTo:widget.userId).get();
    setState(() {
      products = productsSnapshot.docs          
          .map((doc) => Product.fromFirestore(doc))
          .toList();
    });
  }

 Future<void> _toggleFlashSale(Product product, bool isSelected) async {
  if (isSelected) {
    selectedProducts.add(product);
  } else {
    selectedProducts.remove(product);
  }

  // Set the 'flashsales' value to true if selectedProducts is not empty, false otherwise
  var flashSalesValue = selectedProducts.isNotEmpty;

  // Update the 'flashsales' value in Firebase
  await FirebaseFirestore.instance
      .collection(productsCollection)
      .doc(product.id)
      .update({'flashsales': flashSalesValue});

  setState(() {
    product.flashSales = flashSalesValue;
  });
}


  Future<void> _saveFlashSale() async {
    var batch = FirebaseFirestore.instance.batch();

    for (var product in selectedProducts) {
      batch.update(
        FirebaseFirestore.instance.collection(productsCollection).doc(product.id),
        {'flashsales': true},
      );
    }

    await batch.commit();

    setState(() {
      for (var product in selectedProducts) {
        product.flashSales = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Flash sale set for selected products')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: fontGrey,
        iconTheme: const IconThemeData(color: Colors.white), 
        title: const Text("High Demands Jobs",style: TextStyle(color: Colors.white),),
      ),
      body:ListView.builder(
  itemCount: products.length,
  itemBuilder: (context, index) {
    var product = products[index];

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white, // Change the color to your desired color
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        leading: Image.network(
          product.image,
          fit: BoxFit.cover, // Make the image fit the entire box
          width: 80, // Set the width of the image
        ),
        title: Text(
          product.name,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: SingleChildScrollView(
           scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [            
              Text("Category: ${product.category}", style: const TextStyle(color: Colors.black)),
              const SizedBox(height: 5),            
              Text("Original Price: \Rs.${product.price.toStringAsFixed(2)}", style: const TextStyle(color: Colors.black)),
              const SizedBox(height: 5),
              Text("Discount: ${product.percentage.toStringAsFixed(0)}%", style: const TextStyle(color: Colors.black)),
                ],
                ),
        ),
              trailing: Checkbox(
                value: product.flashSales,
                onChanged: (isSelected) {
                  _toggleFlashSale(product, isSelected!);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          _saveFlashSale();
        },
         style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.grey, // Text color
                elevation: 0, // Set elevation to 0 to remove shadow
              ),
        child: const Text("Save"),
      ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  final double percentage;
  final String image;
  final String category;
  final String subcategory;
  bool flashSales;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.percentage,
    required this.image,
    required this.category,
    required this.subcategory,
    required this.flashSales,
  });

 factory Product.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['p_name'] ?? '',
      price: double.tryParse(data['pd_price'] ?? '0.0') ?? 0.0,
      percentage: double.tryParse(data['pd_percentage'] ?? '0.0') ?? 0.0,
      image: data['p_imgs'][0] ?? '',
      category: data['p_category'] ?? '', // Add this line
      subcategory: data['p_subcategory'] ?? '', // Add this line
      flashSales: data['flashsales'] ?? false,
    );
  }
}
