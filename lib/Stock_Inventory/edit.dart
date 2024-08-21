import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'allproducts.dart';

class EditProduct extends StatefulWidget {
  final Map<String, String> product;

  EditProduct({required this.product});

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  late String _selectedCategory;
  late String _selectedImage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product['title']);
    _priceController = TextEditingController(text: widget.product['price']);
    _selectedCategory = widget.product['category']!;
    _selectedImage = widget.product['image']!;
    _quantityController = TextEditingController(); // Initialize the controller
    _fetchUpdatedQuantity(); // Fetch the updated quantity from Firebase
  }

  Future<void> _fetchUpdatedQuantity() async {
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseEvent event = await databaseReference.child('products').orderByChild('title').equalTo(widget.product['title']).once();
    DataSnapshot snapshot = event.snapshot;
    if (snapshot.exists) {
      Map<dynamic, dynamic> productData = snapshot.value as Map<dynamic, dynamic>;
      productData.forEach((key, value) {
        setState(() {
          _quantityController.text = value['quantity'].toString();
          isLoading = false; // Stop loading
        });

        // Immediately update the allProductsNotifier to reflect the current status
        widget.product['quantity'] = _quantityController.text;
        allProductsNotifier.value = List.from(allProductsNotifier.value);  // Trigger UI update in StockInventoryPage
      });
    } else {
      setState(() {
        _quantityController.text = '0';
        isLoading = false; // Stop loading
      });
      // Immediately handle the case where the quantity is 0
      widget.product['quantity'] = '0';
      allProductsNotifier.value = List.from(allProductsNotifier.value);  // Trigger UI update in StockInventoryPage
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
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
    if (_isBase64(imagePath)) {
      Uint8List bytes = base64Decode(imagePath);
      return Image.memory(
        bytes,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        imagePath,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    }
  }

  void _saveProduct() async {
    final databaseReference = FirebaseDatabase.instance.ref();
    setState(() {
      widget.product['title'] = _nameController.text;
      widget.product['price'] = _priceController.text;
      widget.product['quantity'] = int.parse(_quantityController.text) < 0
          ? '0'
          : _quantityController.text; // Ensure quantity is at least 0
      widget.product['category'] = _selectedCategory;
    });

    Map<String, String> updatedProduct = {
      'title': _nameController.text,
      'price': _priceController.text,
      'quantity': _quantityController.text,
      'category': _selectedCategory,
      'image': widget.product['image']!,
    };

    await databaseReference
        .child('products')
        .orderByChild('title')
        .equalTo(widget.product['title'])
        .once()
        .then((event) {
      if (event.snapshot.exists) {
        event.snapshot.children.forEach((childSnapshot) {
          databaseReference.child('products').child(childSnapshot.key!).update(updatedProduct);
        });
      }
    });

    allProductsNotifier.value = List.from(allProductsNotifier.value); // Notify listeners
    Navigator.pop(context, true); // Return true to indicate product was updated
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Edit Product',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    _getImageWidget(_selectedImage),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Product Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Product Category',
                        border: OutlineInputBorder(),
                      ),
                      items: [
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
                          _selectedCategory = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _saveProduct,
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
