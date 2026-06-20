import 'package:cartify/data/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productProvider=FutureProvider((ref)async {
  return ApiService().fetchProducts();
},);