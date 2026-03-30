// import 'package:flutter/material.dart';
// import 'package:king_jamaica_caffe/services/database_service.dart';
//
// import '../models/category.dart';
// import '../models/product.dart';
// import 'product_detail_screen.dart';
// import '../utils/screen_util.dart';
//
// class ProductListScreen extends StatefulWidget {
//   final Category category;
//
//   const ProductListScreen({
//     super.key,
//     required this.category,
//   });
//
//   @override
//   State<ProductListScreen> createState() => _ProductListScreenState();
// }
//
// class _ProductListScreenState extends State<ProductListScreen> {
//   late Future<List<Product>> _productsFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _productsFuture = MenuDatabase().getProductsOfCategory(widget.category.id);
//   }
//
//   Future<void> _refresh() async {
//     setState(() {
//       _productsFuture = MenuDatabase().getProductsOfCategory(widget.category.id);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bool useGrid = context.isTablet || context.isDesktop;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           '${widget.category.englishName} / ${widget.category.arabicName}',
//           style: TextStyle(
//             fontSize: context.responsive<double>(
//               mobile: 18,
//               tablet: 20,
//               desktop: 24,
//             ),
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: RefreshIndicator.adaptive(
//         onRefresh: _refresh,
//         child: FutureBuilder<List<Product>>(
//           future: _productsFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             if (snapshot.hasError) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.error_outline_rounded, size: 64, color: Colors.redAccent),
//                     const SizedBox(height: 16),
//                     Text(
//                       'حدث خطأ أثناء تحميل المنتجات\n${snapshot.error.toString().split('\n').first}',
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(fontSize: 16, height: 1.4),
//                     ),
//                     const SizedBox(height: 24),
//                     FilledButton.icon(
//                       onPressed: _refresh,
//                       icon: const Icon(Icons.refresh),
//                       label: const Text('إعادة المحاولة'),
//                     ),
//                   ],
//                 ),
//               );
//             }
//
//             final products = snapshot.data ?? [];
//
//             if (products.isEmpty) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.coffee_rounded, size: 90, color: Colors.brown[300]),
//                     const SizedBox(height: 20),
//                     Text(
//                       'لا توجد منتجات متاحة في\n${widget.category.arabicName}',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: context.responsive<double>(mobile: 18, tablet: 20, desktop: 22),
//                         color: Colors.grey[700],
//                         height: 1.4,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       'سيتم إضافتها قريباً',
//                       style: TextStyle(
//                         fontSize: context.responsive<double>(mobile: 14, tablet: 15, desktop: 16),
//                         color: Colors.grey[500],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }
//
//             return Padding(
//               padding: EdgeInsets.all(
//                 context.responsive<double>(
//                   mobile: 8.0,
//                   tablet: 12.0,
//                   desktop: 16.0,
//                 ),
//               ),
//               child: useGrid
//                   ? GridView.builder(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: context.responsive<int>(
//                     mobile: 2,
//                     tablet: 3,
//                     desktop: 4,
//                   ),
//                   childAspectRatio: 0.72,
//                   crossAxisSpacing: 14,
//                   mainAxisSpacing: 14,
//                 ),
//                 itemCount: products.length,
//                 itemBuilder: (context, index) => _buildGridItem(context, products[index]),
//               )
//                   : ListView.separated(
//                 itemCount: products.length,
//                 separatorBuilder: (context, index) => const SizedBox(height: 8),
//                 itemBuilder: (context, index) => _buildListItem(context, products[index]),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildListItem(BuildContext context, Product product) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(14),
//         onTap: () => _navigateToDetail(product),
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Row(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: Image.asset(
//                   product.imagePath ?? 'assets/placeholder_product.jpg',
//                   width: context.responsive<double>(mobile: 70, tablet: 80, desktop: 90),
//                   height: context.responsive<double>(mobile: 70, tablet: 80, desktop: 90),
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => Container(
//                     color: Colors.grey[200],
//                     child: const Icon(Icons.image_not_supported, color: Colors.grey),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       product.englishName ?? product.arabicName,
//                       style: TextStyle(
//                         fontSize: context.responsive<double>(mobile: 16, tablet: 17, desktop: 18),
//                         fontWeight: FontWeight.w600,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       product.arabicName,
//                       style: TextStyle(
//                         fontSize: context.responsive<double>(mobile: 13, tablet: 14, desktop: 15),
//                         color: Colors.grey[700],
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       '${product.price.toStringAsFixed(0)} ج.م',
//                       style: TextStyle(
//                         fontSize: context.responsive<double>(mobile: 16, tablet: 17, desktop: 18),
//                         fontWeight: FontWeight.bold,
//                         color: Colors.brown[800],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGridItem(BuildContext context, Product product) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       clipBehavior: Clip.antiAlias,
//       child: InkWell(
//         onTap: () => _navigateToDetail(product),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               flex: 5,
//               child: Image.asset(
//                 product.imagePath ?? 'assets/placeholder_product.jpg',
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) => Container(
//                   color: Colors.grey[100],
//                   alignment: Alignment.center,
//                   child: const Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 3,
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       product.englishName ?? product.arabicName,
//                       style: TextStyle(
//                         fontSize: context.responsive<double>(mobile: 14, tablet: 15, desktop: 16),
//                         fontWeight: FontWeight.w600,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       product.arabicName,
//                       style: TextStyle(
//                         fontSize: context.responsive<double>(mobile: 12, tablet: 13, desktop: 14),
//                         color: Colors.grey[600],
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const Spacer(),
//                     Text(
//                       '${product.price.toStringAsFixed(0)} ج.م',
//                       style: TextStyle(
//                         fontSize: context.responsive<double>(mobile: 15, tablet: 16, desktop: 17),
//                         fontWeight: FontWeight.bold,
//                         color: Colors.brown[700],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _navigateToDetail(Product product) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => ProductDetailScreen(initialProduct: product),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:king_jamaica_caffe/services/database_service.dart';
import '../models/category.dart';
import '../models/product.dart';
import 'product_detail_screen.dart';
import '../utils/screen_util.dart';

class ProductListScreen extends StatefulWidget {
  final Category category;

  const ProductListScreen({
    super.key,
    required this.category,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _productsFuture;
  final MenuDatabase _db = MenuDatabase();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _productsFuture = _db.getProductsOfCategory(widget.category.id);
    });
  }

  Future<void> _refresh() async {
    await _loadProducts();
  }

  // Helper to build product image with proper error handling
  Widget _buildProductImage(String? imagePath, {double? width, double? height}) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      );
    }

    // Network image (Supabase Storage or external URL)
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      );
    }

    // Base64 image (web uploads)
    if (imagePath.startsWith('data:image')) {
      try {
        final base64String = imagePath.split(',').last;
        return Image.memory(
          base64Decode(base64String),
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: const Icon(Icons.broken_image, color: Colors.grey),
          ),
        );
      } catch (e) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
      }
    }

    // Asset image
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.image_not_supported, color: Colors.grey),
        ),
      );
    }

    // Local file path
    try {
      return Image.file(
        File(imagePath),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      );
    } catch (e) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: const Icon(Icons.broken_image, color: Colors.grey),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool useGrid = context.isTablet || context.isDesktop;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.category.englishName} / ${widget.category.arabicName}',
          style: TextStyle(
            fontSize: context.responsive<double>(
              mobile: 18,
              tablet: 20,
              desktop: 24,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: _refresh,
        child: FutureBuilder<List<Product>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 64, color: Colors.redAccent),
                    const SizedBox(height: 16),
                    Text(
                      'حدث خطأ أثناء تحميل المنتجات\n${snapshot.error.toString().split('\n').first}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _refresh,
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            final products = snapshot.data ?? [];

            // Filter available products if needed (optional)
            final availableProducts = products.where((p) => p.isAvailable).toList();
            final unavailableProducts = products.where((p) => !p.isAvailable).toList();

            // Show all products or just available ones?
            // This example shows all but visually distinguishes unavailable ones
            final displayProducts = products; // Show all products

            if (displayProducts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.coffee_rounded, size: 90, color: Colors.brown[300]),
                    const SizedBox(height: 20),
                    Text(
                      'لا توجد منتجات متاحة في\n${widget.category.arabicName}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: context.responsive<double>(mobile: 18, tablet: 20, desktop: 22),
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'سيتم إضافتها قريباً',
                      style: TextStyle(
                        fontSize: context.responsive<double>(mobile: 14, tablet: 15, desktop: 16),
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.all(
                context.responsive<double>(
                  mobile: 8.0,
                  tablet: 12.0,
                  desktop: 16.0,
                ),
              ),
              child: useGrid
                  ? GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: context.responsive<int>(
                    mobile: 2,
                    tablet: 3,
                    desktop: 4,
                  ),
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: displayProducts.length,
                itemBuilder: (context, index) => _buildGridItem(context, displayProducts[index]),
              )
                  : ListView.separated(
                itemCount: displayProducts.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) => _buildListItem(context, displayProducts[index]),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, Product product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: product.isAvailable ? null : Colors.grey[50],
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: product.isAvailable ? () => _navigateToDetail(product) : null,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _buildProductImage(
                  product.imagePath,
                  width: context.responsive<double>(mobile: 70, tablet: 80, desktop: 90),
                  height: context.responsive<double>(mobile: 70, tablet: 80, desktop: 90),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.englishName ?? product.arabicName,
                            style: TextStyle(
                              fontSize: context.responsive<double>(mobile: 16, tablet: 17, desktop: 18),
                              fontWeight: FontWeight.w600,
                              color: product.isAvailable ? null : Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!product.isAvailable)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'غير متاح',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.red[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.arabicName,
                      style: TextStyle(
                        fontSize: context.responsive<double>(mobile: 13, tablet: 14, desktop: 15),
                        color: product.isAvailable ? Colors.grey[700] : Colors.grey[500],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${product.price.toStringAsFixed(0)} ج.م',
                      style: TextStyle(
                        fontSize: context.responsive<double>(mobile: 16, tablet: 17, desktop: 18),
                        fontWeight: FontWeight.bold,
                        color: product.isAvailable ? Colors.brown[800] : Colors.grey[600],
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

  Widget _buildGridItem(BuildContext context, Product product) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      color: product.isAvailable ? null : Colors.grey[50],
      child: InkWell(
        onTap: product.isAvailable ? () => _navigateToDetail(product) : null,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 5,
                  child: _buildProductImage(
                    product.imagePath,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.englishName ?? product.arabicName,
                          style: TextStyle(
                            fontSize: context.responsive<double>(mobile: 14, tablet: 15, desktop: 16),
                            fontWeight: FontWeight.w600,
                            color: product.isAvailable ? null : Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.arabicName,
                          style: TextStyle(
                            fontSize: context.responsive<double>(mobile: 12, tablet: 13, desktop: 14),
                            color: product.isAvailable ? Colors.grey[600] : Colors.grey[500],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Text(
                          '${product.price.toStringAsFixed(0)} ج.م',
                          style: TextStyle(
                            fontSize: context.responsive<double>(mobile: 15, tablet: 16, desktop: 17),
                            fontWeight: FontWeight.bold,
                            color: product.isAvailable ? Colors.brown[700] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (!product.isAvailable)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'غير متاح',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.red[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(initialProduct: product),
      ),
    ).then((_) {
      // Refresh products when returning from detail screen (in case of changes)
      _refresh();
    });
  }
}
