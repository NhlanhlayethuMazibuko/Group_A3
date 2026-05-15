import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/application_model.dart';

class ApplicationViewModel extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  List<ApplicationModel> _applications = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ApplicationModel> get applications => _applications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> createApplication({
    required String year,
    required String module1Level,
    required String module1,
    String? module2Level,
    String? module2,
    String? documentUrl,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        _errorMessage = "User not logged in";
        return false;
      }

      await _supabase.from('applications').insert({
        'user_id': user.id,
        'year_of_study': year,
        'module1_level': module1Level,
        'module1_name': module1,
        'module2_level': module2Level,
        'module2_name': module2,
        'is_eligible': false,
        'status': 'pending',
        'document_url': documentUrl,
      });

      await fetchApplications();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchApplications() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final response = await _supabase
          .from('applications')
          .select()
          .eq('user_id', user.id);

      _applications = response
          .map<ApplicationModel>((json) => ApplicationModel.fromJson(json))
          .toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllApplications() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase
          .from('applications')
          .select()
          .order('created_at', ascending: false);

      _applications = response
          .map<ApplicationModel>((json) => ApplicationModel.fromJson(json))
          .toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // UPDATE Application
  Future<bool> updateApplication({
    required String id,
    required String year,
    required String module1,
    String? module2,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _supabase
          .from('applications')
          .update({'year': year, 'module_1': module1, 'module_2': module2})
          .match({'id': id});

      await fetchApplications();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // DELETE Application
  Future<bool> deleteApplication(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _supabase.from('applications').delete().match({'id': id});
      await fetchApplications();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // UPDATE STATUS: Admin side
  Future<void> updateStatus(String id, String status) async {
    await _supabase
        .from('applications')
        .update({
          'status': status,
          'is_eligible': status == 'approved' ? true : false,
        })
        .match({'id': id});

    await fetchAllApplications();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
