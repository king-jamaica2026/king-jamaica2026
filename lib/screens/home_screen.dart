// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:king_jamaica_caffe/screens/admin_panel.dart';
// import 'package:king_jamaica_caffe/services/database_service.dart';
//
// import '../models/category.dart';
// import 'product_list_screen.dart';
// import '../utils/screen_util.dart';
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   late Future<List<Category>> _categoriesFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _categoriesFuture = MenuDatabase().getAllCategories();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final backgroundImage = context.responsive<String>(
//       mobile: 'assets/bg_mobile.jpg',
//       tablet: 'assets/bg_tablet.jpg',
//       desktop: 'assets/bg_desktop.jpg',
//     );
//
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(backgroundImage),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Column(
//           children: [
//             // Title section
//             Container(
//               width: double.infinity,
//               color: Colors.transparent,
//               padding: EdgeInsets.symmetric(
//                 vertical: context.responsive<double>(
//                   mobile: 16,
//                   tablet: 20,
//                   desktop: 24,
//                 ),
//               ),
//
//                child: GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const AdminPanel()),
//                     );
//                   },
//                   child: const Text(
//                     'King Jamaica Caffe',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       shadows: [
//                         Shadow(
//                           blurRadius: 8,
//                           color: Colors.black45,
//                           offset: Offset(2, 2),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//             ),
//
//             // Main content
//             Expanded(
//               child: FutureBuilder<List<Category>>(
//                 future: _categoriesFuture,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(
//                       child: CircularProgressIndicator(color: Colors.white),
//                     );
//                   }
//
//                   if (snapshot.hasError) {
//                     return Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(Icons.error_outline, color: Colors.red, size: 60),
//                           const SizedBox(height: 16),
//                           Text(
//                             'حدث خطأ أثناء تحميل القائمة\n${snapshot.error}',
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(color: Colors.white, fontSize: 18),
//                           ),
//                           const SizedBox(height: 16),
//                           ElevatedButton(
//                             onPressed: () => setState(() {
//                               _categoriesFuture = MenuDatabase().getAllCategories();
//                             }),
//                             child: const Text('إعادة المحاولة'),
//                           ),
//                         ],
//                       ),
//                     );
//                   }
//
//                   final categories = snapshot.data ?? [];
//
//                   if (categories.isEmpty) {
//                     return const Center(
//                       child: Text(
//                         'لا توجد فئات متاحة حالياً',
//                         style: TextStyle(color: Colors.white70, fontSize: 20),
//                       ),
//                     );
//                   }
//
//                   return Padding(
//                     padding: EdgeInsets.all(
//                       context.responsive<double>(
//                         mobile: 16.0,
//                         tablet: 30.0,
//                         desktop: 60.0,
//                       ),
//                     ),
//                     child: MasonryGridView.count(
//                       crossAxisCount: context.responsive<int>(
//                         mobile: 2,
//                         tablet: 3,
//                         desktop: 4,
//                       ),
//                       mainAxisSpacing: 12,
//                       crossAxisSpacing: 12,
//                       itemCount: categories.length,
//                       itemBuilder: (context, index) {
//                         final cat = categories[index];
//
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ProductListScreen(category: cat),
//                               ),
//                             );
//                           },
//                           child: Card(
//                             elevation: 6,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             clipBehavior: Clip.antiAlias,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.stretch,
//                               children: [
//                                 // Category image
//                                 AspectRatio(
//                                   aspectRatio: 4 / 3,
//                                   child: Image.asset(
//                                     cat.imagePath ?? 'assets/placeholder_category.jpg',
//                                     fit: BoxFit.cover,
//                                     errorBuilder: (context, error, stackTrace) => Container(
//                                       color: Colors.grey[300],
//                                       child: const Icon(Icons.image_not_supported, size: 50),
//                                     ),
//                                   ),
//                                 ),
//
//                                 // Text content
//                                 Padding(
//                                   padding: const EdgeInsets.all(12.0),
//                                   child: Column(
//                                     children: [
//                                       Text(
//                                         cat.englishName,
//                                         style: TextStyle(
//                                           fontSize: context.responsive<double>(
//                                             mobile: 15,
//                                             tablet: 17,
//                                             desktop: 19,
//                                           ),
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         cat.arabicName,
//                                         style: TextStyle(
//                                           fontSize: context.responsive<double>(
//                                             mobile: 13,
//                                             tablet: 15,
//                                             desktop: 17,
//                                           ),
//                                           color: Colors.grey[700],
//                                         ),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:king_jamaica_caffe/screens/admin_panel.dart';
import 'package:king_jamaica_caffe/services/database_service.dart';
import '../models/category.dart';
import 'product_list_screen.dart';
import '../utils/screen_util.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Category>> _categoriesFuture;
  final MenuDatabase _db = MenuDatabase();

  // Track if we're in admin mode (optional)
  bool _isAdminMode = false;
  int _tapCount = 0;
  Timer? _tapTimer;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _tapTimer?.cancel();
    super.dispose();
  }

  void _loadCategories() {
    setState(() {
      _categoriesFuture = _db.getAllCategories();
    });
  }

  // Handle admin access (optional: tap title 5 times to access admin panel)
  void _handleTitleTap() {
    _tapCount++;

    if (_tapTimer != null) {
      _tapTimer!.cancel();
    }

    _tapTimer = Timer(const Duration(milliseconds: 500), () {
      if (_tapCount >= 2) {
        _navigateToAdminPanel();
      }
      _tapCount = 0;
    });
  }

  void _navigateToAdminPanel() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminPanel()),
    ).then((_) {
      // Refresh categories when returning from admin panel
      _loadCategories();
    });
  }

  // Helper to build category image
  Widget _buildCategoryImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        color: Colors.grey[300],
        child: const Icon(Icons.image_not_supported, size: 50),
      );
    }

    // Handle different image types
    if (imagePath.startsWith('http')) {
      // Network image (Supabase storage or external URL)
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, size: 50),
        ),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[300],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );
    } else if (imagePath.startsWith('data:image')) {
      // Base64 image (web uploads)
      try {
        final base64String = imagePath.split(',').last;
        return Image.memory(
          base64Decode(base64String),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, size: 50),
          ),
        );
      } catch (e) {
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, size: 50),
        );
      }
    } else if (imagePath.startsWith('assets/')) {
      // Asset image
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[300],
          child: const Icon(Icons.image_not_supported, size: 50),
        ),
      );
    } else {
      // Local file path (fallback)
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, size: 50),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundImage = context.responsive<String>(
      mobile: 'assets/bg_mobile.jpg',
      tablet: 'assets/bg_tablet.jpg',
      desktop: 'assets/bg_desktop.jpg',
    );

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              // Title section with admin access
              Container(
                width: double.infinity,
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(
                  vertical: context.responsive<double>(
                    mobile: 8,
                    tablet: 20,
                    desktop: 24,
                  ),
                ),
                child: GestureDetector(
                  onTap: _handleTitleTap,
                  onLongPress: () {
                    // Long press also opens admin panel (alternative access)
                    _navigateToAdminPanel();
                  },
                  child: Column(
                    children: [
                      // Text(
                      //   'King Jamaica Caffe',
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     fontSize: context.responsive<double>(
                      //       mobile: 24,
                      //       tablet: 28,
                      //       desktop: 32,
                      //     ),
                      //     fontWeight: FontWeight.bold,
                      //     color: Colors.white,
                      //     shadows: const [
                      //       Shadow(
                      //         blurRadius: 8,
                      //         color: Colors.black45,
                      //         offset: Offset(2, 2),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Image.asset(
                        'assets/logo.png',
                        height: context.responsive<double>(
                          mobile: 90,
                          tablet: 100,
                          desktop: 120,
                        ),
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.restaurant,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                      if (_isAdminMode)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Admin Mode',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Main content
              Expanded(
                child: FutureBuilder<List<Category>>(
                  future: _categoriesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red, size: 60),
                            const SizedBox(height: 16),
                            Text(
                              'حدث خطأ أثناء تحميل القائمة\n${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadCategories,
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      );
                    }

                    final categories = snapshot.data ?? [];

                    if (categories.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'لا توجد فئات متاحة حالياً',
                              style: TextStyle(color: Colors.white70, fontSize: 20),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _loadCategories,
                              icon: const Icon(Icons.refresh),
                              label: const Text('تحديث'),
                            ),
                          ],
                        ),
                      );
                    }

                    return
                      SafeArea(
                        child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          context.responsive<double>(
                            mobile: 20.0,
                            tablet: 30.0,
                            desktop: 60.0,
                          ),
                          0,
                          context.responsive<double>(
                            mobile: 20.0,
                            tablet: 30.0,
                            desktop: 60.0,
                          ),
                          0
                        ),
                        child:
                        MasonryGridView.count(
                          crossAxisCount: context.responsive<int>(
                            mobile: 2,
                            tablet: 3,
                            desktop: 4,
                          ),
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final cat = categories[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductListScreen(category: cat),
                                  ),
                                ).then((_) {
                                  // Optional: refresh data when returning from product screen
                                  // _loadCategories();
                                });
                              },
                              child: Card(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Category image
                                    AspectRatio(
                                      aspectRatio: 4 / 3,
                                      child: _buildCategoryImage(cat.imagePath),
                                    ),

                                    // Text content
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            cat.englishName,
                                            style: TextStyle(
                                              fontSize: context.responsive<double>(
                                                mobile: 15,
                                                tablet: 17,
                                                desktop: 19,
                                              ),
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            cat.arabicName,
                                            style: TextStyle(
                                              fontSize: context.responsive<double>(
                                                mobile: 13,
                                                tablet: 15,
                                                desktop: 17,
                                              ),
                                              color: Colors.grey[700],
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                                          ),
                      );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}