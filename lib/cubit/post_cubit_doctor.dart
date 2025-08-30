import 'dart:convert';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:patient_project/ConstantURL.dart';
import 'package:patient_project/cubit/post_state_doctor.dart';
import 'package:patient_project/models/modelDoctor_appointment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostCubitDoctor extends Cubit<PostStateDoctor> {
  int _page = 1;
  final int _limit = 10;
  bool _hasReachedMax = false;
  Timer? _tokenRefreshTimer;

  PostCubitDoctor() : super(PostInitialDoctor()) {
    _setupTokenRefresh();
  }

  @override
  Future<void> close() {
    _tokenRefreshTimer?.cancel();
    return super.close();
  }

  void _setupTokenRefresh() {
    _tokenRefreshTimer = Timer.periodic(const Duration(minutes: 30), (_) async {
      await _refreshToken();
    });
  }

  Future<String?> _refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refresh_token');

      if (refreshToken == null) return null;

      final response = await http.post(
        Uri.parse("$baseUrl/api/auth/refresh"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refresh_token': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newToken = data['access_token'];
        if (newToken != null) {
          await prefs.setString('token', newToken);
          return newToken;
        }
      }
    } catch (_) {}
    return null;
  }

  Future<bool> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (token == null || !isLoggedIn
    ) {
      emit(PostErrorDoctor("يجب تسجيل الدخول أولاً"));
      return false;
    }
    return true;
  }

  Future<void> fetchAppointments({bool initialLoad = true}) async {
    if (!await _checkAuthStatus()) return;
    if (_hasReachedMax && !initialLoad) return;

    try {
      final currentState = state;
      List<dynamic> oldAppointments = [];

      if (initialLoad) {
        _page = 1;
        _hasReachedMax = false;
      } else if (currentState is PostLoadedDoctor) {
        oldAppointments = currentState.appointments;
      }

      emit(PostLoadingDoctor(oldAppointments, isFirstFetch: initialLoad));

      var token = await getToken();
      if (token == null) {
        emit(PostErrorDoctor("انتهت الجلسة، يرجى تسجيل الدخول مجدداً"));
        return;
      }

      final response = await http.get(
        Uri.parse(
            "$baseUrl/api/doctorAppointments?page=$_page&limit=$_limit"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Accept-Language': 'ar',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['appointments'] != null) {
          final List newAppointments = (data['appointments'] as List)
              .map((appointment) => Appointment.fromJson(appointment))
              .toList();

          if (newAppointments.isEmpty) {
            _hasReachedMax = true;
            emit(PostLoadedDoctor(oldAppointments, hasReachedMax: true));
            return;
          }

          final existingIds = oldAppointments.map((a) => a.id).toSet();
          final uniqueNewAppointments = newAppointments
              .where((a) => !existingIds.contains(a.id))
              .toList();

          final allAppointments = [...oldAppointments, ...uniqueNewAppointments];

          _hasReachedMax = data['next_page_url'] == null;
          _page++;

          emit(PostLoadedDoctor(allAppointments, hasReachedMax: _hasReachedMax));
        } else {
          emit(PostErrorDoctor("لا توجد مواعيد متاحة"));
        }
      } else if (response.statusCode == 401) {
        token = await _refreshToken();
        if (token != null) {
          await fetchAppointments(initialLoad: initialLoad);
        } else {
          emit(PostErrorDoctor("انتهت الجلسة، يرجى تسجيل الدخول مجدداً"));
        }
      } else {
        emit(PostErrorDoctor("خطأ في الخادم: ${response.statusCode}"));
      }
    } catch (e) {
      emit(PostErrorDoctor("حدث خطأ في الاتصال: ${e.toString()}"));
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
