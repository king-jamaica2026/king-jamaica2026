// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:king_jamaica_caffe/services/database_service.dart';
// import '../models/product.dart';
//
// class ProductDetailScreen extends StatefulWidget {
//   final Product initialProduct; // we receive initial data, but reload fresh from DB
//
//   const ProductDetailScreen({
//     super.key,
//     required this.initialProduct,
//   });
//
//   @override
//   State<ProductDetailScreen> createState() => _ProductDetailScreenState();
// }
//
// class _ProductDetailScreenState extends State<ProductDetailScreen> {
//   late Future<Product?> _productFuture;
//   final MenuDatabase _db = MenuDatabase();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProduct();
//   }
//
//   Future<void> _loadProduct() async {
//     setState(() {
//       _productFuture = _db.getProduct(widget.initialProduct.id);
//     });
//   }
//
//   // Helper to build product image with proper error handling
//   Widget _buildProductImage(String? imagePath) {
//     if (imagePath == null || imagePath.isEmpty) {
//       return Container(
//         height: 280,
//         color: Colors.grey[300],
//         child: const Icon(Icons.image_not_supported, size: 80),
//       );
//     }
//
//     // Network image (Supabase Storage or external URL)
//     if (imagePath.startsWith('http')) {
//       return Image.network(
//         imagePath,
//         height: 280,
//         width: double.infinity,
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) => Container(
//           height: 280,
//           color: Colors.grey[300],
//           child: const Icon(Icons.broken_image, size: 80),
//         ),
//         loadingBuilder: (context, child, loadingProgress) {
//           if (loadingProgress == null) return child;
//           return Container(
//             height: 280,
//             color: Colors.grey[300],
//             child: Center(
//               child: CircularProgressIndicator(
//                 value: loadingProgress.expectedTotalBytes != null
//                     ? loadingProgress.cumulativeBytesLoaded /
//                     loadingProgress.expectedTotalBytes!
//                     : null,
//               ),
//             ),
//           );
//         },
//       );
//     }
//
//     // Base64 image (web uploads)
//     if (imagePath.startsWith('data:image')) {
//       try {
//         final base64String = imagePath.split(',').last;
//         return Image.memory(
//           base64Decode(base64String),
//           height: 280,
//           width: double.infinity,
//           fit: BoxFit.cover,
//           errorBuilder: (context, error, stackTrace) => Container(
//             height: 280,
//             color: Colors.grey[300],
//             child: const Icon(Icons.broken_image, size: 80),
//           ),
//         );
//       } catch (e) {
//         return Container(
//           height: 280,
//           color: Colors.grey[300],
//           child: const Icon(Icons.broken_image, size: 80),
//         );
//       }
//     }
//
//     // Asset image
//     if (imagePath.startsWith('assets/')) {
//       return Image.asset(
//         imagePath,
//         height: 280,
//         width: double.infinity,
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) => Container(
//           height: 280,
//           color: Colors.grey[300],
//           child: const Icon(Icons.image_not_supported, size: 80),
//         ),
//       );
//     }
//
//     // Local file path
//     try {
//       return Image.file(
//         File(imagePath),
//         height: 280,
//         width: double.infinity,
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) => Container(
//           height: 280,
//           color: Colors.grey[300],
//           child: const Icon(Icons.broken_image, size: 80),
//         ),
//       );
//     } catch (e) {
//       return Container(
//         height: 280,
//         color: Colors.grey[300],
//         child: const Icon(Icons.broken_image, size: 80),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.initialProduct.englishName ?? 'Product'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _loadProduct,
//             tooltip: 'Refresh product data',
//           ),
//         ],
//       ),
//       body: FutureBuilder<Product?>(
//         future: _productFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (snapshot.hasError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.error_outline, size: 64, color: Colors.red),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Error loading product\n${snapshot.error}',
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton.icon(
//                     onPressed: _loadProduct,
//                     icon: const Icon(Icons.refresh),
//                     label: const Text('Try Again'),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           final product = snapshot.data;
//
//           if (product == null) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.sentiment_dissatisfied, size: 80, color: Colors.grey),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Product not found',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
//                   ),
//                   const SizedBox(height: 8),
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text('Go Back'),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Product Image
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: _buildProductImage(product.imagePath),
//                 ),
//
//                 const SizedBox(height: 24),
//
//                 // Availability Badge
//                 if (!product.isAvailable)
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     margin: const EdgeInsets.only(bottom: 12),
//                     decoration: BoxDecoration(
//                       color: Colors.red[100],
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(Icons.do_not_disturb, size: 16, color: Colors.red[800]),
//                         const SizedBox(width: 4),
//                         Text(
//                           'Not Available',
//                           style: TextStyle(
//                             color: Colors.red[800],
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                 // Names
//                 Text(
//                   product.englishName ?? 'Unnamed Product',
//                   style: const TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   product.arabicName,
//                   style: TextStyle(
//                     fontSize: 22,
//                     color: Colors.grey[700],
//                   ),
//                 ),
//
//                 const SizedBox(height: 16),
//
//                 // Price
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: product.isAvailable
//                         ? Colors.green[50]
//                         : Colors.grey[200],
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     '${product.price.toStringAsFixed(0)} EGP',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: product.isAvailable
//                           ? Colors.green[800]
//                           : Colors.grey[600],
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 24),
//
//                 // Description Sections
//                 if (product.englishDescription != null &&
//                     product.englishDescription!.isNotEmpty) ...[
//                   const Center(
//                     child: Text(
//                       'Description',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Card(
//                     elevation: 2,
//                     color: Colors.grey[50],
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Text(
//                         product.englishDescription!,
//                         style: const TextStyle(fontSize: 16, height: 1.5),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//
//                 if (product.arabicDescription != null &&
//                     product.arabicDescription!.isNotEmpty) ...[
//                   const Center(
//                     child: Text(
//                       'الوصف',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Card(
//                     elevation: 2,
//                     color: Colors.grey[50],
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Text(
//                         product.arabicDescription!,
//                         textAlign: TextAlign.right,
//                         style: const TextStyle(fontSize: 16, height: 1.5),
//                       ),
//                     ),
//                   ),
//                 ],
//
//                 if ((product.englishDescription == null ||
//                     product.englishDescription!.isEmpty) &&
//                     (product.arabicDescription == null ||
//                         product.arabicDescription!.isEmpty))
//                   Container(
//                     padding: const EdgeInsets.all(24),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Center(
//                       child: Text(
//                         'No description available.',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontStyle: FontStyle.italic,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                 const SizedBox(height: 32),
//
//                 // Action Buttons
//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton.icon(
//                         onPressed: () => Navigator.pop(context),
//                         icon: const Icon(Icons.arrow_back),
//                         label: const Text('Back'),
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: ElevatedButton.icon(
//                         onPressed: product.isAvailable
//                             ? () {
//                           // Add to cart or order action
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text('Added ${product.englishName} to cart'),
//                               duration: const Duration(seconds: 2),
//                             ),
//                           );
//                         }
//                             : null,
//                         icon: const Icon(Icons.shopping_cart),
//                         label: const Text('Order Now'),
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           backgroundColor: product.isAvailable ? null : Colors.grey,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 16),
//
//                 // Additional Info
//                 if (!product.isAvailable)
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.orange[50],
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.orange[200]!),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(Icons.info_outline, color: Colors.orange[700]),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             'This product is currently not available. Please check back later.',
//                             style: TextStyle(
//                               color: Colors.orange[800],
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                 const SizedBox(height: 24),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:king_jamaica_caffe/services/database_service.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product initialProduct;

  const ProductDetailScreen({
    super.key,
    required this.initialProduct,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Product?> _productFuture;
  final MenuDatabase _db = MenuDatabase();
  int _quantity = 1;
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    setState(() {
      _productFuture = _db.getProduct(widget.initialProduct.id);
    });
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  Future<void> _addToCart(Product product) async {
    if (!product.isAvailable) return;

    setState(() {
      _isAddingToCart = true;
    });

    // Simulate adding to cart (replace with actual cart logic)
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _isAddingToCart = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Added ${_quantity}x ${product.englishName} to cart',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  // Helper to build product image with proper error handling
  Widget _buildProductImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        height: 250,
        color: Colors.grey[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'No Image Available',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
      );
    }

    // Network image (Supabase Storage or external URL)
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 250,
          color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text(
                'Failed to load image',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
        ),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 250,
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
                color: Colors.brown,
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
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 250,
            color: Colors.grey[200],
            child: const Icon(Icons.broken_image, size: 64),
          ),
        );
      } catch (e) {
        return Container(
          height: 250,
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image, size: 64),
        );
      }
    }

    // Asset image
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 250,
          color: Colors.grey[200],
          child: const Icon(Icons.image_not_supported, size: 64),
        ),
      );
    }

    // Local file path
    try {
      return Image.file(
        File(imagePath),
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 250,
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image, size: 64),
        ),
      );
    } catch (e) {
      return Container(
        height: 250,
        color: Colors.grey[200],
        child: const Icon(Icons.broken_image, size: 64),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialProduct.englishName ?? 'Product',
          style: const TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProduct,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: FutureBuilder<Product?>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.brown),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading product',
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _loadProduct,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          final product = snapshot.data;

          if (product == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sentiment_dissatisfied, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Product not found',
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // Hero image with parallax effect
              SliverAppBar(
                expandedHeight: 280,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildProductImage(product.imagePath),
                      // Gradient overlay for better text readability
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Main content
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Availability Badge
                    if (!product.isAvailable)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.do_not_disturb, size: 16, color: Colors.red[800]),
                            const SizedBox(width: 8),
                            Text(
                              'Currently Unavailable',
                              style: TextStyle(
                                color: Colors.red[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Names
                    Text(
                      product.englishName ?? 'Unnamed Product',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.arabicName,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Price and Quantity Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Price
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: product.isAvailable
                                    ? [Colors.green[50]!, Colors.green[100]!]
                                    : [Colors.grey[100]!, Colors.grey[200]!],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Price',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: product.isAvailable ? Colors.green[800] : Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${product.price.toStringAsFixed(0)} EGP',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: product.isAvailable ? Colors.green[800] : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // const SizedBox(width: 12),

                        // Quantity Selector
                        // if (product.isAvailable)
                        //   Container(
                        //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        //     decoration: BoxDecoration(
                        //       color: Colors.grey[50],
                        //       borderRadius: BorderRadius.circular(12),
                        //       border: Border.all(color: Colors.grey[300]!),
                        //     ),
                        //     child: Row(
                        //       children: [
                        //         IconButton(
                        //           icon: const Icon(Icons.remove, size: 20),
                        //           onPressed: _decrementQuantity,
                        //           constraints: const BoxConstraints(minWidth: 32),
                        //           padding: EdgeInsets.zero,
                        //         ),
                        //         Container(
                        //           width: 40,
                        //           alignment: Alignment.center,
                        //           child: Text(
                        //             _quantity.toString(),
                        //             style: const TextStyle(
                        //               fontSize: 18,
                        //               fontWeight: FontWeight.bold,
                        //             ),
                        //           ),
                        //         ),
                        //         IconButton(
                        //           icon: const Icon(Icons.add, size: 20),
                        //           onPressed: _incrementQuantity,
                        //           constraints: const BoxConstraints(minWidth: 32),
                        //           padding: EdgeInsets.zero,
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Description Sections
                    if (product.englishDescription != null &&
                        product.englishDescription!.isNotEmpty) ...[
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Card(
                        elevation: 0,
                        color: Colors.grey[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            product.englishDescription!,
                            style: const TextStyle(fontSize: 14, height: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],

                    if (product.arabicDescription != null &&
                        product.arabicDescription!.isNotEmpty) ...[
                      const Text(
                        'الوصف',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Card(
                        elevation: 0,
                        color: Colors.grey[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            product.arabicDescription!,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 14, height: 1.5),
                          ),
                        ),
                      ),
                    ],

                    if ((product.englishDescription == null ||
                        product.englishDescription!.isEmpty) &&
                        (product.arabicDescription == null ||
                            product.arabicDescription!.isEmpty))
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.description_outlined,
                                  size: 48, color: Colors.grey[400]),
                              const SizedBox(height: 8),
                              Text(
                                'No description available',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 12),

                    // Additional Info for unavailable products
                    if (!product.isAvailable)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange[200]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'This product is currently not available. Please check back later or contact us for more information.',
                                style: TextStyle(
                                  color: Colors.orange[800],
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 32),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
      // bottomNavigationBar: FutureBuilder<Product?>(
      //   future: _productFuture,
      //   builder: (context, snapshot) {
      //     final product = snapshot.data;
      //     if (product == null) return const SizedBox.shrink();
      //
      //     return SafeArea(
      //       child: Padding(
      //         padding: const EdgeInsets.all(16),
      //         child: ElevatedButton.icon(
      //           onPressed: product.isAvailable && !_isAddingToCart
      //               ? () => _addToCart(product)
      //               : null,
      //           icon: _isAddingToCart
      //               ? const SizedBox(
      //             width: 20,
      //             height: 20,
      //             child: CircularProgressIndicator(
      //               strokeWidth: 2,
      //               color: Colors.white,
      //             ),
      //           )
      //               : const Icon(Icons.shopping_cart),
      //           label: Text(
      //             _isAddingToCart
      //                 ? 'Adding to Cart...'
      //                 : 'Order Now • ${(product.price * _quantity).toStringAsFixed(0)} EGP',
      //             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      //           ),
      //           style: ElevatedButton.styleFrom(
      //             padding: const EdgeInsets.symmetric(vertical: 16),
      //             backgroundColor: product.isAvailable ? Colors.brown : Colors.grey,
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(12),
      //             ),
      //           ),
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}