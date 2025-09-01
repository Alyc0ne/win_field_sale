import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:win_field_sale/core/base_provider.dart';
import 'package:win_field_sale/features/appointment/models/appointment_detail.dart';
import 'package:win_field_sale/features/appointment/services/appointment_service.dart';

class AppointmentVisitViewModel extends StateNotifier<AsyncValue<AppointmentDetail>> {
  AppointmentVisitViewModel(this.ref, this.id) : super(const AsyncValue.loading()) {
    fetch();
  }

  final Ref ref;
  final String id;

  AppointmentService get _appointmentService => ref.read(appointmentServiceProvider);

  Future<void> fetch() async {
    state = await AsyncValue.guard(() => _appointmentService.fetchAppointmentById(id));
  }

  Future<void> actionVisit() async {
    // state = state.whenData((value) => value.copyWith(address: value.address.copyWith(isVisit: true)));

    // state = state.copyWith(data: state.data.whenData((v) => v.copyWith(appointmentTypeId: status.appointmentTypeID, appointmentTypeName: status.appointmentTypeName)), isDirty: true);
    // await AsyncValue.guard(() => _appointmentService.actionVisit(id));
    // state = state.copyWith(isLoading: false);
  }
}
