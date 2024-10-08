import 'package:flutter/material.dart';
import 'view.dart'; // Import the ViewProduct widget
import 'edit.dart'; // Import the EditProduct widget
import 'allproducts.dart'; // Replace with actual path
import 'add_product.dart'; // Import the AddProduct widget
import 'dart:io'; // Import this for File
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'dart:typed_data'; // For Uint8List
import 'dart:convert'; // For base64 encoding
import 'package:firebase_database/firebase_database.dart';

class StockInventoryPage extends StatefulWidget {
  @override
  _StockInventoryPageState createState() => _StockInventoryPageState();
}

class _StockInventoryPageState extends State<StockInventoryPage> {
  String searchQuery = '';
  String selectedCategory = 'All';
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    loadProducts(); // Real-time listener now triggers UI update automatically
  }

  List<Map<String, String>> get filteredProducts {
    return allProductsNotifier.value
        .where((product) =>
            (selectedCategory == 'All' || product['category'] == selectedCategory) &&
            (searchQuery.isEmpty ||
                product['title']!.toLowerCase().contains(searchQuery.toLowerCase())))
        .toList();
  }

  void _viewProduct(Map<String, String> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ViewProduct(product: product);
      },
    );
  }

  void _editProduct(Map<String, String> product) async {
    bool isUpdated = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditProduct(product: product);
      },
    );
    if (isUpdated) {
      setState(() {});
      saveProducts(); // Save the updated products
    }
  }

  void _deleteProduct(Map<String, String> product) {
    setState(() {
      allProductsNotifier.value.remove(product);
    });
    saveProducts(); // Save the updated products list after deletion
  }

  void _toggleOptions(int index) {
    setState(() {
      selectedIndex = selectedIndex == index ? null : index;
    });
  }

  void _addProduct() async {
    bool isAdded = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProduct()),
    );
    if (isAdded) {
      setState(() {}); // UI will rebuild due to ValueListenableBuilder
    }
  }

  bool _isBase64(String str) {
    try {
      base64Decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  Widget _getImageWidget(String imagePath) {
    if (kIsWeb && _isBase64(imagePath)) {
      Uint8List bytes = base64Decode(imagePath);
      return Image.memory(
        bytes,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (!kIsWeb && File(imagePath).existsSync()) {
      return Image.file(
        File(imagePath),
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        imagePath,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Inventory'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addProduct,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search by name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple, width: 2.0),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(value: 'All', child: Text('All')),
                        DropdownMenuItem(value: 'Nutrition', child: Text('Nutrition')),
                        DropdownMenuItem(value: 'Supplement', child: Text('Supplement')),
                        DropdownMenuItem(value: 'Tonic', child: Text('Tonic')),
                        DropdownMenuItem(value: 'Foot Treatment', child: Text('Foot Treatment')),
                        DropdownMenuItem(value: 'Traditional Medicine', child: Text('Traditional Medicine')),
                        DropdownMenuItem(value: 'Groceries', child: Text('Groceries')),
                        DropdownMenuItem(value: 'Coffee', child: Text('Coffee')),
                        DropdownMenuItem(value: 'Dairy Product', child: Text('Dairy Product')),
                        DropdownMenuItem(value: 'Make Up', child: Text('Make Up')),
                        DropdownMenuItem(value: 'Pets Care', child: Text('Pets Care')),
                        DropdownMenuItem(value: 'Hair Care', child: Text('Hair Care')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<List<Map<String, String>>>(
                valueListenable: allProductsNotifier,
                builder: (context, allProducts, child) {
                  List<Map<String, String>> filteredProducts = allProducts
                      .where((product) =>
                          (selectedCategory == 'All' || product['category'] == selectedCategory) &&
                          (searchQuery.isEmpty ||
                              product['title']!.toLowerCase().contains(searchQuery.toLowerCase())))
                      .toList();

                  filteredProducts.sort((a, b) => a['title']!.compareTo(b['title']!));

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6, // Adjusted to display 6 products per row
                      childAspectRatio: 0.8, // Adjusted to make the cards less tall
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      bool isOutOfStock = int.parse(product['quantity'] ?? '0') == 0;

                      return GestureDetector(
                        onTap: () => _toggleOptions(index),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black), // Black border
                            borderRadius: BorderRadius.circular(10), // Rounded corners
                          ),
                          margin: EdgeInsets.all(4.0), // Margin around each product
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                      child: _getImageWidget(product['image']!),
                                    ),
                                    if (isOutOfStock)
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          color: Colors.black54,
                                          padding: EdgeInsets.all(4.0),
                                          child: Text(
                                            'Out of Stock',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product['title']!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  product['price']!,
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  product['category']!,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              if (selectedIndex == index)
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => _viewProduct(product),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        minimumSize: Size(double.infinity, 30), // Set fixed height
                                      ),
                                      child: Text('View', style: TextStyle(color: Colors.white, fontSize: 12)),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => _editProduct(product),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        minimumSize: Size(double.infinity, 30), // Set fixed height
                                      ),
                                      child: Text('Edit', style: TextStyle(color: Colors.white, fontSize: 12)),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => _deleteProduct(product),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        minimumSize: Size(double.infinity, 30), // Set fixed height
                                      ),
                                      child: Text('Delete', style: TextStyle(color: Colors.white, fontSize: 12)),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
