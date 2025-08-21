import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:win_field_sale/features/appointment/models/appointment_detail.dart';
import 'package:win_field_sale/features/appointment/models/product.dart';
import 'package:win_field_sale/features/appointment/services/appointment_service.dart';
import 'package:win_field_sale/features/appointment/viewmodels/appointment_detail_viewmodel.dart';
import 'package:win_field_sale/features/appointment/viewmodels/appointment_edit_viewmodel.dart';
import 'package:win_field_sale/features/appointment/viewmodels/appointment_viewmodel.dart';

final appointmentServiceProvider = Provider<AppointmentService>((ref) => AppointmentService());
final appointmentProvider = Provider<AppointmentViewModel>((ref) => AppointmentViewModel());
final appointmentDetailProvider = StateNotifierProvider.autoDispose.family<AppointmentDetailViewModel, AsyncValue<AppointmentDetail>, String>((ref, id) {
  return AppointmentDetailViewModel(ref, id);
});
final appointmentEditProvider = StateNotifierProvider.autoDispose.family<AppointmentEditViewModel, AsyncValue<AppointmentDetail>, String>((ref, id) {
  return AppointmentEditViewModel(ref, id);
});

final productsProvider = FutureProvider.autoDispose<List<Product>>((ref) {
  return ref.read(appointmentServiceProvider).fetchProducts();
});
