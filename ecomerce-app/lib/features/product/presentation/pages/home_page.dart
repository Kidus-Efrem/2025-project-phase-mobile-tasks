// lib/features/product/pages/home_page.dart
import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';
import '../widgets/initial_product.dart';
import '../widgets/product_card_list.dart';
import '../widgets/product_heading.dart';
import '../widgets/user_intro.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Product> products;

  @override
  void initState() {
    super.initState();
    products = List.from(initialProducts);
  }

  void goToAddProductPage(BuildContext context) async {
    final result = await Navigator.pushNamed(context, '/update');
    final Product? product = result as Product?;
    if (product != null) {
      setState(() {
        final index = products.indexWhere((p) => p.name == product.name);
        if (index != -1) {
          products[index] = product;
        } else {
          products.add(product);
        }
      });
    }

    if (result != null) {
      setState(() {
        final index = products.indexWhere((p) => p.name == result.name);
        if (index != -1) {
          products[index] = result;
        } else {
          products.add(result);
        }
      });
    }
  }

  Widget productHeading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Available Products',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3E3E3E), // Hex color #3E3E3E
            ),
          ),
          Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(
                8,
              ), // optional rounded corners
            ),
           child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.search, color: Colors.grey[400]),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
            tooltip: 'Search',
          ),
        ),
        ],
      ),
    );
  }

  Widget userIntro() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Container(
          width: 50, // Container width
          height: 50, // Container height
          decoration: BoxDecoration(
            color: const Color(0xFFCCCCCC), // Fill color
            borderRadius: BorderRadius.circular(6), // Rounded corners
          ),
        ),
        const SizedBox(width: 8),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'July 17, 2025',
              style: TextStyle(
                fontFamily: 'Syne', // Use Syne font
                fontWeight: FontWeight.w500, // Medium weight
                fontSize: 12,
                color: Color(0xFFAAAAAA), // Hex color #AAAAAA
              ),
            ),
            SizedBox(height: 4),
            Text.rich(
              TextSpan(
                text: 'Hello, ',
                style: TextStyle(
                  fontFamily: 'Sora', // Use Sora font
                  fontWeight: FontWeight.w400, // Regular weight
                  fontSize: 10,
                  color: Color(0xFFAAAAAA),
                ), // Default style

                children: [
                  TextSpan(
                    text: 'Yohannes',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'sora',
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const UserIntro(userName: 'Kidus', dateText: 'July 29, 2025'),
        actions: const [_NotificationIcon()],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(8),
            children: [
              productHeading(context),

              const SizedBox(height: 8),
              ProductCardList(
                products: products,
                onDelete: (name) {
                  setState(() {
                    products.removeWhere((p) => p.name == name);
                  });
                },
                onUpdate: (product) {
                  setState(() {
                    final index = products.indexWhere(
                      (p) => p.name == product.name,
                    );
                    if (index != -1) {
                      products[index] = product;
                    } else {
                      products.add(product);
                    }
                  });
                },
                context: context,
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () => goToAddProductPage(context),
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              color: Colors.grey[400],
              size: 20,
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
