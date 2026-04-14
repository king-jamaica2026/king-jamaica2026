// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/foundation.dart' hide Category;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:king_jamaica_caffe/services/database_service.dart';
// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/category.dart';
// import '../models/product.dart';
//
// class AdminPanel extends StatefulWidget {
//   const AdminPanel({Key? key}) : super(key: key);
//
//   @override
//   State<AdminPanel> createState() => _AdminPanelState();
// }
//
// class _AdminPanelState extends State<AdminPanel> {
//   final MenuDatabase _db = MenuDatabase();
//   List<Category> _categories = [];
//   Map<int, List<Product>> _productsByCategory = {};
//   bool _isLoading = true;
//   bool _isUploading = false; // Track upload status
//
//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }
//
//   Future<void> _loadData() async {
//     setState(() => _isLoading = true);
//     try {
//       final categories = await _db.getAllCategories();
//       final allProducts = await _db.getAllProducts();
//
//       // Group products by categoryId
//       final Map<int, List<Product>> grouped = {};
//       for (final product in allProducts) {
//         grouped.putIfAbsent(product.categoryId, () => []).add(product);
//       }
//
//       setState(() {
//         _categories = categories;
//         _productsByCategory = grouped;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//       _showSnackBar('Error loading data: $e', isError: true);
//     }
//   }
//
//   void _showSnackBar(String message, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isError ? Colors.red : Colors.green,
//       ),
//     );
//   }
//
//   // Helper to generate a new ID for a category (max existing id + 1)
//   int _getNextCategoryId() {
//     if (_categories.isEmpty) return 1;
//     return _categories.map((c) => c.id).reduce((a, b) => a > b ? a : b) + 1;
//   }
//
//   // Helper to generate a new ID for a product (max existing id + 1)
//   int _getNextProductId() {
//     final allProducts = _productsByCategory.values.expand((list) => list).toList();
//     if (allProducts.isEmpty) return 1;
//     return allProducts.map((p) => p.id).reduce((a, b) => a > b ? a : b) + 1;
//   }
//
//   // Upload image to Supabase Storage
//   Future<String?> _uploadImageToSupabase(File imageFile, String folder) async {
//     try {
//       final fileName = '${folder}_${DateTime.now().millisecondsSinceEpoch}.jpg';
//       final fileBytes = await imageFile.readAsBytes();
//
//       // Upload to Supabase Storage
//       await Supabase.instance.client.storage
//           .from('menu-images')
//           .uploadBinary(fileName, fileBytes);
//
//       // Get public URL
//       final imageUrl = Supabase.instance.client.storage
//           .from('menu-images')
//           .getPublicUrl(fileName);
//
//       return imageUrl;
//     } catch (e) {
//       print('Error uploading image: $e');
//       return null;
//     }
//   }
//
//   // Pick and upload image
//   Future<String?> _pickAndUploadImage(String folder) async {
//     try {
//       final picker = ImagePicker();
//       final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//       if (pickedFile == null) return null;
//
//       setState(() => _isUploading = true);
//
//       String? imageUrl;
//
//       if (kIsWeb) {
//         // For web, convert to base64 and store directly in Supabase
//         final bytes = await pickedFile.readAsBytes();
//         final base64Image = base64Encode(bytes);
//         imageUrl = 'data:${pickedFile.mimeType};base64,$base64Image';
//
//         // Optionally upload base64 to Supabase Storage
//         // For now, store as base64 in the database
//       } else {
//         // For mobile, upload file to Supabase Storage
//         final file = File(pickedFile.path);
//         imageUrl = await _uploadImageToSupabase(file, folder);
//       }
//
//       setState(() => _isUploading = false);
//       return imageUrl;
//
//     } catch (e) {
//       setState(() => _isUploading = false);
//       _showSnackBar('Error picking image: $e', isError: true);
//       return null;
//     }
//   }
//
//   Future<void> _showCategoryDialog({Category? category}) async {
//     final isEditing = category != null;
//     final nameArController = TextEditingController(text: category?.arabicName ?? '');
//     final nameEnController = TextEditingController(text: category?.englishName ?? '');
//     String? selectedImagePath = category?.imagePath;
//
//     final formKey = GlobalKey<FormState>();
//
//     await showDialog(
//       context: context,
//       barrierDismissible: !_isUploading,
//       builder: (ctx) => StatefulBuilder(
//         builder: (ctx, setStateDialog) => AlertDialog(
//           title: Text(isEditing ? 'Edit Category' : 'Add Category'),
//           content: Form(
//             key: formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextFormField(
//                     controller: nameArController,
//                     decoration: const InputDecoration(labelText: 'Arabic Name'),
//                     validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
//                   ),
//                   TextFormField(
//                     controller: nameEnController,
//                     decoration: const InputDecoration(labelText: 'English Name'),
//                     validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
//                   ),
//                   const SizedBox(height: 16),
//                   // Image picker section
//                   Column(
//                     children: [
//                       _buildImagePreview(selectedImagePath),
//                       const SizedBox(height: 8),
//                       if (_isUploading)
//                         const CircularProgressIndicator()
//                       else
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             TextButton.icon(
//                               onPressed: () async {
//                                 final imageUrl = await _pickAndUploadImage('categories');
//                                 if (imageUrl != null) {
//                                   setStateDialog(() => selectedImagePath = imageUrl);
//                                 }
//                               },
//                               icon: const Icon(Icons.image),
//                               label: const Text('Select Image'),
//                             ),
//                             if (selectedImagePath != null)
//                               TextButton.icon(
//                                 onPressed: () => setStateDialog(() => selectedImagePath = null),
//                                 icon: const Icon(Icons.clear, size: 18),
//                                 label: const Text('Clear'),
//                               ),
//                           ],
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: _isUploading ? null : () => Navigator.pop(ctx),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: _isUploading
//                   ? null
//                   : () async {
//                 if (formKey.currentState!.validate()) {
//                   try {
//                     if (isEditing) {
//                       final updated = Category(
//                         id: category!.id,
//                         arabicName: nameArController.text,
//                         englishName: nameEnController.text,
//                         imagePath: selectedImagePath,
//                       );
//                       await _db.upsertCategory(updated);
//                     } else {
//                       final newCategory = Category(
//                         id: _getNextCategoryId(),
//                         arabicName: nameArController.text,
//                         englishName: nameEnController.text,
//                         imagePath: selectedImagePath,
//                       );
//                       await _db.upsertCategory(newCategory);
//                     }
//                     await _loadData();
//                     if (ctx.mounted) Navigator.pop(ctx);
//                     _showSnackBar(isEditing ? 'Category updated' : 'Category added');
//                   } catch (e) {
//                     _showSnackBar('Error: $e', isError: true);
//                   }
//                 }
//               },
//               child: Text(isEditing ? 'Update' : 'Add'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Helper to build image preview (takes selectedImagePath)
//   Widget _buildImagePreview(String? imagePath) {
//     if (imagePath == null || imagePath.isEmpty) {
//       return const Icon(Icons.image, size: 80, color: Colors.grey);
//     }
//
//     // Asset
//     if (imagePath.startsWith('assets/')) {
//       return Image.asset(imagePath, width: 100, height: 100, fit: BoxFit.cover);
//     }
//
//     // Base64 data URL (web)
//     if (imagePath.startsWith('data:image')) {
//       try {
//         final base64String = imagePath.split(',').last;
//         return Image.memory(base64Decode(base64String), width: 100, height: 100, fit: BoxFit.cover);
//       } catch (e) {
//         return const Icon(Icons.broken_image, size: 80, color: Colors.red);
//       }
//     }
//
//     // Network/Supabase URL
//     if (imagePath.startsWith('http')) {
//       return Image.network(
//         imagePath,
//         width: 100,
//         height: 100,
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) {
//           return const Icon(Icons.broken_image, size: 80, color: Colors.red);
//         },
//       );
//     }
//
//     // Assume file path (for local testing)
//     return Image.file(File(imagePath), width: 100, height: 100, fit: BoxFit.cover);
//   }
//
//   Future<void> _showProductDialog({Product? product, int? preselectedCategoryId}) async {
//     final isEditing = product != null;
//     final nameArController = TextEditingController(text: product?.arabicName ?? '');
//     final nameEnController = TextEditingController(text: product?.englishName ?? '');
//     final priceController = TextEditingController(text: product?.price.toString() ?? '');
//     final descArController = TextEditingController(text: product?.arabicDescription ?? '');
//     final descEnController = TextEditingController(text: product?.englishDescription ?? '');
//     final imagePathController = TextEditingController(text: product?.imagePath ?? '');
//     bool isAvailable = product?.isAvailable ?? true;
//     int? selectedCategoryId = product?.categoryId ?? preselectedCategoryId;
//
//     final formKey = GlobalKey<FormState>();
//
//     await showDialog(
//       context: context,
//       barrierDismissible: !_isUploading,
//       builder: (ctx) => StatefulBuilder(
//         builder: (ctx, setStateDialog) => AlertDialog(
//           title: Text(isEditing ? 'Edit Product' : 'Add Product'),
//           content: Form(
//             key: formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   DropdownButtonFormField<int>(
//                     value: selectedCategoryId,
//                     decoration: const InputDecoration(labelText: 'Category'),
//                     items: _categories.map((cat) {
//                       return DropdownMenuItem<int>(
//                         value: cat.id,
//                         child: Text('${cat.arabicName} (${cat.englishName})'),
//                       );
//                     }).toList(),
//                     onChanged: (value) => setStateDialog(() => selectedCategoryId = value),
//                     validator: (v) => v == null ? 'Select category' : null,
//                   ),
//                   TextFormField(
//                     controller: nameArController,
//                     decoration: const InputDecoration(labelText: 'Arabic Name'),
//                     validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
//                   ),
//                   TextFormField(
//                     controller: nameEnController,
//                     decoration: const InputDecoration(labelText: 'English Name'),
//                     validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
//                   ),
//                   TextFormField(
//                     controller: priceController,
//                     decoration: const InputDecoration(labelText: 'Price'),
//                     keyboardType: TextInputType.number,
//                     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                     validator: (v) {
//                       if (v?.isEmpty ?? true) return 'Required';
//                       if (int.tryParse(v!) == null) return 'Must be a number';
//                       return null;
//                     },
//                   ),
//                   TextFormField(
//                     controller: imagePathController,
//                     decoration: InputDecoration(
//                       labelText: 'Image Path',
//                       hintText: 'Enter image URL or use picker below',
//                     ),
//                     validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
//                   ),
//                   const SizedBox(height: 8),
//                   // Image picker for products
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       if (_isUploading)
//                         const CircularProgressIndicator()
//                       else
//                         TextButton.icon(
//                           onPressed: () async {
//                             final imageUrl = await _pickAndUploadImage('products');
//                             if (imageUrl != null) {
//                               setStateDialog(() => imagePathController.text = imageUrl);
//                             }
//                           },
//                           icon: const Icon(Icons.cloud_upload),
//                           label: const Text('Upload Image'),
//                         ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   // Image preview
//                   _buildImagePreview(imagePathController.text),
//                   const SizedBox(height: 8),
//                   TextFormField(
//                     controller: descArController,
//                     decoration: const InputDecoration(labelText: 'Arabic Description'),
//                     maxLines: 2,
//                   ),
//                   TextFormField(
//                     controller: descEnController,
//                     decoration: const InputDecoration(labelText: 'English Description'),
//                     maxLines: 2,
//                   ),
//                   SwitchListTile(
//                     title: const Text('Available'),
//                     value: isAvailable,
//                     onChanged: (value) => setStateDialog(() => isAvailable = value),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: _isUploading ? null : () => Navigator.pop(ctx),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: _isUploading
//                   ? null
//                   : () async {
//                 if (formKey.currentState!.validate() && selectedCategoryId != null) {
//                   try {
//                     final price = int.parse(priceController.text);
//                     if (isEditing) {
//                       final updated = Product(
//                         id: product!.id,
//                         categoryId: selectedCategoryId!,
//                         arabicName: nameArController.text,
//                         englishName: nameEnController.text,
//                         price: price,
//                         imagePath: imagePathController.text,
//                         englishDescription: descEnController.text,
//                         arabicDescription: descArController.text,
//                         isAvailable: isAvailable,
//                       );
//                       await _db.upsertProduct(updated);
//                     } else {
//                       final newProduct = Product(
//                         id: _getNextProductId(),
//                         categoryId: selectedCategoryId!,
//                         arabicName: nameArController.text,
//                         englishName: nameEnController.text,
//                         price: price,
//                         imagePath: imagePathController.text,
//                         englishDescription: descEnController.text,
//                         arabicDescription: descArController.text,
//                         isAvailable: isAvailable,
//                       );
//                       await _db.upsertProduct(newProduct);
//                     }
//                     await _loadData();
//                     if (ctx.mounted) Navigator.pop(ctx);
//                     _showSnackBar(isEditing ? 'Product updated' : 'Product added');
//                   } catch (e) {
//                     _showSnackBar('Error: $e', isError: true);
//                   }
//                 }
//               },
//               child: Text(isEditing ? 'Update' : 'Add'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Delete category with confirmation
//   Future<void> _deleteCategory(Category category) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Delete Category'),
//         content: Text('Delete "${category.arabicName}" and all its products?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx, false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(ctx, true),
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//     if (confirm == true) {
//       try {
//         await _db.deleteCategory(category.id);
//         await _loadData();
//         _showSnackBar('Category deleted');
//       } catch (e) {
//         _showSnackBar('Error deleting category: $e', isError: true);
//       }
//     }
//   }
//
//   // Delete product with confirmation
//   Future<void> _deleteProduct(Product product) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Delete Product'),
//         content: Text('Delete "${product.arabicName}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx, false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(ctx, true),
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//     if (confirm == true) {
//       try {
//         await _db.deleteProduct(product.id);
//         await _loadData();
//         _showSnackBar('Product deleted');
//       } catch (e) {
//         _showSnackBar('Error deleting product: $e', isError: true);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Admin Panel'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () => _showCategoryDialog(),
//             tooltip: 'Add Category',
//           ),
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _loadData,
//             tooltip: 'Refresh',
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: _loadData,
//         child: _isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : _categories.isEmpty
//             ? const Center(child: Text('No categories. Add one!'))
//             : ListView.builder(
//           itemCount: _categories.length,
//           itemBuilder: (ctx, idx) {
//             final category = _categories[idx];
//             final products = _productsByCategory[category.id] ?? [];
//             return Card(
//               margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               child: ExpansionTile(
//                 title: Text(
//                   '${category.arabicName} (${category.englishName})',
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 leading: category.imagePath != null
//                     ? ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: SizedBox(
//                     width: 40,
//                     height: 40,
//                     child: _buildImagePreview(category.imagePath),
//                   ),
//                 )
//                     : null,
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.edit, color: Colors.blue),
//                       onPressed: () => _showCategoryDialog(category: category),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       onPressed: () => _deleteCategory(category),
//                     ),
//                   ],
//                 ),
//                 children: [
//                   if (products.isEmpty)
//                     const Padding(
//                       padding: EdgeInsets.all(16),
//                       child: Text('No products in this category.'),
//                     )
//                   else
//                     ...products.map((product) => ListTile(
//                       leading: product.imagePath != null
//                           ? ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: SizedBox(
//                           width: 50,
//                           height: 50,
//                           child: _buildImagePreview(product.imagePath),
//                         ),
//                       )
//                           : null,
//                       title: Text(product.arabicName),
//                       subtitle: Text(
//                         '${product.englishName} - ${product.price} EGP\n${product.isAvailable ? "Available" : "Not Available"}',
//                       ),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.edit, size: 20),
//                             onPressed: () => _showProductDialog(
//                               product: product,
//                               preselectedCategoryId: category.id,
//                             ),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.delete, size: 20, color: Colors.red),
//                             onPressed: () => _deleteProduct(product),
//                           ),
//                         ],
//                       ),
//                     )),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                     child: TextButton.icon(
//                       onPressed: () => _showProductDialog(
//                         preselectedCategoryId: category.id,
//                       ),
//                       icon: const Icon(Icons.add),
//                       label: const Text('Add Product'),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:king_jamaica_caffe/services/database_service.dart';
import 'package:path_provider/path_provider.dart'; // if needed
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/category.dart';
import '../models/product.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final MenuDatabase _db = MenuDatabase();
  List<Category> _categories = [];
  Map<int, List<Product>> _productsByCategory = {};
  bool _isLoading = true;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final categories = await _db.getAllCategories();
      final allProducts = await _db.getAllProducts();

      final Map<int, List<Product>> grouped = {};
      for (final product in allProducts) {
        grouped.putIfAbsent(product.categoryId, () => []).add(product);
      }

      setState(() {
        _categories = categories;
        _productsByCategory = grouped;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Error loading data: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  int _getNextCategoryId() {
    if (_categories.isEmpty) return 1;
    return _categories.map((c) => c.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  int _getNextProductId() {
    final allProducts = _productsByCategory.values.expand((list) => list).toList();
    if (allProducts.isEmpty) return 1;
    return allProducts.map((p) => p.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  // Improved image upload with better error handling
  Future<String?> _uploadImageToSupabase(File imageFile, String folder) async {
    try {
      final fileName = '${folder}_${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';

      await Supabase.instance.client.storage
          .from('menu-images')
          .upload(fileName, imageFile);

      final imageUrl = Supabase.instance.client.storage
          .from('menu-images')
          .getPublicUrl(fileName);

      return imageUrl;
    } catch (e) {
      print('Error uploading image to Supabase: $e');
      _showSnackBar('Failed to upload image: $e', isError: true);
      return null;
    }
  }

  // Unified image picker + upload
  Future<String?> _pickAndUploadImage(String folder) async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile == null) return null;

      setState(() => _isUploading = true);

      String? imageUrl;

      if (kIsWeb) {
        // Web: Use base64 for simplicity (or upload bytes)
        final bytes = await pickedFile.readAsBytes();
        final base64Image = base64Encode(bytes);
        imageUrl = 'data:${pickedFile.mimeType ?? 'image/jpeg'};base64,$base64Image';
      } else {
        // Mobile: Upload actual file
        final file = File(pickedFile.path);
        imageUrl = await _uploadImageToSupabase(file, folder);
      }

      return imageUrl;
    } catch (e) {
      _showSnackBar('Error picking/uploading image: $e', isError: true);
      return null;
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  // ==================== CATEGORY DIALOG ====================
  Future<void> _showCategoryDialog({Category? category}) async {
    final isEditing = category != null;
    final nameArController = TextEditingController(text: category?.arabicName ?? '');
    final nameEnController = TextEditingController(text: category?.englishName ?? '');
    String? selectedImagePath = category?.imagePath;

    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      barrierDismissible: !_isUploading,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Edit Category' : 'Add Category'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameArController,
                    decoration: const InputDecoration(labelText: 'Arabic Name'),
                    validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: nameEnController,
                    decoration: const InputDecoration(labelText: 'English Name'),
                    validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildImagePreview(selectedImagePath),
                  const SizedBox(height: 12),
                  if (_isUploading)
                    const CircularProgressIndicator()
                  else
                    Column(
                      mainAxisAlignment: MainAxisAlignment. center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            final imageUrl = await _pickAndUploadImage('categories');
                            if (imageUrl != null && mounted) {
                              setDialogState(() => selectedImagePath = imageUrl);
                            }
                          },
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Select Image'),
                        ),
                        if (selectedImagePath != null)
                          const SizedBox(width: 8),
                        if (selectedImagePath != null)
                          TextButton.icon(
                            onPressed: () => setDialogState(() => selectedImagePath = null),
                            icon: const Icon(Icons.clear),
                            label: const Text('Remove'),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: _isUploading ? null : () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _isUploading
                  ? null
                  : () async {
                if (!formKey.currentState!.validate()) return;

                try {
                  final newCategory = Category(
                    id: isEditing ? category!.id : _getNextCategoryId(),
                    arabicName: nameArController.text.trim(),
                    englishName: nameEnController.text.trim(),
                    imagePath: selectedImagePath,
                  );

                  await _db.upsertCategory(newCategory);
                  await _loadData();

                  if (ctx.mounted) Navigator.pop(ctx);
                  _showSnackBar(isEditing ? 'Category updated successfully' : 'Category added successfully');
                } catch (e) {
                  _showSnackBar('Error saving category: $e', isError: true);
                }
              },
              child: Text(isEditing ? 'Update' : 'Add'),
            ),
          ],
        ),
      ),
    );

    // Dispose controllers
    nameArController.dispose();
    nameEnController.dispose();
  }

  // ==================== PRODUCT DIALOG ====================
  Future<void> _showProductDialog({Product? product, int? preselectedCategoryId}) async {
    final isEditing = product != null;
    final nameArController = TextEditingController(text: product?.arabicName ?? '');
    final nameEnController = TextEditingController(text: product?.englishName ?? '');
    final priceController = TextEditingController(text: product?.price.toString() ?? '');
    final descArController = TextEditingController(text: product?.arabicDescription ?? '');
    final descEnController = TextEditingController(text: product?.englishDescription ?? '');
    final imagePathController = TextEditingController(text: product?.imagePath ?? '');

    bool isAvailable = product?.isAvailable ?? true;
    int? selectedCategoryId = product?.categoryId ?? preselectedCategoryId;

    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      barrierDismissible: !_isUploading,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Edit Product' : 'Add Product'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                     Container(
                       constraints: BoxConstraints(maxWidth: 260),  // Set a max width
                       child: DropdownButtonFormField<int>(
                         isExpanded: true,
                         value: selectedCategoryId,
                        decoration: const InputDecoration(labelText: 'Category'),
                        items: _categories.map((cat) => DropdownMenuItem<int>(
                          value: cat.id,
                          child: Text('${cat.arabicName} (${cat.englishName})'),
                        )).toList(),
                        onChanged: (value) => setDialogState(() => selectedCategoryId = value),
                        validator: (v) => v == null ? 'Please select a category' : null,
                                             ),
                     ),
                  TextFormField(
                    controller: nameArController,
                    decoration: const InputDecoration(labelText: 'Arabic Name'),
                    validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: nameEnController,
                    decoration: const InputDecoration(labelText: 'English Name'),
                    validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Price (EGP)'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) {
                      if (v?.trim().isEmpty ?? true) return 'Required';
                      if (int.tryParse(v!) == null) return 'Invalid number';
                      return null;
                    },
                  ),
                  // TextFormField(
                  //   controller: imagePathController,
                  //   decoration: const InputDecoration(
                  //     labelText: 'Image URL',
                  //     hintText: 'Will be filled automatically when uploading',
                  //   ),
                  //   readOnly: true, // Optional: make it read-only since we use picker
                  // ),
                  const SizedBox(height: 12),
                  if (_isUploading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton.icon(
                      onPressed: () async {
                        final imageUrl = await _pickAndUploadImage('products');
                        if (imageUrl != null) {
                          setDialogState(() => imagePathController.text = imageUrl);
                        }
                      },
                      icon: const Icon(Icons.cloud_upload),
                      label: const Text('Upload Image'),
                    ),
                  const SizedBox(height: 12),
                  _buildImagePreview(imagePathController.text),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: descArController,
                    decoration: const InputDecoration(labelText: 'Arabic Description'),
                    maxLines: 2,
                  ),
                  TextFormField(
                    controller: descEnController,
                    decoration: const InputDecoration(labelText: 'English Description'),
                    maxLines: 2,
                  ),
                  SwitchListTile(
                    title: const Text('Available'),
                    value: isAvailable,
                    onChanged: (value) => setDialogState(() => isAvailable = value),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: _isUploading ? null : () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _isUploading
                  ? null
                  : () async {
                if (!formKey.currentState!.validate() || selectedCategoryId == null) return;

                try {
                  final price = int.parse(priceController.text);

                  final newProduct = Product(
                    id: isEditing ? product!.id : _getNextProductId(),
                    categoryId: selectedCategoryId!,
                    arabicName: nameArController.text.trim(),
                    englishName: nameEnController.text.trim(),
                    price: price,
                    imagePath: imagePathController.text,
                    englishDescription: descEnController.text.trim(),
                    arabicDescription: descArController.text.trim(),
                    isAvailable: isAvailable,
                  );

                  if (isEditing) {
                    await _db.upsertProduct(newProduct);
                  } else {
                    await _db.upsertProduct(newProduct);
                  }

                  await _loadData();
                  if (ctx.mounted) Navigator.pop(ctx);
                  _showSnackBar(isEditing ? 'Product updated' : 'Product added successfully');
                } catch (e) {
                  _showSnackBar('Error saving product: $e', isError: true);
                }
              },
              child: Text(isEditing ? 'Update' : 'Add'),
            ),
          ],
        ),
      ),
    );

    // Clean up
    nameArController.dispose();
    nameEnController.dispose();
    priceController.dispose();
    descArController.dispose();
    descEnController.dispose();
    imagePathController.dispose();
  }

  Widget _buildImagePreview(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.image, size: 50, color: Colors.grey),
      );
    }

    if (imagePath.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(imagePath, width: 120, height: 120, fit: BoxFit.cover),
      );
    }

    if (imagePath.startsWith('data:image')) {
      try {
        final base64String = imagePath.split(',').last;
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(base64Decode(base64String), width: 120, height: 120, fit: BoxFit.cover),
        );
      } catch (e) {
        return const Icon(Icons.broken_image, size: 60, color: Colors.red);
      }
    }

    // Network image (Supabase or other URL)
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imagePath,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 60, color: Colors.red),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const SizedBox(
            width: 120,
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  Future<void> _deleteCategory(Category category) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Delete "${category.arabicName}" and all its products?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _db.deleteCategory(category.id);
        await _loadData();
        _showSnackBar('Category deleted successfully');
      } catch (e) {
        _showSnackBar('Error deleting category: $e', isError: true);
      }
    }
  }

  Future<void> _deleteProduct(Product product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Delete "${product.arabicName}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _db.deleteProduct(product.id);
        await _loadData();
        _showSnackBar('Product deleted successfully');
      } catch (e) {
        _showSnackBar('Error deleting product: $e', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCategoryDialog(),
            tooltip: 'Add New Category',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _categories.isEmpty
            ? const Center(child: Text('No categories yet. Tap + to add one.'))
            : ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            final products = _productsByCategory[category.id] ?? [];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ExpansionTile(
                leading: category.imagePath != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: _buildImagePreview(category.imagePath),
                  ),
                )
                    : const Icon(Icons.category),
                title: Text(
                  '${category.arabicName} (${category.englishName})',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showCategoryDialog(category: category),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteCategory(category),
                    ),
                  ],
                ),
                children: [
                  if (products.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No products in this category yet.'),
                    )
                  else
                    ...products.map((product) => ListTile(
                      leading: product.imagePath != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: _buildImagePreview(product.imagePath),
                        ),
                      )
                          : null,
                      title: Text(product.arabicName),
                      subtitle: Text(
                        '${product.englishName} • ${product.price} EGP\n${product.isAvailable ? "✓ Available" : "✗ Not Available"}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showProductDialog(
                              product: product,
                              preselectedCategoryId: category.id,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteProduct(product),
                          ),
                        ],
                      ),
                    )),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextButton.icon(
                      onPressed: () => _showProductDialog(preselectedCategoryId: category.id),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Product to this Category'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}