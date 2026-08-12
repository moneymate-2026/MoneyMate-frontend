import 'package:flutter_application_1/features/authentication/datasources/dio_interceptor.dart';
import 'package:flutter_application_1/features/profile/presentation/pages/models/complaint_model.dart';

import 'package:flutter_riverpod/legacy.dart';


class ComplaintState {
  final bool isLoading;
  final bool isSubmitting;
  final List<ComplaintModel> complaints;
  final String? error;

  ComplaintState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.complaints = const [],
    this.error,
  });

  ComplaintState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    List<ComplaintModel>? complaints,
    String? error,
  }) {
    return ComplaintState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      complaints: complaints ?? this.complaints,
      error: error,
    );
  }
}

class ComplaintNotifier extends StateNotifier<ComplaintState> {
  ComplaintNotifier() : super(ComplaintState());

  // TODO: Backend endpoint vannaal ithu update cheyyuka
  final String _endpoint = "/api/v1/complaints";

  Future<void> fetchComplaints() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await dio.get(_endpoint);
      final List data = response.data["data"];
      final list = data.map((e) => ComplaintModel.fromJson(e)).toList();
      state = state.copyWith(isLoading: false, complaints: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Reports load cheyyan pattiyilla");
    }
  }

  Future<bool> submitComplaint(String title, String description) async {
    state = state.copyWith(isSubmitting: true, error: null);
    try {
      await dio.post(_endpoint, data: {
        "Title": title,
        "Description": description,
      });
      state = state.copyWith(isSubmitting: false);
      await fetchComplaints();
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: "Complaint submit cheyyan pattiyilla");
      return false;
    }
  }
}

final complaintProvider =
    StateNotifierProvider<ComplaintNotifier, ComplaintState>((ref) {
  return ComplaintNotifier();
});