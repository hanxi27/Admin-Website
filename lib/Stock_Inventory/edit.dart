import 'package:flutter/material.dart';

class EditProduct extends StatefulWidget {
  final Map<String, String> product;
  final int quantity;

  EditProduct({required this.product, this.quantity = 10});

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  late String _selectedCategory;
  late String _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product['title']);
    _quantityController = TextEditingController(text: widget.quantity.toString());
    _priceController = TextEditingController(text: widget.product['price']);
    _selectedCategory = widget.product['category']!;
    _selectedImage = widget.product['image']!;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    // Implement save product logic here
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Product',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Image.asset(
                _selectedImage,
                width: 100,
                height: 100,
              ),
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
                  //prefixText: 'RM ',
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
                  DropdownMenuItem(
                    value: 'Nutrition',
                    child: Text('Nutrition'),
                  ),
                  DropdownMenuItem(
                    value: 'Supplement',
                    child: Text('Supplement'),
                  ),
                  DropdownMenuItem(
                    value: 'Tonic',
                    child: Text('Tonic'),
                  ),
                  DropdownMenuItem(
                    value: 'Foot Treatment',
                    child: Text('Foot Treatment'),
                  ),
                  DropdownMenuItem(
                    value: 'Traditional Medicine',
                    child: Text('Traditional Medicine'),
                  ),
                  DropdownMenuItem(
                    value: 'Groceries',
                    child: Text('Groceries'),
                  ),
                  DropdownMenuItem(
                    value: 'Coffee',
                    child: Text('Coffee'),
                  ),
                  DropdownMenuItem(
                    value: 'Dairy Product',
                    child: Text('Dairy Product'),
                  ),
                  DropdownMenuItem(
                    value: 'Make Up',
                    child: Text('Make Up'),
                  ),
                  DropdownMenuItem(
                    value: 'Pets Care',
                    child: Text('Pets Care'),
                  ),
                  DropdownMenuItem(
                    value: 'Hair Care',
                    child: Text('Hair Care'),
                  ),
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
