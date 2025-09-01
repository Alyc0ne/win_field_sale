import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:win_field_sale/features/appointment/models/appointment_detail.dart';
import 'package:win_field_sale/features/appointment/models/appointment_status.dart';
import 'package:win_field_sale/features/appointment/models/appointment_type.dart';
import 'package:win_field_sale/features/appointment/models/product.dart';
import 'package:win_field_sale/features/appointment/models/purpose.dart';
import 'package:win_field_sale/features/appointment/models/territory.dart';
import 'package:win_field_sale/features/appointment/services/appointment_service.dart';
import 'package:win_field_sale/features/appointment/viewmodels/appointment_detail_viewmodel.dart';
import 'package:win_field_sale/features/appointment/viewmodels/appointment_edit_viewmodel.dart';
import 'package:win_field_sale/features/appointment/viewmodels/appointment_viewmodel.dart';
import 'package:win_field_sale/features/appointment/viewmodels/appointment_visit_viewmodel.dart';

final appointmentServiceProvider = Provider<AppointmentService>((ref) => AppointmentService());
final appointmentProvider = Provider<AppointmentViewModel>((ref) => AppointmentViewModel());
final appointmentDetailProvider = StateNotifierProvider.autoDispose.family<AppointmentDetailViewModel, AsyncValue<AppointmentDetail>, String>((ref, id) {
  return AppointmentDetailViewModel(ref, id);
});

final appointmentEditProvider = StateNotifierProvider.autoDispose.family<AppointmentEditViewModel, AppointmentEditState, String>((ref, id) {
  return AppointmentEditViewModel(ref, id);
});

final appointmentVisitProvider = StateNotifierProvider.autoDispose.family<AppointmentVisitViewModel, AsyncValue<AppointmentDetail>, String>((ref, id) {
  return AppointmentVisitViewModel(ref, id);
});

final productsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  return await ref.read(appointmentServiceProvider).fetchProducts();
});

final appointmentTypeProvider = FutureProvider.autoDispose<List<AppointmentType>>((ref) async {
  return await ref.read(appointmentServiceProvider).fetchAppointmentType();
});

final appointmentStatusProvider = FutureProvider.autoDispose<List<AppointmentStatus>>((ref) async {
  return await ref.read(appointmentServiceProvider).fetchAppointmentStatus();
});

final purposesProvider = FutureProvider.autoDispose<List<Purpose>>((ref) async {
  return await ref.read(appointmentServiceProvider).fetchPurposes();
});

final territoryProvider = FutureProvider.autoDispose<List<Territory>>((ref) async {
  return await ref.read(appointmentServiceProvider).fetchTerritories();
});
