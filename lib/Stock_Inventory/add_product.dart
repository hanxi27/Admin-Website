import 'package:flutter/material.dart';
import 'allproducts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  late String _selectedCategory;
  dynamic _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _quantityController = TextEditingController();
    _priceController = TextEditingController();
    _selectedCategory = 'Nutrition';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        setState(() {
          _selectedImage = result.files.first.bytes;
        });
      }
    } else {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    }
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      String imageString;
      if (kIsWeb) {
        imageString = base64.encode(_selectedImage);
      } else {
        imageString = base64.encode(await (_selectedImage as File).readAsBytes());
      }

      final newProduct = {
        "title": _nameController.text,
        "category": _selectedCategory,
        "price": _priceController.text,
        "quantity": _quantityController.text,  // Added quantity
        "image": imageString,
      };

      final databaseReference = FirebaseDatabase.instance.reference();
      await databaseReference.child('products').push().set(newProduct);

      Navigator.pop(context, true); // Return true to indicate product was added
    } else if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select an image'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a quantity';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    return null;
                  },
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
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Pick Image'),
                    ),
                    SizedBox(width: 16),
                    if (_selectedImage != null)
                      kIsWeb
                          ? Image.memory(
                              _selectedImage as Uint8List,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              _selectedImage as File,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                    else
                      Text('No image selected'),
                  ],
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
      ),
    );
  }
}
