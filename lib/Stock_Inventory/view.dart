import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'dart:typed_data';

class ViewProduct extends StatefulWidget {
  final Map<String, String> product;

  ViewProduct({required this.product});

  @override
  _ViewProductState createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  int quantity = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUpdatedQuantity();
  }

  Future<void> _fetchUpdatedQuantity() async {
    final databaseReference = FirebaseDatabase.instance.ref();
    DatabaseEvent event = await databaseReference.child('products').orderByChild('title').equalTo(widget.product['title']).once();
    DataSnapshot snapshot = event.snapshot;
    if (snapshot.exists) {
      Map<dynamic, dynamic> productData = snapshot.value as Map<dynamic, dynamic>;
      productData.forEach((key, value) {
        setState(() {
          quantity = int.parse(value['quantity'].toString());
          isLoading = false; // Stop loading
        });
      });
    } else {
      setState(() {
        quantity = 0;
        isLoading = false; // Stop loading
      });
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
    if (_isBase64(imagePath)) {
      Uint8List bytes = base64Decode(imagePath);
      return Image.memory(
        bytes,
        width: 150,
        height: 150,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        imagePath,
        width: 150,
        height: 150,
        fit: BoxFit.cover,
      );
    }
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
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getImageWidget(widget.product['image']!),
                  SizedBox(height: 16),
                  Text(
                    'Name: ${widget.product['title']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Quantity: $quantity',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Price: ${widget.product['price']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Category: ${widget.product['category']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Close'),
                  ),
                ],
              ),
      ),
    );
  }
}
