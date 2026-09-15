import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/io.dart';
/// سرویس مرکزی برای ارتباط با API
class ApiService {
  static const String baseUrl = 'https://rumiland.org';

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late final Dio _dio;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 120),
      sendTimeout: const Duration(seconds: 120),
      headers: {'Accept': 'application/json'},
    ));

    // ⚠️ موقت: برای تست SSL. بعداً حذف می‌کنیم.
    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          await clearToken();
        }
        handler.next(error);
      },
    ));

    _initialized = true;
  }
  Dio get dio => _dio;

  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';
  static const _userPhoneKey = 'user_phone';
  static const _userNameKey = 'user_name';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> saveUser({
    required int id,
    required String phone,
    String? fullName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, id);
    await prefs.setString(_userPhoneKey, phone);
    if (fullName != null) await prefs.setString(_userNameKey, fullName);
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userPhoneKey);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userPhoneKey);
    await prefs.remove(_userNameKey);
  }

  Future<void> logout() async {
    await clearToken();
  }

  Future<Map<String, dynamic>> register({
    required String phone,
    required String password,
    String? fullName,
  }) async {
    try {
      final res = await _dio.post('/api/auth/register', data: {
        'phone': phone,
        'password': password,
        if (fullName != null) 'full_name': fullName,
      });
      final data = res.data as Map<String, dynamic>;
      await saveToken(data['access_token']);
      final user = data['user'] as Map<String, dynamic>;
      await saveUser(
        id: user['id'],
        phone: user['phone'],
        fullName: user['full_name'],
      );
      return data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    try {
      final res = await _dio.post('/api/auth/login', data: {
        'phone': phone,
        'password': password,
      });
      final data = res.data as Map<String, dynamic>;
      await saveToken(data['access_token']);
      final user = data['user'] as Map<String, dynamic>;
      await saveUser(
        id: user['id'],
        phone: user['phone'],
        fullName: user['full_name'],
      );
      return data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> me() async {
    try {
      final res = await _dio.get('/api/auth/me');
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<String> uploadImage(File file) async {
    try {
      final filename = file.path.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: filename),
      });
      final res = await _dio.post('/api/upload/image', data: formData);
      return (res.data as Map<String, dynamic>)['file_path'] as String;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<String> uploadVideo(File file) async {
    try {
      final filename = file.path.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: filename),
      });
      final res = await _dio.post(
        '/api/upload/video',
        data: formData,
        options: Options(sendTimeout: const Duration(minutes: 5)),
      );
      return (res.data as Map<String, dynamic>)['file_path'] as String;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getProperties({
    String? q,
    String? dealType,
    String? categoryId,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final res = await _dio.get('/api/properties', queryParameters: {
        if (q != null && q.isNotEmpty) 'q': q,
        if (dealType != null) 'deal_type': dealType,
        if (categoryId != null) 'category_id': categoryId,
        'limit': limit,
        'offset': offset,
      });
      return (res.data as List).cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getProperty(int id) async {
    try {
      final res = await _dio.get('/api/properties/$id');
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getMyProperties() async {
    try {
      final res = await _dio.get('/api/my/properties');
      return (res.data as List).cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> createProperty(
      Map<String, dynamic> data) async {
    try {
      final res = await _dio.post('/api/properties', data: data);
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteProperty(int id) async {
    try {
      await _dio.delete('/api/properties/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    try {
      final res = await _dio.get('/api/favorites');
      return (res.data as List).cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> addFavorite(int propertyId) async {
    try {
      await _dio.post('/api/favorites/$propertyId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> removeFavorite(int propertyId) async {
    try {
      await _dio.delete('/api/favorites/$propertyId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  static String fullUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '$baseUrl/uploads/$path';
  }

  String _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'اتصال به سرور قطع شد. اینترنت را چک کنید';
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'اتصال به سرور ممکن نیست';
    }
    if (e.response != null) {
      final data = e.response!.data;
      if (data is Map && data['detail'] != null) {
        return data['detail'].toString();
      }
      if (e.response!.statusCode == 401) return 'لطفاً وارد شوید';
      if (e.response!.statusCode == 403) return 'دسترسی ندارید';
      if (e.response!.statusCode == 404) return 'یافت نشد';
      if (e.response!.statusCode == 500) return 'خطای سرور';
      return 'خطا: ${e.response!.statusCode}';
    }
    return 'خطای ناشناخته: ${e.message}';
  }
}
