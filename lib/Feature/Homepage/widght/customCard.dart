// Feature/Homepage/widght/customCard.dart
import 'package:cal/Feature/edit_Product/Modal/ProductModel.dart';
import 'package:flutter/material.dart';
import '../../edit_Product/editProductPage.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({
    super.key,
    required this.productModel,
    required this.isAdmin, // أضف هنا isAdmin
  });

  final ProductModel productModel;
  final bool isAdmin; // هنا الحقل

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  late int initialCount;

  @override
  void initState() {
    super.initState();
    initialCount = widget.productModel.count;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditProductPage(
              productModel: widget.productModel,
              isAdmin: widget.isAdmin, // تمرير القيمة هنا
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                widget.productModel.imageUrl,
                height: MediaQuery.of(context).size.height * .3,
                width: MediaQuery.of(context).size.width * .5,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productModel.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.productModel.price} EGP',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.productModel.count}/$initialCount',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
