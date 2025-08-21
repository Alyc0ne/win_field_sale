import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:win_field_sale/core/base_provider.dart';
import 'package:win_field_sale/features/appointment/models/appointment_detail.dart';
import 'package:win_field_sale/features/appointment/services/appointment_service.dart';

class AppointmentEditViewModel extends StateNotifier<AsyncValue<AppointmentDetail>> {
  AppointmentEditViewModel(this.ref, this.id) : super(const AsyncValue.loading()) {
    fetch();
  }

  final Ref ref;
  final String id;

  AppointmentService get _appointmentService => ref.read(appointmentServiceProvider);

  Future<void> fetch() async {
    state = await AsyncValue.guard(() => _appointmentService.fetchAppointmentById(id));
  }

  Future<void> refresh() => fetch();
}
