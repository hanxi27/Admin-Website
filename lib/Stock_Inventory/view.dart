import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';

class ViewProduct extends StatelessWidget {
  final Map<String, String> product;
  final int quantity;

  ViewProduct({required this.product, this.quantity = 10});

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _getImageWidget(product['image']!),
            SizedBox(height: 16),
            Text(
              'Name: ${product['title']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Quantity: $quantity',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Price: ${product['price']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Category: ${product['category']}',
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
