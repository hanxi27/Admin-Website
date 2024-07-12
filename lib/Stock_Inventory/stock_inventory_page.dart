import 'package:flutter/material.dart';
import 'view.dart'; // Import the ViewProduct widget
import 'edit.dart'; // Import the EditProduct widget
import 'allproducts.dart'; // replace with actual path

class StockInventoryPage extends StatefulWidget {
  @override
  _StockInventoryPageState createState() => _StockInventoryPageState();
}

class _StockInventoryPageState extends State<StockInventoryPage> {
  String searchQuery = '';
  String selectedCategory = 'All';
  int? selectedIndex;

  List<Map<String, String>> get filteredProducts {
    List<Map<String, String>> filtered = allProducts
        .where((product) =>
            (selectedCategory == 'All' || product['category'] == selectedCategory) &&
            (searchQuery.isEmpty ||
                product['title']!.toLowerCase().contains(searchQuery.toLowerCase())))
        .toList();
    filtered.sort((a, b) => a['title']!.compareTo(b['title']!));
    return filtered;
  }

  void _viewProduct(Map<String, String> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ViewProduct(product: product, quantity: 10);
      },
    );
  }

  void _editProduct(Map<String, String> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditProduct(product: product, quantity: 10);
      },
    );
  }

  void _deleteProduct(Map<String, String> product) {
    // Implement delete product logic here
  }

  void _toggleOptions(int index) {
    setState(() {
      selectedIndex = selectedIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        DropdownMenuItem(
                          value: 'All',
                          child: Text('All'),
                        ),
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
                          selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6, // Adjusted to display 6 products per row
                  childAspectRatio: 0.6, // Adjusted based on your design
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                              child: Image.asset(
                                product['image']!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
