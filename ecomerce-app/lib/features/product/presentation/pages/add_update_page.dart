// ignore: file_names
import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';
import '../widgets/label_text.dart';

class AddUpdatePage extends StatefulWidget {
  final Product? product; // ✅ Declare the field
  const AddUpdatePage({super.key, this.product});

  @override
  State<AddUpdatePage> createState() => _AddUpdatePageState();
}

class _AddUpdatePageState extends State<AddUpdatePage> {
  late TextEditingController nameController;
  late TextEditingController categoryController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    categoryController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();

    final product = widget.product;
    if (product != null) {
      nameController.text = product.name;
      categoryController.text = product.description;

      /// it will check later
      priceController.text = product.price.toString();
      descriptionController.text = product.description;
    }
  }

  void goBackToHomePage(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void addProduct() {
    final name = nameController.text.trim();
    final category = categoryController.text.trim();
    final price = priceController.text.trim();
    final description = descriptionController.text.trim();

    if (name.isEmpty ||
        category.isEmpty ||
        price.isEmpty ||
        description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields before adding the product.'),
        ),
      );
      return;
    }

    double? priceValue = double.tryParse(price);
    if (priceValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price.')),
      );
      return;
    }

    final newProduct = Product(
      id: '1',
      name: name,

      imageUrl: 'assets/default.jpeg', // Replace with actual path if available
      price: priceValue,

      description: description,
    );

    Navigator.pop(context, newProduct);

    // Return new product to previous screen
  }

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Product',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        leading: Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.only(left: 16),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: const Color(0xFF3F51F3),
            onPressed: () {
              goBackToHomePage(context);
            },
          ),
        ),

        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upload Container
              Container(
                height: 190,
                decoration: BoxDecoration(
                  color: const Color(0x0ff3f3f3),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const SizedBox(
                  width: 120,
                  height: 93,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        'Upload Image',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Name Field
              buildLabelText('Name'),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF3F3F3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),

              const SizedBox(height: 16),

              // Category Field
              buildLabelText('Category'),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF3F3F3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),

              const SizedBox(height: 16),

              // Price Field
              buildLabelText('Price'),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF3F3F3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  suffixIcon: const Icon(Icons.attach_money),
                ),
              ),

              const SizedBox(height: 16),

              // Description Field
              buildLabelText('Description'),
              SizedBox(
                height: 140,
                child: TextField(
                  controller: descriptionController,
                  expands: true,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF3F3F3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Add & Delete Buttons
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F51F3),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        // 👈 Border radius
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),

                    onPressed: addProduct,
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16), // 👈 Correct vertical spacing
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(
                        // 👈 Border color and width
                        color: Color(0xFFFF1313), // Red border
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        // 👈 Border radius
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      nameController.clear();
                      categoryController.clear();
                      priceController.clear();
                      descriptionController.clear();
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFF1313),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
