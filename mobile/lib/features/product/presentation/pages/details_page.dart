import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';
import '../widgets/product_card_item.dart';


class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});
  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int selectedSize = 41;
  void goBackToHomePage(BuildContext context) {
    Navigator.pop(context);
  }

  void goToUpdateProductPage(BuildContext context, Product product) async {
    final updatedProduct = await Navigator.pushNamed<Product>(
      context,
      '/update',
      arguments: product,
    );

    if (updatedProduct != null) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context, updatedProduct); // pass it up to HomePage
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      // ✅ You must use Scaffold here
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductCardItem(
                context: context,
                product: product, // wrap single product in a list
                isInDetailPage: true,
              ),
              // 4. "Size" Text
              const Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 8.0,
                  bottom: 12.0,
                ),
                child: Text(
                  'Size:',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Color(0xFF3E3E3E),
                  ),
                ),
              ),

              // 5. Size Containers (scrollable if overflow)
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 8.0,
                  bottom: 12.0,
                ),
                child: SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      final size = 39 + index;
                      final isSelected = size == selectedSize;

                      return Container(
                        margin: const EdgeInsets.only(right: 4),
                        padding: const EdgeInsets.only(bottom: 2),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedSize = size;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? const Color(0xFF3F51F3)
                                : Colors.white,
                            foregroundColor: isSelected
                                ? Colors.white
                                : const Color.fromARGB(255, 0, 0, 0),
                            elevation: 4,
                            shadowColor: const Color.fromRGBO(0, 0, 0, 0.10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                          child: Text('$size'),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // 6. Description
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 8.0,
                  bottom: 12.0,
                ),
                child: SizedBox(
                  height: 260,
                  child: Text(
                    product.description,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              ),

              // 7. Action Buttons
              Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  right: 12.0,
                  top: 8.0,
                  bottom: 4.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Delete Button
                    SizedBox(
                      width: 152,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFFF1313)),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // TODO: Add your delete logic
                          Navigator.pop(context, {
                            'action': 'delete',
                            'productName': widget.product.name,
                          });
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFFFF1313),
                          ),
                        ),
                      ),
                    ),

                    // Update Button
                    SizedBox(
                      width: 152,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F51F3),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              8,
                            ), // Optional: Rounded corners
                          ),
                        ),
                        onPressed: () {
                          // TODO: Add your update logic
                          goToUpdateProductPage(context, product);
                        },
                        child: const Text(
                          'Update',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
